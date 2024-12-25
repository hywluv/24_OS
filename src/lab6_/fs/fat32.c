#include "fat32.h"
#include "printk.h"
#include "virtio.h"
#include "string.h"
#include "mbr.h"
#include "mm.h"

struct fat32_bpb fat32_header;
struct fat32_volume fat32_volume;

uint8_t fat32_buf[VIRTIO_BLK_SECTOR_SIZE];
uint8_t fat32_table_buf[VIRTIO_BLK_SECTOR_SIZE];

uint64_t cluster_to_sector(uint64_t cluster) {
    return (cluster - 2) * fat32_volume.sec_per_cluster + fat32_volume.first_data_sec;
}

uint32_t sector_to_cluster(uint64_t sector) {
    return (sector - fat32_volume.first_data_sec) / fat32_volume.sec_per_cluster + 2;
}

uint32_t next_cluster(uint64_t cluster) {
    uint64_t fat_offset = cluster * 4; // 每个簇在 FAT 表中占用 4 字节
    uint64_t fat_sector = fat32_volume.first_fat_sec + fat_offset / VIRTIO_BLK_SECTOR_SIZE;
    virtio_blk_read_sector(fat_sector, fat32_table_buf);
    int index_in_sector = fat_offset % (VIRTIO_BLK_SECTOR_SIZE / sizeof(uint32_t)); // 扇区内偏移量
    return *(uint32_t*)(fat32_table_buf + index_in_sector);
}

void fat32_init(uint64_t lba, uint64_t size) {
    virtio_blk_read_sector(lba, (void*)&fat32_header);

    fat32_volume.first_fat_sec = lba + fat32_header.rsvd_sec_cnt;/* to calculate */
    fat32_volume.sec_per_cluster = fat32_header.sec_per_clus;/* to calculate */
    fat32_volume.first_data_sec = fat32_volume.first_fat_sec + fat32_header.num_fats * fat32_header.fat_sz32;/* to calculate */
    fat32_volume.fat_sz = fat32_header.fat_sz32;/* to calculate */

    Log("FAT32 Volume Info:");
    Log("  First FAT Sector: %llu", fat32_volume.first_fat_sec);
    Log("  Sector per Cluster: %llu", fat32_volume.sec_per_cluster);
    Log("  First Data Sector: %llu", fat32_volume.first_data_sec);
    Log("  FAT Table Size: %llu sectors", fat32_volume.fat_sz);

    // virtio_blk_read_sector(fat32_volume.first_data_sec, fat32_buf);
}

int is_fat32(uint64_t lba) {
    virtio_blk_read_sector(lba, (void*)&fat32_header);
    if (fat32_header.boot_sector_signature != 0xaa55) {
        return 0;
    }
    return 1;
}

int next_slash(const char* path) {  // util function to be used in fat32_open_file
    int i = 0;
    while (path[i] != '\0' && path[i] != '/') {
        i++;
    }
    if (path[i] == '\0') {
        return -1;
    }
    return i;
}

void to_upper_case(char *str) {     // util function to be used in fat32_open_file
    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] >= 'a' && str[i] <= 'z') {
            str[i] -= 32;
        }
    }
}

uint32_t count_clusters(uint32_t first_cluster) {
    uint32_t count = 0;

    while (first_cluster < 0x0FFFFFF8) {
        count++;
        first_cluster = next_cluster(first_cluster);
    }

    return count;
}

struct fat32_file fat32_open_file(const char *path) {
    struct fat32_file file;
    char path_copy[MAX_PATH_LENGTH];
    memset(path_copy, ' ', MAX_PATH_LENGTH);
    path_copy[MAX_PATH_LENGTH - 1] = '\0';
    uint64_t len = strlen(path);
    if(len < 7 || len > 15) {
        Err("path err");
    }
    memcpy(path_copy, path + 7, len - 7); // ignore "/fat32/" fill the rest with ' '
    Log("path_copy: %s, len: %d, path: %s", path_copy, len, path);
    to_upper_case(path_copy);
    

    uint64_t sector = fat32_volume.first_data_sec;
    uint32_t cluster = sector_to_cluster(sector);
    uint32_t count = count_clusters(cluster);

    virtio_blk_read_sector(sector, fat32_buf);
    struct fat32_dir_entry *entry = (struct fat32_dir_entry *)fat32_buf;

    for (int i = 0; i < fat32_volume.sec_per_cluster * count; i++) {
        for (int j = 0; j < FAT32_ENTRY_PER_SECTOR; j++) {
            if (memcmp(entry[j].name, path_copy, 8) == 0) {
                Log("file name: %s", entry[j].name);
                file.cluster = (uint32_t)entry[j].starthi << 16 | entry[j].startlow;
                file.dir.index = j;
                file.dir.cluster = cluster;
                return file;
            }
        }
        sector++;
        virtio_blk_read_sector(sector, fat32_buf);
    }
    Log("file not found");
    memset(&file, 0, sizeof(struct fat32_file));

    return file;
}

int64_t fat32_lseek(struct file* file, int64_t offset, uint64_t whence) {
    if (whence == SEEK_SET) {
        file->cfo = offset/* to calculate */;
    } else if (whence == SEEK_CUR) {
        file->cfo = file->cfo + offset/* to calculate */;
    } else if (whence == SEEK_END) {
        /* Calculate file length */
        uint64_t sector = cluster_to_sector(file->fat32_file.dir.cluster) + file->fat32_file.dir.index / FAT32_ENTRY_PER_SECTOR;
        virtio_blk_read_sector(sector, fat32_table_buf);
        uint32_t index = file->fat32_file.dir.index % FAT32_ENTRY_PER_SECTOR;
        struct fat32_dir_entry *entry = (struct fat32_dir_entry *)fat32_table_buf;
        file->cfo = entry[index].size + offset/* to calculate */;
    } else {
        Err("fat32_lseek: whence not implemented");
        while (1);
    }
    return file->cfo;
}

uint64_t fat32_table_sector_of_cluster(uint32_t cluster) {
    return fat32_volume.first_fat_sec + cluster / (VIRTIO_BLK_SECTOR_SIZE / sizeof(uint32_t));
}

// int64_t fat32_read(struct file* file, void* buf, uint64_t len) {
//     /* todo: read content to buf, and return read length */
//     return 0;
// }

// int64_t fat32_write(struct file* file, const void* buf, uint64_t len) {
//     /* todo: fat32_write */
//     return 0;
// }

uint32_t find_cluster(uint32_t file_start_cluster, int64_t cfo) {
    uint32_t cluster_offset = cfo / (fat32_volume.sec_per_cluster * VIRTIO_BLK_SECTOR_SIZE);
    for (int i = 0; i < cluster_offset && file_start_cluster < 0xffffff8; i++) {
        file_start_cluster = next_cluster(file_start_cluster);
    }
    return file_start_cluster;
}

int64_t fat32_read(struct file *file, void *buf, uint64_t len) {
    uint64_t sector = cluster_to_sector(file->fat32_file.dir.cluster) + file->fat32_file.dir.index / FAT32_ENTRY_PER_SECTOR;
    virtio_blk_read_sector(sector, fat32_table_buf);
    uint32_t index = file->fat32_file.dir.index % FAT32_ENTRY_PER_SECTOR;
    struct fat32_dir_entry *entry = (struct fat32_dir_entry *)fat32_table_buf;
    uint64_t filesz = entry[index].size;

    uint64_t read_len = 0;
    while (read_len < len && file->cfo < filesz) {
        
        uint32_t cluster = find_cluster(file->fat32_file.cluster, file->cfo);// 当前簇 
        uint64_t sector = cluster_to_sector(cluster); // 当前扇区
        uint64_t offset_in_sector = file->cfo % VIRTIO_BLK_SECTOR_SIZE; // 当前扇区内偏移
        uint64_t read_size = VIRTIO_BLK_SECTOR_SIZE - offset_in_sector; // 当前扇区内剩余可读字节数
        read_size = min(read_size, len - read_len);
        read_size = min(read_size, filesz - file->cfo);
        virtio_blk_read_sector(sector, fat32_buf);
        memcpy(buf, fat32_buf + offset_in_sector, read_size);

        file->cfo += read_size;
        buf += read_size;
        read_len += read_size;
    }

    return read_len;
}

int64_t fat32_write(struct file *file, const void *buf, uint64_t len) {
    uint64_t write_len = 0;
    while (len > 0) {
        uint32_t cluster = find_cluster(file->fat32_file.cluster, file->cfo);
        uint64_t sector = cluster_to_sector(cluster);
        uint64_t offset_in_sector = file->cfo % VIRTIO_BLK_SECTOR_SIZE;
        uint64_t write_size = VIRTIO_BLK_SECTOR_SIZE - offset_in_sector;
        if (write_size > len) {
            write_size = len;
        }

        virtio_blk_read_sector(sector, fat32_buf);
        memcpy(fat32_buf + offset_in_sector, buf, write_size);
        virtio_blk_write_sector(sector, fat32_buf);

        file->cfo += write_size;
        buf += write_size;
        len -= write_size;
        write_len += write_size;
    }
    return write_len;
}
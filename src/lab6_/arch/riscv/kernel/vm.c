#include "vm.h"
#include "virtio.h"

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
    /* 
     * 1. 由于是进行 1GiB 的映射，这里不需要使用多级页表 
     * 2. 将 va 的 64bit 作为如下划分： | high bit | 9 bit | 30 bit |
     *     high bit 可以忽略
     *     中间 9 bit 作为 early_pgtbl 的 index
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/

   // clear early_pgtbl
    memset(early_pgtbl, 0x0, PGSIZE);

    uint64_t entry_perm = 0xF; // V | R | W | X (0b1111)

    for (uint64_t i = 0; i < VM_SIZE; i += EARLY_PGSIZE ){
        map_vm(VM_START + i, PHY_START + i, entry_perm);
        map_vm(PHY_START + i, PHY_START + i, entry_perm);
    }

    printk("...setup_vm done\n");
    return;
}

void map_vm(uint64_t va, uint64_t pa, uint64_t perm){
    uint64_t idx = (va >> 30) & 0x1FF;
    uint64_t entry = ((pa >> 12) << 10) | perm;
    early_pgtbl[idx] = entry;
}

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

uint64_t setup_pgtbl(uint64_t *pgtbl, uint64_t pte_idx, uint64_t perm) {
    uint64_t pte = VA2PA((uint64_t)kalloc()); // PA
    pgtbl[pte_idx] = ((pte >> 12) << 10) | perm;
    return pgtbl[pte_idx];
}

void setup_vm_final() {
    printk("...setup_vm_final\n");
    memset(swapper_pg_dir, 0x0, PGSIZE);

    // No OpenSBI mapping required

    uint64_t p_base = PHY_START + OPENSBI_SIZE;
    uint64_t v_base = VM_START + OPENSBI_SIZE;
    uint64_t p_end = PHY_END;
    uint64_t v_end = PHY_END + PA2VA_OFFSET;

    // mapping kernel text X|-|R|V
    uint64_t kernel_start = v_base;
    uint64_t kernel_end = PGROUNDUP((uint64_t)_etext);
    create_mapping(swapper_pg_dir, kernel_start, VA2PA(kernel_start), kernel_end - kernel_start, PTE_V | PTE_R | PTE_X);
    printk("kernel_start = %lx, kernel_end = %lx, perm = %lx\n\n", kernel_start, kernel_end, PTE_V | PTE_R | PTE_X);

    // mapping kernel rodata -|-|R|V
    uint64_t rodata_start = kernel_end;
    uint64_t rodata_end = PGROUNDUP((uint64_t)_erodata);
    create_mapping(swapper_pg_dir, rodata_start, VA2PA(rodata_start), rodata_end - rodata_start, PTE_V | PTE_R);
    printk("rodata_start = %lx, rodata_end = %lx, perm = %lx\n\n", rodata_start, rodata_end, PTE_V | PTE_R);

    // mapping other memory -|W|R|V
    uint64_t data_start = rodata_end;
    uint64_t data_end = v_end;
    create_mapping(swapper_pg_dir, data_start, VA2PA(data_start), data_end - data_start, PTE_V | PTE_R | PTE_W);
    printk("data_start = %lx, data_end = %lx, perm = %lx\n\n", data_start, data_end, PTE_V | PTE_R | PTE_W);

    // lab6
    create_mapping(swapper_pg_dir, io_to_virt(VIRTIO_START), VIRTIO_START, VIRTIO_SIZE * VIRTIO_COUNT, PTE_W | PTE_R | PTE_V);

    // set satp with swapper_pg_dir
    uint64_t satp = get_satp(swapper_pg_dir); // TODO
    csr_write(satp, satp);

    // YOUR CODE HERE
    printk("satp = %lx\n", satp);

    // flush TLB
    asm volatile("sfence.vma zero, zero");

    // flush icache
    asm volatile("fence.i");
    return;
}

uint64_t get_satp(uint64_t *pgtbl){
    uint64_t pa_pgtbl = VA2PA((uint64_t)pgtbl);
    return (SV39 << 60) | (pa_pgtbl >> 12);
}

uint64_t vmflags2pte(uint64_t vm_flags){
    return ((vm_flags & VM_READ) ? PTE_R : 0) | ((vm_flags & VM_WRITE) ? PTE_W : 0) | ((vm_flags & VM_EXEC) ? PTE_X : 0);
}

/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
    /*
     * pgtbl 为根页表的基地址
     * va, pa 为需要映射的虚拟地址、物理地址
     * sz 为映射的大小，单位为字节
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
   printk("mapping : %lx -> %lx, size = %lx\n", va, pa, sz);
   for(uint64_t va_cur = va, pa_cur = pa; va_cur < va + sz; va_cur += PGSIZE, pa_cur += PGSIZE){
       map_vm_final(pgtbl, va_cur, pa_cur, perm);
   }
}

void map_vm_final(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t perm){
    uint64_t idx1 = (va >> 30) & 0x1FF;
    uint64_t idx2 = (va >> 21) & 0x1FF;
    uint64_t idx3 = (va >> 12) & 0x1FF;

    uint64_t pte = pgtbl[idx1];
    if(PTE_ISVALID(pte) == 0){
        pte = setup_pgtbl(pgtbl, idx1, PTE_V);
    }
    // printk("pte1 = %lx\n", pte);

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12) + PA2VA_OFFSET); // VA
    uint64_t pte2 = pgtbl2[idx2];
    if(PTE_ISVALID(pte2) == 0){
        pte2 = setup_pgtbl(pgtbl2, idx2, PTE_V);
    }
    // printk("pte2 = %lx\n", pte2);

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12) + PA2VA_OFFSET);// VA
    perm = perm | PTE_V;
    pgtbl3[idx3] = (pa >> 12 << 10) | perm;
}

uint64_t* get_kernel_pgtbl() { return swapper_pg_dir; }

uint64_t get_pte(uint64_t *pgtbl, uint64_t va){
    uint64_t idx1 = (va >> 30) & 0x1FF;
    uint64_t idx2 = (va >> 21) & 0x1FF;
    uint64_t idx3 = (va >> 12) & 0x1FF;

    uint64_t pte = pgtbl[idx1];
    if(PTE_ISVALID(pte) == 0){
        return 0;
    }

    uint64_t *pgtbl2 = (uint64_t *)(((pte >> 10) << 12) + PA2VA_OFFSET);
    uint64_t pte2 = pgtbl2[idx2];
    if(PTE_ISVALID(pte2) == 0){
        return 0;
    }

    uint64_t *pgtbl3 = (uint64_t *)(((pte2 >> 10) << 12) + PA2VA_OFFSET);
    return pgtbl3[idx3];
}

int va_mapped(uint64_t *pgtbl, uint64_t va){
    uint64_t pte = get_pte(pgtbl, va);
    return PTE_ISVALID(pte);
}
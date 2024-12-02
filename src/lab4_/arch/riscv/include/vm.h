#ifndef __VM_H__
#define __VM_H__

#include "defs.h"
#include "printk.h"
#include "string.h"
#include "mm.h"

void setup_vm();
void map_vm(uint64_t va, uint64_t pa, uint64_t perm);

// VA
extern char _stext[];
extern char _etext[];
extern char _srodata[];
extern char _erodata[];
extern char _sdata[];
extern char _edata[];

uint64_t setup_pgtbl(uint64_t *pgtbl, uint64_t pte_idx, uint64_t perm);
void setup_vm_final();
uint64_t get_satp(uint64_t *pgtbl);
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);
void map_vm_final(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t perm);
#endif
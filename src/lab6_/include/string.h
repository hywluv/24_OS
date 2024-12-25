#ifndef __STRING_H__
#define __STRING_H__

#include "stdint.h"
#include "stddef.h"

void *memset(void *, int, uint64_t);
void *memcpy(void *, const void *, uint64_t);
uint64_t memcmp(const void *s1, const void *s2, size_t n);
size_t strlen(const char *s);

#endif

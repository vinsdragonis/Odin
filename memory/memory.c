#include "memory.h"
#include "../print.h"
#include "../debug/debug.h"

static struct FreeMemRegion free_mem_region[50];

void init_memory(void)
{
    int32_t count = *(int32_t*)0x9000;
    uint64_t total_mem = 0;
    struct E820 *mem_map = (struct E820*)0x9008;
    int free_region_count = 0;

    ASSERT(count <= 50);

    for (int32_t i = 0; i < count; i++)
    {
        if (mem_map[i].type == 1)
        {
            free_mem_region[free_region_count].address = mem_map[i].address;
            free_mem_region[free_region_count].length = mem_map[i].length;
            total_mem += mem_map[i].length;
            free_region_count++;
        }

        printk("%x  %uKB  %u\n", mem_map[i].address, mem_map[i].length / 1024, (uint64_t)mem_map[i].type);
    }

    printk("Total memory is %uMB\n", total_mem / 1024 / 1024);
}

#include "debug.h"
#include "print.h"

void error_check(char *file, uint64_t line) {
    printk("\n\n-------------------------------------\n");
    printk("             ERROR CHECK");
    printk("\n-------------------------------------\n");
    printk("Assertion failed [%s:%u]\n", file, line);

    while (1) {}
}
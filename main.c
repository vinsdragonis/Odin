#include "./trap/trap.h"
#include "print/print.h"
#include "./memory/memory.h"

void KMain(void)
{
   init_idt();
   init_memory();
   init_kvm();
   show_total_memory();
}
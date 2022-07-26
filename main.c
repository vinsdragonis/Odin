#include "./trap/trap.h"
#include "print/print.h"
#include "./memory/memory.h"
#include "./process/process.h"

void KMain(void)
{
   init_idt();
   init_memory();
   init_kvm();
   init_process();
   launch();
   // show_total_memory();
}

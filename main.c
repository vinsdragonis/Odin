#include "./trap/trap.h"
#include "print.h"
#include "./memory/memory.h"

void KMain(void)
{
   init_idt();
   init_memory();
}
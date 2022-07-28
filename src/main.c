#include "../include/trap.h"
#include "../include/print.h"
#include "../include/memory.h"
#include "../include/process.h"
#include "../include/syscall.h"

void KMain(void)
{ 
   init_idt();
   init_memory();  
   init_kvm();
   init_system_call();
   init_process();
   launch();
}
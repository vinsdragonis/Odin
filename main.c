#include "trap.h"
#include "print.h"
#include "memory.h"
#include "process.h"
#include "syscall.h"

void KMain(void)
{ 
   init_idt();
   init_memory();  
   init_kvm();
   init_system_call();
   init_process();
   launch();
}
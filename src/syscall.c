#include "../include/syscall.h"
#include "../include/print.h"
#include "../include/debug.h"
#include "../include/stddef.h"

static SYSTEMCALL system_calls[10];

static int sys_write(int64_t *argptr)
{    
    write_screen((char*)argptr[0], (int)argptr[1], 0xe);  
    return (int)argptr[1];
}

void init_system_call(void)
{
    system_calls[0] = sys_write;
}

void system_call(struct TrapFrame *tf)
{
    int64_t i = tf->rax;
    int64_t param_count = tf->rdi;
    int64_t *argptr = (int64_t*)tf->rsi;

    if (param_count < 0 || i != 0) { 
        tf->rax = -1;
        return;
    }
    
    ASSERT(system_calls[i] != NULL);
    tf->rax = system_calls[i](argptr);
}
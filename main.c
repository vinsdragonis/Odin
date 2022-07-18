#include "trap.h"
#include "print.h"

void KMain(void)
{
   char *string = "Odin";
   // int64_t value = 0x123456789ABCD;
   
   init_idt();

   printk("%s\n", string);
   printk("Developed by: Dragonis");
}
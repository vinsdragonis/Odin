#include "./trap/trap.h"
#include "print.h"
#include "debug.h"

void KMain(void)
{
   char *string = "Odin";
   
   init_idt();

   printk("%s\n", string);
   printk("Developed by: Dragonis");
   ASSERT(0);
}
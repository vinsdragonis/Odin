section .text
global start
extern main
extern exitu

start:
    call main
    call exitu
    jmp $
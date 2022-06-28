mov ah, 0x0e

mov al, [the_secret]
int 0x10

mov bx, 0x7c00
mov ds, bx

mov al, [the_secret]
int 0x10

mov al, [es:the_secret]
int 0x10

mov bx, 0x7c00
mov es, bx
mov al, [es:the_secret]
int 0x10

jmp $

the_secret:
    db "X"

times 510-($-$$) db 0
dw 0xaa55
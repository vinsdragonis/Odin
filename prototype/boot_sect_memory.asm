mov ah, 0x0e

mov al, "1"
int 0x10
mov bx, the_secret
add bx, 0x7c00
mov al, [bx]
int 0x10

jmp $

the_secret:
    db "X"

times 510-($-$$) db 0
dw 0xaa55
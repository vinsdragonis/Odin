[BITS 16]
[ORG 0x7e00]

start:
    mov [DriveId], dl
    
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb NotSupport

    mov eax, 0x80000001
    cpuid
    test edx, (1 << 29)
    
    mov ah, 0x13
    jz NotSupport
    test edx, (1 << 26)
    jz NotSupport

LoadKernel:
    mov si, ReadPacket
    mov word[si], 0x10
    mov word[si + 2], 100
    mov word[si + 4], 0
    mov word[si + 6], 0x1000
    mov dword[si + 8], 6
    mov dword[si + 0xc], 0
    mov dl, [DriveId]
    mov ah, 0x42
    int 0x13
    jc ReadError

GetMemInfoStart:
    mov eax, 0xe820
    mov edx, 0x534d4150
    mov ecx, 20
    mov edi, 0x9000
    xor ebx, ebx
    int 0x15
    jc NotSupport

GetMemInfo:
    add edi, 20
    mov eax, 0xe820
    mov edx, 0x534d4150
    mov ecx, 20
    int 0x15
    jc GetMemDone

    test ebx, ebx
    jnz GetMemInfo

GetMemDone:

TestA20:
    mov ax, 0xffff
    mov es, ax
    mov word[ds:0x7c00], 0xa200
    cmp word[ds:0x7c10], 0xa200
    jne SetA20LineDone
    mov word[0x7c00], 0xb200
    mov word[es:0x7c10], 0xb200
    je End

SetA20LineDone:
    xor ax, ax
    mov es, ax

SetVideoMode:
    mov ax, 3
    int 0x10

    mov si, Message
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov cx, MessageLen

PrintMessage:
    mov al, [si]
    mov [es:di], al

    mov byte[es:di+1], 0xf
    add di, 2
    add si, 1
    loop PrintMessage

ReadError:
NotSupport:
End:
    hlt
    jmp End

DriveId:    db 0
Message:    db "Text mode is on"
MessageLen: equ $-Message
ReadPacket: times 16 db 0
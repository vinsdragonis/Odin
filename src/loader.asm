[BITS 16]
[ORG 0x7e00]

start:
    mov [DriveId],dl

    mov eax,0x80000000
    cpuid
    cmp eax,0x80000001
    jb NotSupport

    mov eax,0x80000001
    cpuid
    test edx,(1<<29)
    jz NotSupport
    test edx,(1<<26)
    jz NotSupport

LoadKernel:
    mov si,ReadPacket
    mov word[si],0x10
    mov word[si+2],100
    mov word[si+4],0
    mov word[si+6],0x1000
    mov dword[si+8],6
    mov dword[si+0xc],0
    mov dl,[DriveId]
    mov ah,0x42
    int 0x13
    jc  ReadError

LoadUser:
    mov si,ReadPacket
    mov word[si],0x10
    mov word[si+2],10
    mov word[si+4],0
    mov word[si+6],0x2000
    mov dword[si+8],106
    mov dword[si+0xc],0
    mov dl,[DriveId]
    mov ah,0x42
    int 0x13
    jc  ReadError

LoadUser2:
    mov si,ReadPacket
    mov word[si],0x10
    mov word[si+2],10
    mov word[si+4],0
    mov word[si+6],0x3000
    mov dword[si+8],116
    mov dword[si+0xc],0
    mov dl,[DriveId]
    mov ah,0x42
    int 0x13
    jc  ReadError

LoadUser3:
    mov si,ReadPacket
    mov word[si],0x10
    mov word[si+2],10
    mov word[si+4],0
    mov word[si+6],0x4000
    mov dword[si+8],126
    mov dword[si+0xc],0
    mov dl,[DriveId]
    mov ah,0x42
    int 0x13
    jc  ReadError

GetMemInfoStart:
    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20
    mov dword[0x9000],0
    mov edi,0x9008
    xor ebx,ebx
    int 0x15
    jc NotSupport

GetMemInfo:
    add edi,20
    inc dword[0x9000]   
    test ebx,ebx
    jz GetMemDone

    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20
    int 0x15
    jnc GetMemInfo


GetMemDone:
TestA20:
    mov ax,0xffff
    mov es,ax
    mov word[ds:0x7c00],0xa200
    cmp word[es:0x7c10],0xa200
    jne SetA20LineDone
    mov word[0x7c00],0xb200
    cmp word[es:0x7c10],0xb200
    je End
    
SetA20LineDone:
    xor ax,ax
    mov es,ax

SetVideoMode:
    mov ax,3
    int 0x10
    
    cli
    lgdt [Gdt32Ptr]
    lidt [Idt32Ptr]

    mov eax,cr0
    or eax,1
    mov cr0,eax

    jmp 8:PMEntry

ReadError:
NotSupport:
End:
    hlt
    jmp End


[BITS 32]
PMEntry:
    mov ax,0x10
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov esp,0x7c00

    cld
    mov edi,0x70000
    xor eax,eax
    mov ecx,0x10000/4
    rep stosd
    
    mov dword[0x70000],0x71003
    mov dword[0x71000],10000011b

    mov eax,(0xffff800000000000>>39)
    and eax,0x1ff
    mov dword[0x70000+eax*8],0x72003
    mov dword[0x72000],10000011b

    lgdt [Gdt64Ptr]

    mov eax,cr4
    or eax,(1<<5)
    mov cr4,eax

    mov eax,0x70000
    mov cr3,eax

    mov ecx,0xc0000080
    rdmsr
    or eax,(1<<8)
    wrmsr

    mov eax,cr0
    or eax,(1<<31)
    mov cr0,eax

    jmp 8:LMEntry

PEnd:
    hlt
    jmp PEnd

[BITS 64]
LMEntry:
    mov rsp,0x7c00

    cld
    mov rdi,0x200000
    mov rsi,0x10000
    mov rcx,51200/8
    rep movsq

    mov rax,0xffff800000200000
    jmp rax
    
LEnd:
    hlt
    jmp LEnd
    
    

DriveId:    db 0
ReadPacket: times 16 db 0

Gdt32:
    dq 0
Code32:
    dw 0xffff
    dw 0
    db 0
    db 0x9a
    db 0xcf
    db 0
Data32:
    dw 0xffff
    dw 0
    db 0
    db 0x92
    db 0xcf
    db 0
    
Gdt32Len: equ $-Gdt32

Gdt32Ptr: dw Gdt32Len-1
          dd Gdt32

Idt32Ptr: dw 0
          dd 0


Gdt64:
    dq 0
    dq 0x0020980000000000

Gdt64Len: equ $-Gdt64


Gdt64Ptr: dw Gdt64Len-1
          dd Gdt64
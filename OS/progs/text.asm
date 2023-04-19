org 100h
mov ax, 2
int 10h
push 0xb800
pop es
_start:
xor ax, ax
int 16h
cmp ah, 1
je .r
stosb
inc di
jmp _start
.r:
ret

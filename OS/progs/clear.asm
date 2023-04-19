org 100h
mov ax,2
int 10h
push 0xb800
pop es
mov di, 0
mov si,l 
mov cx, 12
rep movsw
mov al, 0xd2
out 0x64, al
mov al, 0x1c
out 0x60, al
.x:
mov ax, 0
int 16h
cmp ah, 0x1c
jne .x
ret
l:
db "haealalaoa awaoaralada!a" 

org 100h
jmp x
l:
db "haealalaoa awaoaralada!a" 
x: mov ax,2
int 10h
push 0xb800
pop es
mov di, 0
mov si,l 
mov cx, 12
rep movsw

ret

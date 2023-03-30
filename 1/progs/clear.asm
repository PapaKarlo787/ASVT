org 100h
mov ax,2
int 10h
push 0xb800
pop es
mov di, 0
mov si,l 
mov cx, 12
rep movsw
mov ax, 0
int 16h
ret
l:
db "haealalaoa awaoaralada!a" 

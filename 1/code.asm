org 0x7c00

xor dx, dx
mov ax, 0x0201
mov cx, 2
mov bx, 0x500
int 13h

jmp 0x500

times 510-($-$$) db 0
db 0x55, 0xaa	

mov ax, [k]
int 10h
jmp $

k:
dw 3

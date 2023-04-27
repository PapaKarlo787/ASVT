org 100h
jmp _start
int8:
	push es
	push di
	push cx
	push ax
	mov al, [cs:.x]
	add byte[cs:.x], 16
	push 0xb800
	pop es
	mov cx, 2000
	mov di, 1
.l:
	mov [es:di], al
	add di, 2
	loop .l
	mov al, 0x20
	out 0x20, al
	pop ax
	pop cx
	pop di
	pop es
	iret
.x: db 7

_start:
	pop fs
	cli
	mov word [fs:8*4], int8
	mov word [fs:8*4+2], cs
	sti
	mov dx, _start
	int 0x27

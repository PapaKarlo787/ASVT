macro load_ax_in_es_bx
{
    pusha
	mov cx, 18
	xor dx, dx
	div cx
	inc dx				; sector at track
	mov cx, ax
	mov ax, dx
	xor dx, dx
	shr cx, 1
	jnc .zhead
	mov dh, 1
.zhead:
	shl cx, 8
	add cx, ax
	mov ax, 0x0201
	int 13h
	popa
}

macro prep_env
{
	mov ax, 2
	int 0x10
	xor sp, sp
	mov ds, sp
	mov es, [free_mem_edge]
	push 0x9000
	push 0xb800
	pop fs
	pop ss
	
	xor bx, bx
	mov si, bx
	mov di, bx
}

macro prep_exec
{
	mov [free_mem_edge], es
	mov ax, es
	sub ax, 15
	mov es, ax
	mov ds, ax
	mov fs, ax
	mov ss, ax
	mov gs, ax
	mov word [es:240], 0x20cd
	xor ax, ax
	mov bx, ax
	mov cx, ax
	mov dx, ax
	mov si, ax
	mov di, ax
	mov sp, ax
	mov bp, ax
	push 240
}

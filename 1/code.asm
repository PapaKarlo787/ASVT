org 0x7c00
res=18
include "H_FAT.asm"


	mov cx, [0x7c0e]	; reserved
	mov bx, 0x500		; datapointer
	mov ax, 1			; logical sector for booting
lp_res:
	pusha
	mov cx, 18
	xor dx, dx
	div cx
	inc dx				; sector at track
	mov cx, ax
	mov ax, dx
	xor dx, dx
	shr cx, 1
	jnc zhead
	mov dh, 1
zhead:
	shl cx, 6
	add cx, ax
	mov ax, 0x0201
	int 13h
	popa
	add bh, 0x2
	inc ax
	loop lp_res
	jmp l



times 510-($-$$) db 0
db 0x55, 0xaa	

org 0x500
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
l:
	mov ax, [k]
	int 10h
	jmp $
k:
	dw 2
times 512*res-($-$$) db 0
dd 0x0ffffff0, 0x0fffffff, 0x0ffffff8
times 1440*1024-($-$$) db 0

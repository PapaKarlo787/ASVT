org 0x7c00
res=2
include "H_FAT.asm"

	mov cx, res-1		; reserved
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
	shl cx, 8
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
l:
	mov ax, 2
	int 10h
	jmp $
times 512*(res-1)-($-$$) db 0
dd 0x0ffffff0, 0x0fffffff, 0x0ffffff8
times 1440*1024-($-$$)-512 db 0

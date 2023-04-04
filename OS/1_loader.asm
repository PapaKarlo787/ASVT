include "H_FAT.asm"
include "macro.asm"
	mov cx, res-1		; reserved
	mov ax, [spf]
	mov bx, [fats]
	mul bx
	add cx, ax
	mov bx, free		; datapointer
	mov ax, 1			; logical sector for booting
lp_res:
	load_ax_in_es_bx
	add bh, 0x2
	inc ax
	loop lp_res

	sub ax, 2
	mov [startDataSec], ax
	shr bx, 4
	mov [free_mem_edge], bx
	mov ax, [root_p]
	mov word [cur_dir], ax
	mov word [cs:0x20*4], int20
	mov word [cs:0x20*4+2], cs
	mov word [cs:0x27*4], int27
	mov word [cs:0x27*4+2], cs
	jmp load_dir

times 510-($-$$) db 0
db 0x55, 0xaa	

paint:
	mov cx, 20
.lp:
	mov [fs:di+1], al
	add di, 2
	loop .lp
	sub di, 40
	ret

load_data:
	mov ax, bp
	add ax, [startDataSec]
	load_ax_in_es_bx
	add bh, 2
	shl bp, 2
	mov bp, [ds:startFatAddr + bp]
	cmp bp, 0xfff8
	jb load_data
	ret

int27:
	test dx, 15
	jz .ni
	add dx, 15
.ni:
	shr dx, 4
	add [cs:free_mem_edge], dx
int20:
	jmp load_dir

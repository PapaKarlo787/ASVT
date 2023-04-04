org 0x7c00
res=2
free=0x500
root=2
include "1_loader.asm"

org free	
load_dir:
	prep_env
	mov bp, [cur_dir]
	call load_data
	mov bp, si
pnames:
	mov cx, 11
	mov al, [es:si+11]
	cmp al, 0x20
	je .file
	cmp al, 0x10
	jne .next_rec
.dir:
	mov byte [fs:di+30], 'D'
	jmp .pname
.file:
	mov byte [fs:di+30], 'F'
.pname:
	mov al, [es:si]
	mov [fs:di], al
	add di, 2
	inc si
	loop .pname
	add di, 18
	mov al, [es:si]
	mov [es:bp], al
	mov ax, [es:si+0x0f]
	or ax, ax
	jne .ok
	add al, 2
.ok:
	mov [es:bp+1], ax
	add bp, 4
	jmp .fin_rec
.next_rec:
	add si, 11
.fin_rec:
	add si, 21
	
	cmp bx, si
	jne pnames
	shr bp, 2
	dec bp
	mov [max_file_num], bp

	xor di, di
	mov bx, di
	mov al, 0x3f
	call paint

epl = 1
act:
	mov ah, 0
	int 0x16
	cmp ah, 0x48
	je .up
	cmp ah, 0x1c
	je .enter
	cmp ah, 0x50
	jne act
.down:
	cmp bx, [max_file_num]
	je act
	mov al, 0x07
	call paint
	add bx, epl
	add di, 40*epl
	mov al, 0x3f
	call paint
	jmp act
.up:
	cmp bx, 0
	je act
	mov al, 0x07
	call paint
	sub bx, epl
	sub di, 40*epl
	mov al, 0x3f
	call paint
	jmp act
.enter:
	shl bx, 2
	mov bp, [es:bx+1]
	mov al, [es:bx]
	cmp al, 0x20
	je .file
	mov [cur_dir], bp
	jmp load_dir

.file:
	mov bx, 256
	call load_data
	prep_exec
	push es
	push 256
	retf

include "funcs.asm"
startFatAddr = free + 0x200 * (res - 1)
startDataSec:	dw 0
cur_dir:		dw 0
max_file_num:	dw 0
root_dir:		dw root
free_mem_edge:	dw 0

times 512*(res-1)-($-$$) db 0
dd 0x0ffffff0, 0x0fffffff, 0x0ffffff8
times 1440*1024-($-$$)-512 db 0

org 100h

mov ax, 2
int 10h
mov ah, 2
mov bh, 0
mov dx, 0x1900
int 10h

mov bp, d
mov cx, 128
mov ax, 0x1100
mov bx, 0x1000
mov dx, 128
int 10h

mov cx, es
mov bx, buf
shr bx, 4
inc bx
add cx, bx
mov es, cx

push 0xb800
pop fs
mov byte [fs:1], 83

_start:
	xor ax, ax
	int 16h
	cmp ah, 1
	jne editor
	ret
editor:
	mov bx, [cs:cursor_pos_buf]
	
	cmp ah, 0x4b ; Left
	je left
	cmp ah, 0x4d ; Right
	je right
	cmp ah, 0x1c ; Enter
	je ent
	cmp ah, 0x0f ; Tab
	je tab
	cmp ah, 0x0e ; Backspace
	je backspace
	cmp ah, 0x53 ; Delete
	je del
	cmp al, '\'
	je bs
	jmp symbol

left:
	cmp bx, 0
	je next
	
	sub bx, 2
	jmp print

right:
	cmp bx, [cs:buf_size]
	je next
	mov ax, [cs:buf_max_size]
	sub ax, 2
	cmp bx, ax
	je next
	
	add bx, 2
	jmp print

ent:
	mov ax, "\n"
	push bx
	call shift
	pop bx
	add bx, 2
	add word [cs:buf_size], 2
	jmp print

tab:
	mov ax, "\t"
	push bx
	call shift
	pop bx
	add bx, 2
	add word [cs:buf_size], 2
	jmp print

backspace:
	cmp bx, 0
	je next
	
	push bx
	sub bx, 2
	call backshift
	pop bx
	sub bx, 2
	sub word [cs:buf_size], 2
	jmp print

del:
	cmp word bx, [cs:buf_size]
	je print
	push bx
	call backshift
	pop bx
	sub word [cs:buf_size], 2
	jmp print
bs:
	mov ax, "\\"
	push bx
	call shift
	pop bx
	add bx, 2
	add word [cs:buf_size], 2
	jmp print
symbol:
	push bx
	call shift
	pop bx
	mov cx, [cs:buf_max_size]
	sub cx, 2
	cmp word bx, cx
	je .skip_shift_cur
	add bx, 2
.skip_shift_cur:
	add word [cs:buf_size], 2

print:
	mov ax, [cs:buf_max_size]
	cmp word [cs:buf_size], ax
	jb .not_buf_end
	mov word [cs:buf_size], ax
.not_buf_end:
	mov [cs:cursor_pos_buf], bx
	call print_screen
next:
	jmp _start


backshift:
	mov word ax, [es:bx + 2]
	mov [es:bx], ax
	add bx, 2
	cmp ax, 0
	jne backshift
	ret

shift:
	mov cx, [es:bx]
	mov [es:bx], ax
	cmp word bx, [cs:buf_max_size]
	je .end_shift
	add bx, 2
	mov ax, [es:bx]
	mov [es:bx], cx
	cmp word bx, [cs:buf_max_size]
	je .end_shift
	add bx, 2
	jmp shift
.end_shift:
	mov word [es:bx + 2], 0
	ret

print_screen:
	mov ax, 2
	int 10h
	mov ah, 2
	mov bh, 0
	mov dx, 0x1900
	int 10h
	mov bp, d
	mov cx, 128
	mov ax, 0x1100
	mov bx, 0x1000
	mov dx, 128
	int 10h
	
	xor bx, bx
	mov ax, bx
	mov di, bx
.loop_start:
	cmp [cs:cursor_pos_buf], bx
	jne .skip_print_cur
	mov byte [fs:di + 1], 83
.skip_print_cur:
	cmp bx, [cs:buf_max_size]
	je .end_print
	
	mov al, [es:bx]
	cmp al, "\"
	jne .not_spec

	inc bx
	mov al, [es:bx]
	
	cmp al, "t"
	jne .not_tab
	
	add di, 8
	
	jmp .end_spec
.not_tab:
	cmp al, "n"
	jne .not_enter
	
	mov ax, di
.mod:
	xor dx, dx
	mov cx, 160
	div cx
.end_mod:
	add di, 160
	sub di, dx
	
	jmp .end_spec
.not_enter:
	cmp al, "\"
	jne .not_back_slash
	mov byte [fs:di], '\'
	add di, 2
	
.not_back_slash:
.end_spec:
	dec bx
	jmp .loop_end
.not_spec:
	mov [fs:di], al
	add di, 2
.loop_end:
	add bx, 2
	jmp .loop_start
.end_print:
	ret
d: 
	file "font2.fnt": 2048

cursor_pos_buf: dw 0
buf_max_size: dw 2048
buf_size: dw 0
buf:

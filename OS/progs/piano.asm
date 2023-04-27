org 100h

_start:
	mov ax, 2
	int 10h
	
	push 0
	pop fs
	
	mov dx, [fs:9 * 4]
	mov [cs:old_int9], dx
	mov dx, [fs:9 * 4 + 2]
	mov [cs:old_int9 + 2], dx
	
	cli
	mov word [fs:9 * 4], int9
	mov word [fs:9 * 4 + 2], cs
	sti
	
	mov al, 0xb6
	out 0x43, al
	jmp $

int9:
	pushf
	call far [cs:old_int9]
	push ax
	push bx
	push cx
	push dx
	
	in al, 60h
	
	cmp al, 0x1 ; Esc
	je exit
	
	cmp al, 127 ; keyup
	ja keyup
	
	mov bx, big_octave_notes
	cmp al, 0x2 ; 1
	je change_octave
	mov bx, small_octave_notes
	cmp al, 0x3 ; 2
	je change_octave
	mov bx, octave_1_notes
	cmp al, 0x4 ; 3
	je change_octave
	mov bx, octave_2_notes
	cmp al, 0x5 ; 4
	je change_octave
	mov bx, octave_3_notes
	cmp al, 0x6 ; 5
	je change_octave
	mov bx, octave_4_notes
	cmp al, 0x7 ; 6
	je change_octave
	
	xor bx, bx
	cmp al, 0x1e ; A
	je .play_note
	add bx, 2
	cmp al, 0x2c ; Z
	je .play_note
	add bx, 2
	cmp al, 0x1f ; S
	je .play_note
	add bx, 2
	cmp al, 0x2d ; X
	je .play_note
	add bx, 2
	cmp al, 0x20 ; D
	je .play_note
	add bx, 2
	cmp al, 0x21 ; F
	je .play_note
	add bx, 2
	cmp al, 0x2f ; V
	je .play_note
	add bx, 2
	cmp al, 0x22 ; G
	je .play_note
	add bx, 2
	cmp al, 0x30 ; B
	je .play_note
	add bx, 2
	cmp al, 0x23 ; H
	je .play_note
	add bx, 2
	cmp al, 0x31 ; N
	je .play_note
	add bx, 2
	cmp al, 0x24 ; J
	je .play_note
	jmp int9_end
.play_note:
	in al, 0x61
	or al, 3
	out 0x61, al
	
	mov ax, [cs:current_octave + bx]
	out 0x42, al
	shr ax, 8
	out 0x42, al
int9_end:
	pop dx
	pop cx
	pop bx
	mov al, 20h
	out 20h, al
	pop ax
	iret

keyup:
	in al, 0x61
	and al, 0fch
	out 0x61, al
	jmp int9_end

change_octave:
	push cx
	mov cx, [cs:bx]
	mov [cs:current_octave], cx
	mov cx, [cs:bx + 2]
	mov [cs:current_octave + 2], cx
	mov cx, [cs:bx + 4]
	mov [cs:current_octave + 4], cx
	mov cx, [cs:bx + 6]
	mov [cs:current_octave + 6], cx
	mov cx, [cs:bx + 8]
	mov [cs:current_octave + 8], cx
	mov cx, [cs:bx + 10]
	mov [cs:current_octave + 10], cx
	mov cx, [cs:bx + 12]
	mov [cs:current_octave + 12], cx
	mov cx, [cs:bx + 14]
	mov [cs:current_octave + 14], cx
	mov cx, [cs:bx + 16]
	mov [cs:current_octave + 16], cx
	mov cx, [cs:bx + 18]
	mov [cs:current_octave + 18], cx
	mov cx, [cs:bx + 20]
	mov [cs:current_octave + 20], cx
	mov cx, [cs:bx + 22]
	mov [cs:current_octave + 22], cx
	pop cx
	jmp int9_end


old_int9: dw 0, 0

current_octave:
	dw 18356, 17292, 16344, 15297, 14550, 13714, 12969, 12175, 11472, 10847, 10198, 9700

big_octave_notes:
	dw 18356, 17292, 16344, 15297, 14550, 13714, 12969, 12175, 11472, 10847, 10198, 9700
small_octave_notes:
	dw 9108, 8584, 8062, 7648, 7231, 6818, 6449, 6087, 5764, 5423, 5120, 4830
octave_1_notes:
	dw 4554, 4307, 4058, 3836, 3615, 3418, 3224, 3043, 2875, 2711, 2560, 2415
octave_2_notes:
	dw 2281, 2153, 2032, 1918, 1810, 1709, 1612, 1521, 1435, 1355, 1280, 1207
octave_3_notes:
	dw 1140, 1075, 1015, 959, 905, 854, 806, 760, 718, 693, 639, 604
octave_4_notes:
	dw 570, 538, 507, 479, 452, 427, 403, 380, 358, 346, 319, 301

exit:
	mov ax, 1
	out 0x42, al
	shr ax, 8
	out 0x42, al
	in al, 0x61
	and al, 0fch
	out 0x61, al
	
	cli
	mov dx, [cs:old_int9]
	mov word [fs:9 * 4], dx
	mov dx, [cs:old_int9 + 2]
	mov word [fs:9 * 4 + 2], dx
	sti
	
	mov dx, exit
	int 27h

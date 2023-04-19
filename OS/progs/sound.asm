org 100h
push 0
pop fs

mov bx, [fs:8*4]
mov [cs:old_int08h], bx
mov bx, [fs:8*4+2]
mov [cs:old_int08h+2], bx 

cli
mov word [fs:8*4], int_08h
mov word [fs:8*4+2], cs
sti 

mov al, 0xb6
out 0x43, al

in al, 0x61
or al, 3
out 0x61, al
xor ax, ax
int 16h
in al, 0x61
and al, 252
out 0x61, al
mov ax, [cs:old_int08h]
mov bx, [cs:old_int08h+2] 
cli
mov [fs:8*4], ax
mov [fs:8*4+2], bx
sti
ret

int_08h:
	push ax
	dec word [cs:current_delay]
	jnz .end_int08h
	
	push bx
	mov bx, [cs:counter_note]
	
	
	mov ax, [cs:notesss + bx]
	out 0x42, al
	shr ax, 8
	out 0x42, al
	
	
	mov ax, [cs:delay + bx]
	mov [cs:current_delay], ax
	add bx, 2
	cmp [cs:len_notes], bx
	jne .skip
	xor bx, bx
.skip:
	mov [cs:counter_note], bx
	pop bx
	
.end_int08h:
	pop ax
	jmp far [cs:old_int08h]


old_int08h: dw 0, 0
	

delay: 	dw 7, 7, 7, 5, 2, 7, 5, 2, 14, 7
		dw 7, 7, 5, 2, 7, 5, 2, 14, 7, 5
		dw 2, 7, 5, 2, 2, 2, 9, 3, 7, 5
		dw 2, 2, 2, 9, 3, 7, 5, 2, 15
		
current_delay: dw 1

counter_note: dw 0
		
notesss: 	dw 3043, 3043, 3043, 3836, 2560, 3043, 3836, 2560, 3043, 2032
			dw 2032, 2032, 1918, 2560, 3233, 3836, 2560, 3043, 1521, 3043
			dw 3043, 1521, 1614, 1709, 1810, 1918, 1810, 2875, 2153, 2281
			dw 2420, 2560, 2711, 2560, 3836, 3233, 3836, 2560, 3043

len_notes: dw ($-notesss)


org 100h
 
mov ax, 2
int 10h 

mov al, 0xb6
out 0x43, al

push 0
pop ds

mov ax, word [ds:9*4]
mov word [cs:old9], ax
mov ax, word [ds:9*4+2]
mov word [cs:old9+2], ax
cli
mov word [ds:9*4], int9
mov word [ds:9*4+2], cs
sti

l:
hlt
jmp l

int9:
	pushf
	call far [cs:old9]
	
	push ax
		
	in al, 0x60
	
	cmp al, 1
	je exit
	
	push di
	push bx
	push dx

	cmp al, 127
	ja exit_2
		
oct:	
	cmp al, 2
	jb note
	
	cmp al, 7
	ja note
	
	mov bl, al
	sub bl, 2
	mov byte [cs:cur_octave], bl
	jmp exit_2

note:
	mov di, -1
cmp_note:
	inc di
	cmp di, 12
	je exit_2
	mov byte bl, [cs:buttons+di]	
	cmp al, bl
	jne cmp_note

	shl di, 1
	mov bl, [cs:cur_octave]
	xor bh, bh
	imul bx, 24
	add bx, di
	
play:
	in al, 0x61
	and al, 0fch
	out 0x61, al
	
	mov word ax, [cs:octavs+bx]	
	out 0x42, al
	shr ax, 8
	out 0x42, al
	
	in al, 0x61
	or al, 3
	out 0x61, al
	
exit_1:
	pop dx
	pop bx
	pop di
	mov al, 0x20
	out 0x20, al
	pop ax
	iret
		
exit_2:
	in al, 0x61
	and al, 0fch
	out 0x61, al
	jmp exit_1
	

exit:
	in al, 0x61
	and al, 0fch
	out 0x61, al
	
	push 0
	pop ds
	
	cli
	mov ax, word [cs:old9]
	mov word [ds:9*4], ax
	mov ax, word [cs:old9+2]
	mov word [ds:9*4+2], ax
	sti
	pop ax
	
	mov dx, len
	int 27h

old9:  			dw 0,0
buttons:		db 0x1e, 0x2c, 0x1f, 0x2d, 0x20, 0x21, 0x2f, 0x22, 0x30, 0x23, 0x31, 0x24 
cur_octave:  	db 0
octavs: 		dw 18356, 17292, 16344, 15297, 14550, 13714, 12969, 12175, 11472, 10847, 10198, 9700
				dw 9108, 8584, 8062, 7648, 7231, 6818, 6449, 6087, 5764, 5423, 5120, 4830
				dw 4554, 4307, 4058, 3836, 3615, 3418, 3224, 3043, 2875, 2711, 2560, 2415
				dw 2281, 2153, 2032, 1918, 1810, 1709, 1612, 1521, 1435, 1355, 1280, 1207
				dw 1140, 1075, 1015, 959, 905, 854, 806, 760, 718, 693, 639, 604
				dw 570, 538, 507, 479, 452, 427, 403, 380, 358, 346, 319, 301
len=$

jmp x
nop
db "ASVT FAT"
dw 512
db 1 	; sec per clust
dw res 	; <-------------- reserved sectors (depends of size this file)
db 1 	; fats
dw 0 	; count elem in root
dw 2880 ; sectors
db 0xf0 ; type - floppy
dw 0	; sec per fat (n/u)
dw 18	; sec per track
dw 2	; heads
dd 0	; hiden sectors
dd 0	; total sectors (0 if size < 32mb)
dd 23	; <-------------- sec per fat (depends [weak] of size this file) 
dd 0
dd 2
dw 1
dw 1
dd 0, 0, 0
db 0
db 0
db 0
dd 2a876CE1h
db 'ASVT FAT32!'
db 'FAT32   '
x:

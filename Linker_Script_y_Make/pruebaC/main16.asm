;Hacer un programa que muestre en la primera línea letras A,
;en la segunda línea letras B hasta el final. La última
;línea va a tener la letra Y.
;Definir un segmento de código de 4 GB de tamaño y
;un segmento de datos que ocupe el buffer de video.
;En ambos casos DPL = 0.

;nasm -f bin letras2.asm -o mi_rom.bin -l mi_rom.lst
;hexdump -C mi_rom.bin > mi_rom_hexdump.txt
USE16
inicio_ROM equ 0xFFFF0000
Inicio:
;desde aca va nuestro codigo
    jmp despues_tablas
GDT:dd 0, 0     ;DB = define byte, DW = define word (2 bytes)
                ;DD = define doubleword (4 bytes)
                ;DQ = define quadword (8 bytes)
cs_sel equ $-GDT  ;Descriptor de código flat.
    db 0xFF     ;Bits 7-0 del límite
    db 0xFF     ;Bits 15-8 del límite
    db 0x00     ;Bits 7-0 de la base
    db 0x00     ;Bits 15-8 de la base
    db 0x00     ;Bits 23-16 de la base
    db 0x9A     ;Byte de derechos de acceso
    db 0xCF     ;GD00 y límite 19-16
    db 0x00     ;Bits 31-24 de la base
ds_sel equ $-GDT  ;Descriptor de datos flat.
    db 0xFF     ;Bits 7-0 del límite
    db 0xFF     ;Bits 15-8 del límite
    db 0x00     ;Bits 7-0 de la base
    db 0x00     ;Bits 15-8 de la base
    db 0x00     ;Bits 23-16 de la base
    db 0x92     ;Byte de derechos de acceso
    db 0xCF     ;GD00 y límite 19-16
    db 0x00     ;Bits 31-24 de la base
longitud_GDT equ $-GDT
imagen_GDTR:
    dw longitud_GDT - 1
    dd inicio_ROM + GDT
    
despues_tablas:    
    %include "init_pci.inc"
pasaje_a_modo_prot:
xchg bx,bx
    cli
    o32 lgdt [cs:imagen_GDTR]
    mov eax,cr0
    or eax,1
    mov cr0,eax
    jmp dword cs_sel:inicio_ROM + modo_prot
    use32
    ; Còdigo en segmento de 32 bits.
modo_prot:
    mov ax,ds_sel
    mov ds,ax
    mov es,ax
    mov ss,ax
    ;Continúa en el módulo main32.
    

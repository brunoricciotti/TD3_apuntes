    extern cuadrado
    global enviarAPantalla

    section .stack nobits
pila            resb 32*1024  ; 32 KB para la pila.
inicio_pila:
    section .bss
valor           resb 4 ;Valor a elevar al cuadrado.
punteroPantalla resb 4
    section .text
Inicio:
    incbin "main16.bin"
xchg bx,bx
    mov esp, inicio_pila  ;Inicializar puntero de pila
    mov ebp, esp      ;Inicializar puntero a marco de pila.
    mov eax, 0        ;Inicializar valor.
    mov [valor],eax
    mov eax, 0xB8000
    mov [punteroPantalla],eax
ciclo_mostrar_cuadrados:
    push dword [valor];Parámetro para función en C.
    call cuadrado     ;Mostrar en pantalla el cuadrado de ese valor.
    inc dword [valor] ;Siguiente valor.
    cmp eax, 0        ;Ver si hay espacio en pantalla.
    pop eax           ;Descartar parámetro.
    je ciclo_mostrar_cuadrados   
	jmp $

	;Función llamada desde C.
	;Parámetro: cadena a enviar a pantalla.
enviarAPantalla:
    ;Prólogo.
    push ebp
    mov ebp,esp
;  xchg bx,bx  
    ;Cuerpo de la función
    push ebx                ;Salvar registros usados por GCC
    push edx
    mov eax, 0
    mov edx, [ebp+8]  ;Puntero a cadena.
    mov ebx, [punteroPantalla]
ciclo_mostrar_caracteres:
    mov al, [edx]
    test al, al
    je fin_cadena          ;Saltar si fin de cadena.
    mov [ebx], al          ;Caracter ASCII.
    mov byte [ebx+1], 0x07 ;Atributo blanco sobre negro.
    inc edx                ;Siguiente carácter en cadena.
    add ebx, 2             ;Siguiente caràcter en pantalla.
    cmp ebx, 0xB8000 + 25*80*2 ;Fin de pantalla?
    jne ciclo_mostrar_caracteres
    mov eax, 1             ;Indicar fin de pantalla.
    jmp caracteres_mostrados
fin_cadena:
    mov byte [ebx],';'     ;Caracter ASCII.
    mov byte [ebx+1], 0x07 ;Atributo blanco sobre negro.
    add ebx, 2             ;Siguiente caràcter en pantalla.
    cmp ebx, 0xB8000 + 25*80*2 ;Fin de pantalla?
    jne caracteres_mostrados
    mov eax, 1             ;Indicar fin de pantalla.    
caracteres_mostrados:
    mov [punteroPantalla], ebx
    pop edx                ;Restaurar registros usados por GCC.
    pop ebx
    ;Epìlogo.
    mov esp, ebp
    pop ebp
    ret
    
    section .reset progbits
    use16
Entrada:
	jmp dword Inicio       ;El linker es de 32 bits: usar dword.
	times 16-($-Entrada) db 0	;Relleno hasta el final de la ROM.


data SEGMENT
    msg0 DB 10,13,"     *.+Menu+.*",10,13,"- Escriba una opcion:",10,13, " (U) Sumar",10,13," (R) Restar",10,13, " (M) Multiplicar ",10,13, " (D) Dividir ",10,13, " (P) Potencia",10,13," (S) Graf. Seno",10,13," (C) Graf. Coseno",10,13,"       Opcion: $"
    msg1 DB 10,13,"Inserte primer numero: $" 
    msg2 DB 10,13,"Inserte segundo numero: $" 
    msg3 DB 10,13,"- Resultado: $"
    msg4 DB 10,13,"- Residuo: $"
    msg5 DB 10,13,"Opcion no valida !! $" 
    
    ;----------
    var1 DW ?
    var2 DW ? 
    var3 DW ?
    cmpv DB ?
    ;----------
    
    ;seno y coseno
    X DB 1
    Y_sen DB 10, 9, 8, 8, 7, 6, 5, 5, 4, 4, 3, 2, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 8, 8, 9, 10, 11, 12, 12, 13, 14, 15, 15, 16, 16, 17, 18, 18, 19, 19, 19, 20, 20, 20, 20, 20, 20, 20, 20, 20, 19, 19, 19, 18, 18, 17, 16, 16, 15, 15, 14, 13, 12, 12, 11
    Y_cos DB 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 8, 8, 9, 10, 11, 12, 12, 13, 14, 15, 15, 16, 16, 17, 18, 18, 19, 19, 19, 20, 20, 20, 20, 20, 20, 20, 20, 20, 19, 19, 19, 18, 18, 17, 16, 16, 15, 15, 14, 13, 12, 12, 11, 10, 9, 8, 8, 7, 6, 5, 5, 4, 4, 3, 2, 2, 1, 1, 1, 0, 0, 0, 0
    
    COLOR DB 0fh
data ENDS


leam MACRO msg
    LEA DX,msg 
    MOV AH,09h 
    INT 21h
ENDM

code SEGMENT
assume CS:code , DS:data
comienza:
    mov ax,data 
    mov ds,ax

    jmp Trigonometria

ErrorCMP:

    ;limpia la pantalla
    mov ax,0002h 
    mov bh,07h 
    mov cx,0000h 
    mov dx,184Fh 
    int 10h
    
    leam msg5
    jmp salir

;muestra la grafica
Trigonometria:
    leam msg0

    mov ah,01h 
    int 21h
    
    ;---sin---
    cmp al,'s' 
    je Seno
    cmp al,'S' 
    je Seno
    
    ;---cos---
    cmp al,'c' 
    je Coseno

    cmp al,'C' 
    je Coseno

    mov cmpv,al
    leam msg1

    xor di,di 
    xor bx,bx 
    mov di,10

arriba:
    xor ax,ax 
    mov ah,08h 
    int 21h
    xor dx,dx 
    cmp al,13
    je operacionl 
    cmp al,30h
    jl arriba 
    cmp al,39h 
    jg arriba 
    mov dl,al
    mov ah,02h 
    int 21h
    push dx 
    mov ax,bx 
    mul di 
    pop dx
    sub dl,30h 
    add ax,dx 
    mov bx,ax 
    jmp arriba

operacionl:
    mov var1,bx

    leam msg2
    jmp leer2

leer2:
    xor bx,bx 
    xor di,di 
    mov di,10

arriba2:
    xor ax,ax 
    mov ah,08h 
    int 21h
    xor dx,dx 
    cmp al,13
    je operacion 
    cmp al,30h
    jl arriba 
    cmp al,39h 
    jg arriba 
    mov dl,al 
    mov ah,02h 
    int 21h

    push dx 
    mov ax,bx 
    mul di 
    pop dx
    sub dl,30h
    add ax,dx 
    mov bx,ax 
    mov var2,bx 
    jmp arriba2

;muestra las opciones que piden 2 opc.
operacion:
    xor ax,ax 
    mov al,cmpv

    cmp al,'U' 
    je suma
    
    cmp al,'u' 
    je suma

    cmp al,'R' 
    je resta
    
    cmp al,'r' 
    je resta
    
    cmp al,'M' 
    je multi
    
    cmp al,'m' 
    je multi
    
    cmp al,'d' 
    je divide
    
    cmp al,'D' 
    je divide

    cmp al,'P' 
    je Potencia
    
    cmp al,'p' 
    je Potencia

    jmp ErrorCMP

;
suma:
    add bx,var1 
    xor bp,bp
    mov bp,bx

    leam msg3 
    call imprimir

    jmp salir

resta:
    mov bx,var1 
    sub bx,var2 
    xor bp,bp 
    mov bp,bx

    leam msg3 
    call imprimir

    jmp salir

multi:
    xor ax,ax 
    mov ax,bx 
    mul var1 
    xor bp,bp 
    mov bp,ax

    leam msg3 
    call imprimir

    jmp salir

divide:
    xor ax,ax 
    xor dx,dx 
    mov bx,var2 
    mov ax,var1 
    div bx
    mov bp,ax 
    mov var3,dx

    leam msg3 
    call imprimir

    leam msg4

    mov bp,var3

    call imprimir

    jmp salir



Potencia:
    mov cx,var2 
    sub cx,1 
    mov ax,var1                                     
    
;marca el inicio del ciclo de cálculo de la potencia
Potencia1:
    mul var1 
    loop Potencia1

    xor bp,bp 
    mov bp,ax

    leam msg3 
    call imprimir

    jmp salir

;grafica seno en la pantalla
Seno:
    MOV AX, 0600h
    MOV BH, COLOR
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
    
    ;llama a y_sen
    LEA SI, Y_sen
    MOV CL, 0
    
    loop_seno: 
    MOV AH, 2
    MOV BH, 0
    MOV DL, CL
    MOV DH, 10
    INT 10h
    
    ;linea
    MOV AH, 6
    MOV DL, '-'
    INT 21h  
    
    MOV AH, 2 
    MOV BH, 0
    MOV DL, CL
    MOV DH, [SI]
    INT 10h
    
    ;los puntos que dibuja coseno
    MOV AH, 6
    MOV DL, '.'
    INT 21h 
    
    INC SI    
    INC CL
    CMP CL, 80
    JNE loop_seno

    JMP salir
     
     
;grafica coseno en la pantalla     
Coseno:
    MOV AX, 0600h
    MOV BH, COLOR
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
    
    LEA SI, Y_cos
    MOV CL, 0
    
    loop_coseno: 
    MOV AH, 2
    MOV BH, 0
    MOV DL, CL
    MOV DH, 10
    INT 10h
    
    ;la linea
    MOV AH, 6
    MOV DL, '-'
    INT 21h  
    
    MOV AH, 2 
    MOV BH, 0
    MOV DL, CL
    MOV DH, [SI]
    INT 10h
    
    ;los puntos que dibuja coseno
    MOV AH, 6
    MOV DL, '.'
    INT 21h 
    
    INC SI    
    INC CL
    CMP CL, 80
    JNE loop_coseno

    JMP salir
    
imprimir proc 
    xor cx,cx
    mov ax,bp 
    mov si,10

vuelve:
    xor dx,dx 
    div si 
    push dx 
    add cx,1 
    cmp ax,0 
    jne vuelve

    mov ah,02h

; imprimie el num. almacenado en la pantalla
arriba3:
    xor dx,dx 
    pop dx 
    add dl,30h 
    int 21h
    loop arriba3 

    ret
endp 

salir:
    mov ah,4ch
    int 21h 

code ends
end comienza      

;----- Fin ------
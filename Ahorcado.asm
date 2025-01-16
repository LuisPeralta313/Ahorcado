; Luis Peralta 1231721 
TITLE "Laboratorio No.2  Ahorcado"
.MODEL SMALL
.STACK 64 ;Declaracion de segmento de stack8ssx7s
.DATA ;Declaración de segmento de datos

TITULO DB '                Juego Ahorcado', 10,24H
INSTRUCCIONES DB 'El juego de ahorcado consiste en adivinar',10,'Palabras de 5 letras. Debe ingresar una',10,'letra a la vez. Tiene 5 intentos por',10,'palabra y son 4 palabras en total. Al',10,'terminar obtendra su punteo final o',10,'puede presionar alt+x para salir y ver sus puntos.',10,'$'
MSGLINEAS DB '---------------------------------------------------|',10,'$'
MENSAJE1 DB 10,'Ingrese una letra que quiere adivinar',10,24H
ESPACIO DB '          ',10,'$'
VICTORIA DB '          ',0DH,0AH
         DB '    \o/   ', 0DH,0AH
         DB '     |    ',0DH,0AH
         DB '    / \   ',0DH,0AH
         DB ' ---------',0DH,0AH,'$'
PARTE1   DB '     -----',10,'$'
PARTE2   DB '     |    ',10,'$'
PARTE3   DB '     O    ',10,'$'
PARTE4   DB '    /|    ',10,'$' 
PARTE5   DB '    /|\   ',10,'$'
PARTE6   DB '    /     ',10,'$'
PARTE7   DB '    / \   ',10,'$'
PARTE8   DB ' ---------',10,'$'
PARTE9   DB ' Punteo: ',10,'$'
PERDIDA DB 10,'Has muerto hasta pronto',10,24H
MSGVICTORIA DB 10,'Has ganado Felicidades',10,24H
MSGTERMINAR DB 10,'Juego terminado',10,24H
;Palabras Del Ahorcado
PATHNAME	DB	'C:\leer.txt',0
FILEHAND DW ? 
PALABRAGUARDA DW 50 DUP('$')
PALABRA1 DW 5 DUP(' '),24H ; SE RESERVAN CINCO ESPACIOS EN MEMORIA 
PALABRA2 DW 5 DUP(' '),24H
PALABRA3 DW 5 DUP(' '),24H
PALABRA4 DW 5 DUP(' '),24H
PALABRA5 DW 5 DUP(' '),24H
NUMEROCARACTER DB 10,0,0DH,0AH,24H
;Variables 
PALABRA DB ?,24H
ASTERISCOS DB '*****',24H    ;Variable Asterisco es utilizada en todas las funciones, solamente se vuelve a llenar con asteriscos (2AH)
NUMERO DB 10,0,0DH,0AH,24H
INTENTOS DB 0,24H
CORRECTAS DB 0,24H
AVANZARPALABRA DB 0,24H ;Variable que irá en incremento (INC) iniciando en 0
PUNTEO DW 0,24H
PUNTEOTOTAL DW 0,24H  
TEN DW 10,24H
.386
.CODE ;Declaración de segmento de código
MAIN PROC FAR 
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
BEGIN:
     MOV DX, OFFSET TITULO
     MOV AH, 09H
     INT 21H
     MOV DX, OFFSET INSTRUCCIONES
     MOV AH,09H
     INT 21H
     MOV DX, OFFSET MSGLINEAS
     MOV AH, 09H
     INT 21H


	 MOV AH, 3DH ;Abrir el archivo .txt
	 MOV AL, 00
	 LEA DX, PATHNAME 
	 INT 21H
	 MOV FILEHAND, AX
	 MOV CX,5
     PUSH CX ;1
	 MOV AH, 3FH 
	 MOV BX, FILEHAND
	 MOV CX, AX
	 LEA DX, PALABRAGUARDA     ; Variable que guarda la cadena concatenada
	 INT 21H

                                          ; INSTRUCCIONES SE REPITEN EN CADA PALABRA
    ;INICIO INSTRUCCIONES DE CAPTURA DE PALABRAS
     LEA SI, PALABRAGUARDA    ; El código utiliza la instrucción LEA para cargar los registros SI y DI ->
     LEA DI, PALABRA1         ; -> con las direcciones de memoria de la cadena y las variables de la palabra correspondiente.
     MOV CX, AX
     REP MOVSB                ; se utiliza la instrucción MOVSB para copiar un byte desde la posición ->
                              ; -> de memoria apuntada por SI a la posición apuntada por DI.
	 POP CX
     DEC CX ;Termina de guardar palabra 1
     PUSH CX ;2
     MOV AH, 3FH 
	 MOV BX, FILEHAND
	 MOV CX, 5
	 LEA DX, PALABRAGUARDA
	 INT 21H
     LEA SI, PALABRAGUARDA
     LEA DI, PALABRA2
     MOV CX, 5
     REP MOVSB
     POP CX
     DEC CX; Termina de guardar palabra 2
     PUSH CX ;3
     MOV AH, 3FH 
	 MOV BX, FILEHAND
	 MOV CX, 5
	 LEA DX, PALABRAGUARDA
	 INT 21H
     LEA SI, PALABRAGUARDA
     LEA DI, PALABRA3
     MOV CX, 5
     REP MOVSB
     POP CX
     DEC CX;Termina de guardar palabra 3
     PUSH CX ;4
     MOV AH, 3FH 
	 MOV BX, FILEHAND
	 MOV CX, 5
	 LEA DX, PALABRAGUARDA
	 INT 21H
     LEA SI, PALABRAGUARDA
     LEA DI, PALABRA4
     MOV CX, 5
     REP MOVSB
     POP CX
     DEC CX ;termina de guardar palabra 4
	 PUSH CX ;5
     MOV AH, 3FH 
	 MOV BX, FILEHAND
	 MOV CX, 5
	 LEA DX, PALABRAGUARDA
	 INT 21H
     LEA SI, PALABRAGUARDA
     LEA DI, PALABRA5
     MOV CX, 5
     REP MOVSB
     POP CX
     DEC CX; Terminar de guardar palabra 5
     JMP INICIOJUEGO
     ; FIN DE INSTRUCCIONES PARA CAPTURAR LAS 5 PALABRAS 
     
EXIT: 
    MOV AH, 4CH ;Para cerrar el programa
    INT 21H
MAIN ENDP
INICIOJUEGO PROC NEAR 
  PUSH AX
  MOV DX, OFFSET MENSAJE1
  MOV AH,09H
  INT 21H
  MOV AH, 01H
  INT 21H
  CALL VERIFICARSALIDA
   VERIFICAR_PALABRA:
   CMP AVANZARPALABRA,0   ; Aquí es donde comienza la tarea de verificar en qué palabra va, está inicializado en CERO
   JE COMPARARPALABRA1    ; Inicializado en Cero, salta a la función de comparar la palabra 1 y volverá al inicio del juego con un Incremento de 1 cuando esté correcta la primera palabra.
   CMP AVANZARPALABRA,1   
   JE COMPARARPALABRA2
   CMP AVANZARPALABRA,2
   JE COMPARARPALABRA3
   CMP AVANZARPALABRA,3
   JE COMPARARPALABRA4
   CMP AVANZARPALABRA,4
   JE COMPARARPALABRA5    ; Repitiendo lo anterior comentado hasta la palabra 5. 
   POP AX
   POP BX
   JMP EXIT
INICIOJUEGO ENDP    
VERIFICARSALIDA  PROC NEAR
 PUSH AX
 CMP AH, 2DH
 JNE VERIFICAR_PALABRA
 JMP TERMINARJUEGO
 POP AX
VERIFICARSALIDA ENDP
TERMINARJUEGO PROC NEAR
 MOV DX, OFFSET MSGTERMINAR
 MOV AH, 09H 
 INT 21H
 JMP EXIT
TERMINARJUEGO ENDP
COMPARARPALABRA1 PROC NEAR ;INICIO Función COMPARARPALABRA(#) se repite para cada palabra
 MOV PALABRA, AL  ; Lo Ingresado por el usuario será guardado de Al a PALABRA
 MOV Al, PALABRA  ; Se guardará en Al la PALABRA para comparar
 LEA DI, PALABRA1 ; Conseguimos la dirección efectiva de la palabra1 el valor de DI será la dirección del caracter +1
 MOV CX, 5        ; Será la cantidad de caracteres que va a comparar
 repne scasb      ;Esta función es útil  en la vida, será la que compara si el carácter ingresado está contenido en la palabra1, repne si ya encontró el carácter, ya no sigue y para. 
 JNE CARACTERINCORRECTO  ; Si no, se llamará a CARACTERINCORRECTO que agregará una parte del hombre casi muerto D:
 JMP CARACTERCORRECTO    ; Si es correcto, se llama a la función CARACTERCORRECTO. 
COMPARARPALABRA1 ENDP
COMPARARPALABRA2 PROC NEAR
 MOV PALABRA, AL
 MOV Al, PALABRA
 LEA DI, PALABRA2
 MOV CX, 5
 repne scasb
 JNE CARACTERINCORRECTO
 JMP CARACTERCORRECTO
COMPARARPALABRA2 ENDP
COMPARARPALABRA3 PROC NEAR
 MOV PALABRA, AL
 MOV Al, PALABRA
 LEA DI, PALABRA3
 MOV CX, 5
 repne scasb
 JNE CARACTERINCORRECTO
 JMP CARACTERCORRECTO
COMPARARPALABRA3 ENDP
COMPARARPALABRA4 PROC NEAR
 MOV PALABRA, AL
 MOV Al, PALABRA
 LEA DI, PALABRA4
 MOV CX, 5
 repne scasb
 JNE CARACTERINCORRECTO
 JMP CARACTERCORRECTO
COMPARARPALABRA4 ENDP
COMPARARPALABRA5 PROC NEAR
 MOV PALABRA, AL
 MOV Al, PALABRA
 LEA DI, PALABRA5
 MOV CX, 5
 repne scasb
 JNE CARACTERINCORRECTO
 JMP CARACTERCORRECTO
COMPARARPALABRA5 ENDP    ; FIN DE FUNCIONES COMPARARPALABRA(#)

CARACTERINCORRECTO PROC NEAR     ; FUNCIÓN QUE SE UTILIZA PARA TODAS LAS PALABRAS
 POP BX
 ADD INTENTOS,1      ; La variable INTENTOs es un contador para los INCORRECTOS. 
 MOV BL, INTENTOS    ; Guarda en BL la variable INTENTOS
 CMP BL, 1           ; Al ser igual a 1, refiriéndose a 1 Error/Intento, se imprime la parte 1 del hombre ahorcado.
 JE IMPRIMIRPARTE1   ; Llamado a imprimir Parte. 
 CMP BL, 2           ; Se repite el mismo tipo de lógica con las otras partes del hombre extinto :c
 JE IMPRIMIRPARTE2
 CMP BL, 3
 JE IMPRIMIRPARTE3
 CMP BL, 4
 JE IMPRIMIRPARTE4
 CMP BL, 5
 JE IMPRIMIRPARTE5
CARACTERINCORRECTO ENDP    ; FIN FUNCIÓN CARACTER INCORRECTO

CARACTERCORRECTO PROC NEAR    ; INICIO CARACTER CORRECTO
 ADD PUNTEO, 20
 CALL CAMBIARASTERISCO        ; LLAMADO a la función que buscará la posición del carácter ingresado y remplazará. 
 ADD CORRECTAS,1              ; CORRECTAS es un contador para la función CARACTERCORRECTO se incrementará cada vez que acierte.
 CMP CORRECTAS, 5             ; Al llegar el contador a 5, significa que completó la palabra correctamente. 
 JE GANADOR                   ; Al llegar a las 5, se llama la función GANADOR. 
 CMP INTENTOS, 1              ; Esta llamada, de nuevo al contador INTENTOS, se requiere en caso que sí acierte, pero en alguna de las siguientes se equivoque. 
 JE IMPRIMIRPARTE1
 CMP INTENTOS, 2
 JE IMPRIMIRPARTE2
 CMP INTENTOS, 3
 JE IMPRIMIRPARTE3
 CMP INTENTOS, 4
 JE IMPRIMIRPARTE4            ; Se equivocó completamente después de acertar alguna palabra. 
 MOV DX, OFFSET ESPACIO       ; Si no se equivocó, entra aquí. 
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET ASTERISCOS    ; 
 MOV AH, 09H
 INT 21H
 JMP INICIOJUEGO
CARACTERCORRECTO ENDP         ;FIN FUNCIÓN CARACTER CORRECTO
CAMBIARASTERISCO PROC NEAR    ; INICIO FUNCIÓN CAMBIARASTERISCO
 CMP CX, 4                    ; Se comparará el valor del CX con cada posición, y se enviará como respuesta a su función designada
 JE CAMBIOASTERISCO1          ; Función Designada si el valor está en el primer caracter. 
 CMP CX, 3
 JE CAMBIOSASTERISCO2
 CMP CX, 2
 JE CAMBIOASTERISCO3
 CMP CX, 1
 JE CAMBIOASTERISCO4
 CMP CX, 0 
 JE CAMBIOASTERISCO5
CAMBIARASTERISCO ENDP
CAMBIOASTERISCO1 PROC NEAR      ; Funciones CAMBIOASTERISCO(#) irán a la variable Asteriscos y remplazarán ese valor en la posición que se designa en la función.
 MOV ASTERISCOS+0, AL
 RET
CAMBIOASTERISCO1 ENDP
CAMBIOSASTERISCO2 PROC NEAR
 MOV ASTERISCOS+1, AL
 RET
CAMBIOSASTERISCO2 ENDP
CAMBIOASTERISCO3 PROC NEAR
 MOV ASTERISCOS+2, AL
 RET
CAMBIOASTERISCO3 ENDP
CAMBIOASTERISCO4 PROC NEAR 
 MOV ASTERISCOS+3, AL
 RET
CAMBIOASTERISCO4 ENDP
CAMBIOASTERISCO5 PROC NEAR
 MOV ASTERISCOS+4, AL
 RET
CAMBIOASTERISCO5 ENDP
IMPRIMIRPARTE1 PROC NEAR      ; FUNCIONES IMPRIMIRPARTE(#) MOSTRARÁ CADA PARTE DEL HOMBRE MUERTO DEPENDIENDO DEL NIVEL EN EL QUE VA.
 POP AX
 MOV DX, OFFSET PARTE1
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE2
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE3
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET ASTERISCOS
 MOV AH, 09H 
 INT 21H
 JMP INICIOJUEGO
 IMPRIMIRPARTE1 ENDP

IMPRIMIRPARTE2 PROC NEAR
 POP AX
 MOV DX, OFFSET PARTE1
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE2
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE3
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE4
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET ASTERISCOS
 MOV AH, 09H 
 INT 21H
 JMP INICIOJUEGO
IMPRIMIRPARTE2 ENDP
IMPRIMIRPARTE3 PROC NEAR
 MOV DX, OFFSET PARTE1
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE2
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE3
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE5
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET ASTERISCOS
 MOV AH, 09H 
 INT 21H
 JMP INICIOJUEGO
IMPRIMIRPARTE3 ENDP
IMPRIMIRPARTE4 PROC NEAR
 MOV DX, OFFSET PARTE1
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE2
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE3
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE5
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE6
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET ASTERISCOS
 MOV AH, 09H 
 INT 21H
 JMP INICIOJUEGO
IMPRIMIRPARTE4 ENDP
IMPRIMIRPARTE5 PROC NEAR
 MOV DX, OFFSET PARTE1
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE2
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE3
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE5
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE7
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET PARTE8
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET ASTERISCOS
 MOV AH, 09H 
 INT 21H
 MOV DX, OFFSET PERDIDA
 MOV AH, 09H
 INT 21H
 JMP EXIT                       ; FIN DE FUNCIONES IMPRIMIR(#)
IMPRIMIRPARTE5 ENDP
GANADOR PROC NEAR             ; FUNCIÓN GANADOR, se repite en todas las situaciones en que acierta las palabras. 
 MOV DX, OFFSET VICTORIA
 MOV AH, 09H
 INT 21H
 MOV DX, OFFSET ASTERISCOS
 MOV AH, 09H 
 INT 21H
 MOV DX, OFFSET PARTE9
 MOV AH, 09H
 INT 21H
 CALL PASARDECIMAL
  LIMPIAR_VARIABLES:         ; Al GANAR, se utiliza la misma variable ASTERISCOS en todas las palabras, únicamente volviendo a remplazar con asteríscos(2A) cada caracter de tamaño 5.
   XOR DX, DX
   MOV ASTERISCOS+0, 2AH
   MOV ASTERISCOS+1, 2AH
   MOV ASTERISCOS+2, 2AH
   MOV ASTERISCOS+3, 2AH
   MOV ASTERISCOS+4, 2AH
   MOV CORRECTAS, 0       ;También se reinician los contadores
   MOV INTENTOS, 0
   INC AVANZARPALABRA
   JMP PALABRAFALTANTE
GANADOR ENDP                ; FIN FUNCIÓN GANADOR
PALABRAFALTANTE PROC NEAR ;para verificar si es la última palabra o hay palabras restantes del juego 
 CMP AVANZARPALABRA, 1
 JE INICIOJUEGO
 CMP AVANZARPALABRA, 2
 JE INICIOJUEGO
 CMP AVANZARPALABRA, 3
 JE INICIOJUEGO
 CMP AVANZARPALABRA, 4
 JE INICIOJUEGO
 CMP AVANZARPALABRA, 5
 MOV DX, OFFSET MSGVICTORIA
 MOV AH, 09H
 INT 21H
 JMP EXIT
 
PALABRAFALTANTE ENDP    ; FIN FUNCIÓN PALABRA FALTANTE
PASARDECIMAL PROC NEAR ;pasar de hexadecimal a decimal el número del punteo
 MOV AX, PUNTEO
 MOV BX, 1
 MOV CX, 0
  CONVERT_LOOP:
   AND AX, 0FH ; extrae  el último dígito hexadecimal del registro AX
   MUL BX  ; se multiplica el valor decimal del dígito por la potencia 16 
   ADD CX, AX 
   SHR AX, 1 ; Desplaza el registro AX un dígito a la derecha
   INC BX
   CMP AX, 0
   JNZ CONVERT_LOOP
 MOV PUNTEOTOTAL, CX
 MOV AX, PUNTEOTOTAL
 JMP PRINTPUNTEO
PASARDECIMAL ENDP
PRINTPUNTEO PROC NEAR ;Imprimir el punteo que lleva el jugador en el juego
 PUSH AX
 MOV CX, 0
 print_loop:
        MOV DX, 0 ; Inicializa el registro DX en cero
        DIV TEN ; Divide el registro AX por 10
        ADD DL, '0' ; Convierte el dígito decimal en su representación ASCII
        PUSH DX ; Guarda el dígito decimal en la pila
        INC CX ; Incrementa el contador de dígitos
        CMP AX, 0 ; Compara el registro AX con cero
        JNZ print_loop ; Repite el bucle hasta que el registro AX sea cero
    print_digits:
        POP DX ; Extrae el último dígito decimal de la pila
        MOV AH, 02H ; Carga la función de impresión de un carácter
        INT 21h ; Imprime el dígito decimal en la consola
        LOOP print_digits ; Repite el bucle hasta que se hayan impreso todos los dígitos
    POP AX ; Restaura el valor del registro AX
    JMP LIMPIAR_VARIABLES ; Retorna de la función
PRINTPUNTEO ENDP 
END MAIN
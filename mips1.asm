# ++ Ejercicio 1: Aprendiendo a reservar datos en memoria. si no se especifica direccion en data, la default es: 0x10010000

#.data # comienza zona de datos
#	palabra1: .word 15 # decimal
#	palabra2: .word 0x15 # hexadecimal

# --

# ++ Ejercicio 2: Que pasa si comenzamos a guardar datos en 0x1001000C? 

#.data 0x1001000C #comienza zona de datos
#palabras: .word 15, 0x15 # decimal / hexadecimal

# --

# ++ Ejercicio 3: Aprendemos a crear un vector. 
#	Que pasa si arrancamos en 0x10000002?
#	(Automaticamente se realinea la direccion al siguiente multiplo de 4,
#	por lo tanto, esto se guarda en 0x10000004)

#.data 0x10000002
#	vector: .word 0x10, 30, 0x34, 0x20, 60

# --

# ++ Ejercicio 4: Inicializamos una posiciòn de memoria de tamaño byte con un valor.

#.data
#	octeto: .byte 0x10

# --

# ++ Ejercicio 5: Declarando bytes en memoria. Diferencia entre big endian y little endian.

#.data
#	palabra1: .byte 0x10, 0x20, 0x30, 0x40
#	palabra2: .word 0x10203040

# --

# ++ Ejercicio 6: Aprendemos a declarar cadenas de caracteres.

#.data
#	cadena:	.asciiz "abcde"

# --

# ++ Ejercicio 7: Aprendemos a reservar espacio en memoria y a alinearlo.

#.data
#	byte1: .byte 0x10
#	       .align 2
#	espacio: .space 4
#	byte2: .byte 0x20
#	entero: .word 10

# --




# ++ 1. Diseña un programa ensamblador que reserva espacio para dos vectores A y B de 20 palabras cada uno a partir de la dirección 0x10000000.

#.data
#	vecA: .space 80
#	vecB: .space 80

# --

# ++ 2. Diseña un programa ensamblador que realice la siguiente reserva de espacio en memoria a partir de la dirección 0x10001000:
# una palabra, un byte y otra palabra alineada en una dirección múltiplo de 4.

#.data 0x10001000
#	palabra1: .space 4
#	byte: .space 1
#	.align 2
#	palabra2: .space 4

# --

# ++ 3. Diseña un programa ensamblador que realice la siguiente reserva de espacio e inicialización en memoria a partir de la dirección por defecto: 
# 3 palabras, un byte conteniendo 0x10, luego 4 bytes a partir de una dirección múltiplo de 4 y 20 bytes. 

#.data
#	palabra1: .space 4
#	palabra2: .space 4
#	palabra3: .space 4
#	byte: .byte 0x10
#	.align 2
#	bytes4: .space 4
#	bytes20: .space 20

# --

# ++ 4. Diseña un programa ensamblador que defina, en el espacio de datos, la siguiente cadena de caracteres:
# "Esto es un problema" utilizando las directivas a) .asciiz, b) .byte, c) .word.

#.data
#	cadena1: .asciiz "Esto es un problema"
#	cadena2: .byte 69, 115, 116, 111, 32, 101, 115, 32, 117, 110, 32, 112, 114, 111, 98, 108, 101, 109, 97, 0
#	cadena3: .word 'E' 's' 't' 'o' ' ' 'e' 's' ' ' 'u' 'n' ' ' 'p' 'r' 'o' 'b' 'l' 'e' 'm' 'a' '\0'

# --

# ++ 5. Sabiendo que un entero se almacena en un word, diseña un programa ensamblador que defina en la memoria de datos, la siguiente matriz A de enteros a partir de la dirección 0x10010000 suponiendo que: 
# a) la matriz A se almacena por filas
# b) la matriz A se almacena por columnas.

#.data 0x10001000
#	matriz_filas: .word 1, 2, 3 # fila 1.
#	              .word 4, 5, 6 # fila 2.
#	              .word 7, 8, 9 # fila 3.
	              
#	matriz_columnas: .word 1, 4, 7 # columna 1.
#	                 .word 2, 5, 8 # columna 2.
#	                 .word 3, 6, 9 # columna 3.

# --

# ++ Practica. Reordenar un arreglo de numeros de manera ascendente. Utilizar saltos condicionales.

.data
	num: .word 5
	vector: .word 5, 8, 10, 9, 3, 8
	
.text
	main: la $s0, vector # Puntero a vector.
	      lw $s1, num # Numero de iteraciones.
	
	loop_externo: li $s2, 0 # i = 0.
	
	loop_interno: sll $t0, $s2, 2 # i = i * 4
	              add $t1, $s0, $t0 # Dirección de vector[i].
	              lw $t2, 0($t1) # Valor actual.
	              lw $t3, 4($t1) # Valor siguiente.
	              ble $t2, $t3, no_swap # Si el valor actual es menor o igual que el siguiente, entonces no se swapea.
	              
	swap: sw $t3, 0($t1)
	      sw $t2, 4($t1
	      
	no_swap:
	
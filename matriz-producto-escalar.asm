# Hacer un programa en assembly de MIPS R2000, respetando las convenciones, que solicite un escalar 
# y muestre el producto escalar. Para ello deberá realizar 3 funciones: dotMat, dotVec y outMat. La 
# función outMat es leaf y muestra la matriz. Se llama desde main. Tiene como argumento un puntero a 
# matriz y el orden de la matriz.

# La funcion dotMat es una función no leaf que llama a dotVec. O sea que para calcular el producto 
# escalar de la matriz debe realizarse el producto escalar de los vectores fila. La función dotMat se 
# llama desde main y debe recibir un punto a matriz, el orden, un escalar y un puntero a la matriz 
# resultado. 
# Finalmente está dotVec que calcula el producto escalar de los vectores fila. Se debe pasar un puntero 
# a vector fila, el orden, el escalar y el puntero al vector resultante.

.data
	matrix: .word 2, 3,
		      7, 1
		      
	matrix_res: .word 0, 0,
			  0, 0
			  
	orden: .word 2 # Matriz 2x2
	
	msg_escalar: .asciiz "Entre un entero: "
	msg_espacio: .asciiz " "
	msg_matriz_inicial: .asciiz "Dada una matriz de enteros\n"
	msg_matriz_res: .asciiz "El producto escalar resultante es:\n"
.text
	.globl main
	
	main:
		li $v0, 4 # string.
		la $a0, msg_matriz_inicial # Dada una matriz de enteros
		syscall
		
		la $a0, matrix
		lw $a1, orden
		mul $a1, $a1, $a1
		
		jal outMat
		
		li $v0, 10
		syscall

# a0: vec address.
# a1: matrix order.
# a2: scalar.
# a3: vec res address.
	dotVec:
		
# a0: matrix address.
# a1: matrix order.
# a2: scalar.
# a3: matrix res address.
	dotMat:
	
# a0: matrix address.
# a1: matrix order.
	outMat:
		move $t0, $a0
		move $t1, $a1
		
	outMat_loop:
		beqz $t1, outMat_end
		
		li $v0, 1 # int.
		lw $a0, 0($t0)
		syscall
		
		li $v0, 4 # string.
		la $a0, msg_espacio
		syscall
		
		addi $t1, $t1, -1
		addi $t0, $t0, 4
		
		j outMat_loop
	outMat_end:
		jr $ra
# Una función que multiplica (corriendo bits) x por una potencia de 2 dada por y. Luego guarda el resultado en memoria.

.data
	 x: .word 5
	 y: .word 1
	 res: .space 4
.text
	main:
		lw $a0, x
		lw $a1, y
		jal shift
		
		sw $v0, res
		
		move $a0, $v0 # Recuperamos el numero para imprimir.
		li $v0, 1
		syscall
		
		li $v0, 10 # exit.
		syscall
		
	shift: 
		bge $a1, 32, invalid # if (y >= 32), invalid.
		sllv $v0, $a0, $a1 # $v0 = x << y.
		jr $ra
	
	invalid:
		move $v0, $zero
		jr $ra
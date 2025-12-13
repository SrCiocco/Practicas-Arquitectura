# Contar de x hasta y.

.data
	x: .word 0
	y: .word 10
	msg_space: .asciiz ", "
	msg_err_greater: .asciiz "El número es mayor que el límite. Ingrese un número más pequeño.\n"
	msg_success: .asciiz "\nÉxito!\n"
.text
	main:
		lw $a0, x # Inicio.
		lw $a1, y # Limite.
		
		bgt $a0, $a1, err_greater # if (x > y), err_greater.
		
		jal conteo
		
		li $v0, 4 # print.
		la $a0, msg_success
		syscall
		
		li $v0, 10 # Finalizar programa.
		syscall
		
	conteo:
		addi $sp, $sp, -12
		sw $ra, 0($sp) # Guardamos el return address.
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		
		move $s0, $a0 # x.
		move $s1, $a1 # y.
		
		move $a0, $s0
		li $v0, 1 # Imprimir x.
		syscall
		
		bge $s0, $s1, pop # if (x >= y), pop.
		
		li $v0, 4 # print.
		la $a0, msg_space # Espacio con coma, para separar y estetizar la salida.
		syscall
		
		addi $a0, $s0, 1 # x++.
		move $a1, $s1 # Recargamos a1, por si se perdió entre syscalls.
		jal conteo
		
	pop:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		addi $sp, $sp, 12
		jr $ra
		
	err_greater:
		li $v0, 4 # print.
		la $a0, msg_err_greater
		syscall
		
		li $v0, 17 # exit2.
		li $a0, -1 # Código de error -1. ERR_GREATER
		syscall
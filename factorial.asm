# Factorial de un número.

.data
	mensaje_inicio: .asciiz "El factorial de "
	num: .word 5
	mensaje_resultado: .asciiz " es: "
.text
	main:
		la $a0, mensaje_inicio # Mensaje.
		li $v0, 4 # Imprimir mensaje.
		syscall
		
		lw $a0, num # Número.
		li $v0, 1 # Imprimir número.
		syscall
		
		la $a0, mensaje_resultado # Mensaje.
		li $v0, 4 # Imprimir mensaje.
		syscall
		
		lw $a0, num # Cargamos en $a0 el num.
		jal fact
		
		move $a0, $v0 # Guardamos el valor del return ($v0) en $a0 e imprimimos el factorial.
		li $v0, 1
		syscall
		
		li $v0, 10 # Salimos del programa.
		syscall
	
	fact:
		addi $sp, $sp, -8 # Hacemos lugar para 2 espacios en la stack. (Crece de manera decreciente).	
		sw $ra, 0($sp) # Guardamos el Return Address para no perderlo en alguna otra llamada a función.
		sw $s0, 4($sp) # Guardamos $s0 que usaremos para nuestro num.
		
		move $s0, $a0 # Guardamos num en $s0.
		li $v0, 1 # Retornamos 1 si fact(0).
		beq $s0, $zero, end # if (num == 0), end.
		
		addi $a0, $s0, -1 # num--.
		jal fact
		mul $v0, $s0, $v0 # return = num * return ???
		
	end:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
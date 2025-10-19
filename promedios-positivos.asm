# --- Calcular solamente el promedio de los numeros positivos en un vector dado y guardarlo en memoria. ---

.data
	vector: .word 5, 10, 80, -92, -57, 100, 71, -34, -2, 0, 84
	promedio: .space 4
	
.text
	main: la $t0, vector # Puntero a vector.
	      li $t1, 0 # contador = 0.
	      li $t3, 0
	      li $t4, 0 # contador de numeros positivos.
	      
	loop: beq $t1, 11, division # if (contador == 11), division.
	      lw $t2, 0($t0) # tmp = vector[i].
	      bgtz $t2, es_positivo
	      j continue # MUY IMPORTANTE HIJO DE RE MIL PUTA. SI ES NEGATIVO o CERO anda A CONTINUE CONCHUDO.
	      
	es_positivo: add $t3, $t3, $t2
	             addi $t4, $t4, 1 # Un positivo mas para la olla.
	      
	continue: addi $t1, $t1, 1 # contador++.
	          addi $t0, $t0, 4 # i += 4.
	          j loop
	
	division: div $t3, $t4
	          mflo $t5
	          sw $t5, promedio
	
	end: li $v0, 17
	     li $a0, 0
	     syscall
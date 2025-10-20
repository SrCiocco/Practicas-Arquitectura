# --- Dado un array determinado, reordenarlo ascendentemente. ---

.data
	array: .word 8, 7, 6, 5, 4, 3, 2, 1 # Orden: 1, 2, 3, 4, 5, 6, 7, 8.
	
.text
	main: li $t4, 0 # contador_externo = 0.
	      li $t5, 7 # numero de pasadas = 7 (N - 1 elementos del array).
	      
	loop_externo: la $t0, array # Puntero a array. (se va a reiniciar cada vez que vayamos a loop_externo).
	              li $t1, 0 # contador_interno = 0. (reiniciamos este contador, cada vez que vyaamos a loop_externo).
	              addi $t4, $t4, 1 # contador_externo++.
	              addi $t5, $t5, -1 # decremento el numero de pasadas en 1, asi no avanzamos hacia los numeros mas grandes.
	              bgt $t4, 7, end # if (contador_externo > 7), end.
		      
	loop_interno: bgt $t1, $t5, loop_externo # if (contador_interno > numero de pasadas), loop_externo.
	              addi $t1, $t1, 1 # contador_interno++.
	              lw $t2, 0($t0) # tmp = *array[i].
	              lw $t3, 4($t0) # tmp_delta = *array[i+1].
	              ble $t2, $t3, continue # if (tmp <= tmp_delta), continue. "NO SWAPEAMOS".
	      
	swap: sw $t2, 4($t0)
	      sw $t3, 0($t0)
	
	continue: addi $t0, $t0, 4 # Aumentamos la direccion de memoria del puntero en 4, para acceder a los siguientes numeros.
	          j loop_interno
	
	end: li $v0, 17
	     li $a0, 0
	     syscall
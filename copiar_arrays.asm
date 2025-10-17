# --- Copia de un array. --- 
# Dado un array de 5 números enteros en la memoria, escribir un programa que copie todos sus 
# elementos a un segundo array que estará justo después del primero.

.data
	array_A: .word 2, 1, 5, 10, 52
	array_B: .space 20 # Reservamos espacio para 5 enteros. (4 bytes cada entero * 5).
	contador: .word 5 # Las veces que se va a repetir el bucle.
	i: .word 0 # Indice para definir donde va a arrancar el bucle.
.text
	main: la $t0, array_A # Puntero a Array_A.
	      la $t1, array_B # Puntero a Array_B.
	      
	      lw $t2, contador # Guardamos el valor del contador en $t2.
	      lw $t3, i # Guardamos el valor del indice en $t3.
	      
	loop_externo: beqz $t2, end # Si contador es igual a 0 entonces fin.
	              sub $t2, $t2, 1 # Sino, contador--
	              
	
	loop_interno: lw $t4, array_A($t3)# tmp = Array_A[i]
		      sw $t4, array_B($t3) # Array_B[i] = tmp
		      
	incrementar_indice: add $t3, $t3, 4 # i += 4
		            j loop_externo
		            
	end: li $v0, 17 # Le mandamos la señal al sistema operativo para salir del programa con un
			# codigo de estado. (0 para exito).
			
	     li $a0, 0  # Cargamos el 0 para luego retornarlo.
	     
	     syscall	# Finalmente, llamamos a $v0 con la señal 17 y el codigo 0 "Return 0;".
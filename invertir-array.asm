# --- Invertir un array fuente. ---

.data
	array_fuente: .word 10, 20, 30, 40, 50, 60 # 6 elementos.
	array_destino: .space 24 # Espacio para 6 enteros (6 * 4 bytes).

.text
	main: li $t0, 0 # i = 0.
	      li $t1, 20 # j = 20.
	      
	swap: lw $t2, array_fuente($t1) # tmp = array_fuente[j].
	      sw $t2, array_destino($t0) # array_destino[i] = tmp.
	      beqz $t1, end
	      
	loop: addi $t0, $t0, 4 # i += 4.
	      addi $t1, $t1, -4 # j -= 4.
	      j swap
	      
	end: li $v0, 17
	     li $a0, 0
	     syscall
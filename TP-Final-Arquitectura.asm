.data
	slist: .word 0 # A este puntero lo utilizan smalloc y sfree.
	cclist: .word 0 # El puntero cclist apunta a la lista de categorías.
	wclist: .word 0 # El puntero wclist apunta a la categoría seleccionada en curso.
	schedv: .space 32 # El vector schev contiene las direcciones de todas las funciones que debo programar.
	menu: .ascii  "Colecciones de objetos categorizados\n"
              .ascii  "====================================\n"
              .ascii  "1-Nueva categoria\n"
	      .ascii  "2-Siguiente categoria\n"
       	      .ascii  "3-Categoria anterior\n"
              .ascii  "4-Listar categorias\n"
	      .ascii  "5-Borrar categoria actual\n"
              .ascii  "6-Anexar objeto a la categoria actual\n"
              .ascii  "7-Listar objetos de la categoria\n"
	      .ascii  "8-Borrar objeto de la categoria\n"
	      .ascii  "0-Salir\n"
	      .asciiz "Ingrese la opcion deseada: "
	error: .asciiz "Error: "
	return: .asciiz "\n"
	catName: .asciiz "\nIngrese el nombre de una categoria: "
	selCat: .asciiz "\nSe ha seleccionado la categoria:"
	idObj: .asciiz "\nIngrese el ID del objeto a eliminar: "
	objName: .asciiz "\nIngrese el nombre de un objeto: "
	success: .asciiz "La operación se realizo con exito\n\n"

# +++ Lista de errores +++.

# Error al seleccionar una opción en el menu:
ERR_SEL_101: .word 101 # Si el error fuera una selección inexistente del menú, se informará el error (101).

# Errores al seleccionar una categoría:
ERR_SEL_201: .word 201 # Si no hay categorías se informará el error (201).
ERR_SEL_202: .word 202 # Si hay una sola categoría se informará el error (202).

# Error al listar las categorías:
ERR_LIST_301: .word 301 # Si no hay categorías se informará el error (301).

# Error al borrar una categoría seleccionada:
ERR_DEL_401: .word 401 # Si se invoca cuando no hay categorías debe informar el error (401).

# Error al anexar un objeto a la categoría seleccionada en curso:
ERR_ADD_501: .word 501 # Si se invoca cuando no hay categorías debe informar el error (501).

# Errores al listar objetos de la categoría en curso:
ERR_LIST_601: .word 601 # Si no hay categorías creadas se informará el error (601).
ERR_LIST_602: .word 602 # Si no hay objetos para la categoría en curso se informará el error (602).

# Errores al borrar un objeto de la categoría seleccionada en curso usando el ID:
ERR_DEL_701: .word 701 # Si no existen categorías el error (701).
ERR_DEL_MSG: .asciiz "notFound" # Si el ID provisto no es encontrado se informará con un mensaje notFound.

# --- Lista de errores ---.

.text
	main:   
		la $t0, schedv # initialization scheduler vector
		
        	la $t1, newcategory
        	sw $t1, 0($t0)
        	
        	la $t1, nextcategory
        	sw $t1, 4($t0)
        	
        	la $t1, prevcategory
        	sw $t1, 8($t0)
        	
        	la $t1, listcategory
        	sw $t1, 12($t0)
        	
        	la $t1, delcategory
        	sw $t1, 16($t0)
        	
        	la $t1, newobject
        	sw $t1, 20($t0)
        	
        	la $t1, listobjects
        	sw $t1, 24($t0)
        	
        	la $t1, delobject
        	sw $t1, 28($t0)
        loop:
        	jal printmenu
        	move $t1, $v0
        	
        	beqz $t1, exit
        	
        	li $t2, 8 # Limite del menu.
        	bgt $t1, $t2, err_sel_101 # Error 101.
        	
        	la $t0, schedv # Recargo el vector en $t0 por si alguna función sobreescribe $t0.
        	
        	addiu $t1, $t1, -1 # Igualo el indice del vector.
        	sll $t1, $t1, 2 # Corro 2 bits a la izquierda para multiplicar por 4 y acceder al indice real del vector.
        	addu $t1, $t1, $t0
        	lw $t1, ($t1)
        	
        	jalr $t1 # Llamo a la función.
        	
        	move $t1, $v0 # Guardo el retorno de la función.
        	bnez $t1, print_err # Si falló la función entonces imprimo el error.
        	
        	j loop
        	
        print_err:
        	move $t0, $v0
        	
        	li $v0, 4 # print string.
        	la $a0, error
        	syscall
        	
        	li $v0, 1 # print int.
        	move $a0, $t0
        	syscall
        	
        	li $v0, 4 # print string.
        	la $a0, return # Salto de linea.
        	syscall
        	
        	j loop
        		
        err_sel_101:
        	lw $v0, ERR_SEL_101
        	j print_err
        	
        printmenu:
        	li $v0, 4 # print string.
        	la $a0, menu
        	syscall
        	
        	li $v0, 5 # read integer.
        	syscall
        	
        	jr $ra
        	
	exit:
		li $v0, 10
		syscall

# a0: nombre del nodo a imprimir

	print_node_name:
		move $t0, $a0 # Guardo el argumento en $t0, pq syscall me pide a0 para cargar la string.
	
		li $v0, 4 # print string.
        	la $a0, selCat # La categoria seleccionada es: 
        	syscall
        	
        	lw $a0, 8($t0) # Cargo el nombre.
        	syscall
        	
        	li $v0, 4 # print string.
        	la $a0, return # Salto de linea.
        	syscall
        	
        	jr $ra
        	
        nextcategory:
        	addi $sp, $sp, -4
        	sw $ra, 0($sp)
        	
        	lw $t0, wclist # dirección de la categoria actual.
        	beqz $t0, err_sel_201 # ERROR: no hay otras categorias.
        	
        	lw $t1, 12($t0) # dirección de la siguiente categoria.
        	beq $t0, $t1, err_sel_202 # ERROR: solo hay una categoria.
        	
        	sw $t1, wclist # actualizo.
        	
        	move $a0, $t1
        	jal print_node_name
        	
        nextcategory_end:
        	lw $ra, 0($sp)
        	addi $sp, $sp, 4
        	
        	li $v0, 0 # return 0.
        	jr $ra
        
        err_sel_201:
        	lw $ra, 0($sp)
        	addi $sp, $sp, 4
        	
        	lw $v0, ERR_SEL_201
        	jr $ra
        	
        err_sel_202:
                lw $ra, 0($sp)
        	addi $sp, $sp, 4
        	
        	lw $v0, ERR_SEL_202
        	jr $ra
	
        prevcategory:
        	addi $sp, $sp, -4
        	sw $ra, 0($sp)
        	
        	lw $t0, wclist # dirección de la categoria actual.
        	beqz $t0, err_sel_201 # ERROR: no hay otras categorias.
        	
        	lw $t1, 0($t0) # dirección de la categoria anterior.
        	beq $t0, $t1, err_sel_202 # ERROR: solo hay una categoria.
        	
        	sw $t1, wclist # actualizo.
        	
        	move $a0, $t1
        	jal print_node_name
        	
        prevcategory_end:
        	lw $ra, 0($sp)
        	addi $sp, $sp, 4
        	
        	li $v0, 0 # return 0.
        	jr $ra
        
        listcategory:
        	addi $sp, $sp, -12
        	sw $ra, 8($sp)
        	sw $s0, 4($sp)
        	sw $s1, 0($sp)
        	
        	lw $s0, cclist # Cargamos la dirección de la lista de categorias.
        	beqz $s0, err_list_301 # ERROR: no hay categorias.
        	
        	move $s1, $s0 # Apunto al primer elemento de la lista de categorias en $s1, para usarlo luego como indice.
        	
        loop_list:
        	move $a0, $s1
        	jal print_node_name
        	
        	lw $s1, 12($s1)
        	bne $s1, $s0, loop_list
        	
        listcategory_end:
        	lw $s1, 0($sp)
        	lw $s0, 4($sp)
        	lw $ra, 8($sp)
        	addi $sp, $sp, 12
        	
        	li $v0, 0 # return 0.
        	jr $ra

        err_list_301:
        	lw $s1, 0($sp)
        	lw $s0, 4($sp)
        	lw $ra, 8($sp)
        	addi $sp, $sp, 12

        	lw $v0, ERR_LIST_301
        	jr $ra

        delcategory:
        	addi $sp, $sp, -4
        	sw $ra, 0($sp)

        	lw $a0, wclist # Categoria seleccionada en curso.
        	beqz $a0, err_del_401 # ERROR: no hay categoria a borrar.
        	
        	la $a1, cclist
        	
        	jal delnode # Borro el nodo y libero la memoria.
        	
        	lw $t0, cclist
        	sw $t0, wclist
        	
        delcategory_end:
        	lw $ra, 0($sp)
        	addi $sp, $sp, 4
        	
        	li $v0, 0 # return 0.
        	jr $ra
        	
        err_del_401:
        	lw $ra, 0($sp)
        	addi $sp, $sp, 4
        	
        	lw $v0 ERR_DEL_401
        	jr $ra

	newobject:
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		lw $t0, wclist # Cargo la dirección de la categoria actual.
		beqz $t0, err_add_501 # ERROR: no hay categorias para añadir el objeto.
		
		la $a0, objName
		jal getblock
		
		lw $t0, wclist
		la $a0, 4($t0)
		
		li $a1, 0
		move $a2, $v0
		jal addnode
		
	newobject_end:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		li $v0, 0 # return 0.
		jr $ra
		
	err_add_501:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		lw $v0, ERR_ADD_501
		jr $ra
	
	listobjects:
	
	delobject:
	
# Funciones auxiliares de la catedra:

# a0: list address
# a1: NULL if category, node address if object
# v0: node address added

	addnode:
        	addi $sp, $sp, -8
        	sw $ra, 4($sp)
        	sw $a0, 0($sp)
        	jal smalloc
        	sw $a1, 4($v0) # set node content
        	sw $a2, 8($v0)
        	lw $a0, 0($sp)
        	lw $t0, ($a0) # first node address
        	beqz $t0, addnode_empty_list
        	
	addnode_to_end:
        	lw $t1, ($t0) # last node address
        	
        	# update prev and next pointers of new node
        	sw $t1, 0($v0)
        	sw $t0, 12($v0)
        	
	        # update prev and first node to new node
        	sw $v0, 12($t1)
        	sw $v0, 0($t0)
        	
        	j addnode_exit
        	
	addnode_empty_list:
        	sw $v0, ($a0)
        	sw $v0, 0($v0)
	        sw $v0, 12($v0)
	        
	addnode_exit:
        	lw $ra, 4($sp)
        	addi $sp, $sp, 8
        	jr $ra
        	
# a0: node address to delete
# a1: list address where node is deleted
	delnode:
        	addi $sp, $sp, -8
        	sw $ra, 4($sp)
        	sw $a0, 0($sp)
        	lw $a0, 8($a0) # get block address
        	jal sfree # free block
        	lw $a0, 0($sp) # restore argument a0
        	lw $t0, 12($a0) # get address to next node of a0 node
        	
        	beq $a0, $t0, delnode_point_self
        	lw $t1, 0($a0) # get address to prev node
        	sw $t1, 0($t0)
        	sw $t0, 12($t1)
        	lw $t1, 0($a1) # get address to first node again
        	
        	bne $a0, $t1, delnode_exit
        	sw $t0, ($a1) # list point to next node
        	j delnode_exit
        	
	delnode_point_self:
        	sw $zero, ($a1) # only one node
        	
	delnode_exit:
        	jal sfree
        	lw $ra, 4($sp)
        	addi $sp, $sp, 8
        	jr $ra
        	
# a0: msg to ask
# v0: block address allocated with string
	getblock:
        	addi $sp, $sp, -4
        	sw $ra, 0($sp)
        	li $v0, 4
	        syscall
        	jal smalloc
        	move $a0, $v0
        	li $a1, 16
        	li $v0, 8
        	syscall
        	move $v0, $a0
        	lw $ra, 0($sp)
        	addi $sp, $sp, 4
        	jr $ra

	smalloc:
         	lw $t0, slist
         	beqz $t0, sbrk
         	move $v0, $t0
         	lw $t0, 12($t0)
         	sw $t0, slist
         	jr $ra
         
	sbrk:
         	li $a0, 16 # node size fixed 4 words
         	li $v0, 9
         	syscall # return node address in v0
         	jr $ra
         
	sfree:
         	lw $t0, slist
         	sw $t0, 12($a0)
         	sw $a0, slist  # $a0 node address in unused list
         	jr $ra
         	
	newcategory:
		addiu $sp, $sp, -4
        	sw $ra, 0($sp)
        	la $a0, catName # input category name
        	jal getblock
        	move $a2, $v0 # a2 = *char to category name
        	la $a0, cclist # a0 = list
        	li $a1, 0 # a1 = NULL
        	jal addnode
        	lw $t0, wclist
        	bnez $t0, newcategory_end
        	sw $v0, wclist # update working list if was NULL
        
	newcategory_end:
		li $v0, 0 # return success
        	lw $ra, 0($sp)
        	addiu $sp, $sp, 4
        	jr $ra

# newcategory[X],  nextcategory[X],  prevcategory[X], listcategories[X] y delcategory[X] para cumplir con los primeros 4 puntos. 
# Para los objetos tendríamos newobject[], listobjects[] y delobject[]. 
# Las mismas no tienen argumento pero devolverán un entero positivo indicando el error o cero.

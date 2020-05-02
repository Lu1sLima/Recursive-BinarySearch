
.data
V: .word -5 -1 5 9 12 15 21 29 31 58 250 325
str: .asciiz "O valor esta na posicao: "
str1: .asciiz "Informe o inicio: "
str2: .asciiz "Informe o fim: "
str3: .asciiz "Informe o valor: "



.text
.globl main
main:
	la $a0, str1
	li $v0, 4
	syscall #Imprime "Informe o inicio: "
	
	li $v0, 5 
	syscall #Lê um inteiro

	move $a1, $v0 #Guardei o valor de first em $a1
	
	la $a0, str2
	li $v0, 4
	syscall #Imprime "Informe o fim: "
	
	li $v0, 5
	syscall #Le un inteiro
	
	move $a2, $v0 #Guardei o valor do fim em $a2
	
	la $a0, str3
	li $v0, 4
	syscall #Imprime "Informe o valor: "
	
	li $v0, 5
	syscall #Le um inteiro
	
	move $a3, $v0 #Guardei o valor a ser procurado em $a3
	
	la $a0, V #Guardei o valor de V em $a0
	
	addiu $sp, $sp, -16 #Abrindo 4 espaços na pilha
	sw $a0, 0($sp) #empilhando a referencia par ao vetor
	sw $a1, 4($sp) #empilhando o valor do inicio
	sw $a2, 8($sp) #empilhando o valor do fim
	sw $a3, 12($sp) #empilhando o valor a ser procurado
	
	jal binsearch
	
	move $t1, $v0 #colocando o valor retornado ($v0) em $t1, pq vou reescrever o $v0 abaixo
	
	la $a0, str
	li $v0, 4
	syscall #Imprime "O valor está na posicao: "
	
	li $v0, 1
	move $a0, $t1 #Imprime o resultado
	syscall
	
	li $v0, 10 #fecha o programa
	syscall
	
	
binsearch:	
	lw $a0, 0($sp) #desempilhando referencia para o vetor
	lw $a1, 4($sp) #desempilhando valor do inicio
	lw $a2, 8($sp) #desempilhando valor do fim
	lw $a3, 12($sp) #desempilhando valor a ser procurado
	addiu $sp, $sp, 16 #ajustando a pilha
		
	slt $t0, $a2, $a1 #verificando se fim é menor do que inicio (if prim > ult)
	beq $t0, $zero, else1 #se fim não é menor do que o início, passa para o ELSE
	
	li $t0, -1
	move $v0, $t0
	jr $ra
	
else1:
	addu $t0, $a1, $a2 # somando fim + meio
	div $t0, $t0, 2 #calculando valor do meio, (meio = inicio+fim/2)
	mul $t1, $t0, 4 #vendo quanto terei que mover no vetor meio * 4
	addu $t7, $a0, $t1 #deslocando o ponteiro do vetor até o valor A[meio]
	lw $t2, 0($t7) #carregando o valor de A[meio]
	
	beq $t2, $a3, fim #se A[meio] == valor, vai para fim
	slt $t1, $a3, $t2 #verificando se valor < A[meio]
	bgtz $t1, elsif # se VALOR < A[meio] vai para o else if
	
	#aqui para baixo é o "ELSE2"
	move $a1, $t0 # Colocando inicio com valor de meio
	addiu $a1, $a1, 1 #Adicionando +1 no meio
	
	addiu $sp, $sp, -20
	sw $a0, 0($sp) #empilhando a referencia par ao vetor
	sw $a1, 4($sp) #empilhando o valor do inicio
	sw $a2, 8($sp) #empilhando o valor do fim
	sw $a3, 12($sp) #empilhando o valor a ser procurado
	sw $ra, 16($sp) #empilhando o retorno $ra
	jal binsearch
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	j fim
	
elsif:
	move $a2, $t0 #fim será meio
	addiu $a2, $a2, -1 #fim é meio-1
	addiu $sp, $sp, -20 #abrindo 5 espacos na pilha
	sw $a0, 0($sp) #empilhando a referencia par ao vetor
	sw $a1, 4($sp) #empilhando o valor do inicio
	sw $a2, 8($sp) #empilhando o valor do fim
	sw $a3, 12($sp) #empilhando o valor a ser procurado
	sw $ra, 16($sp) #empilhando o retorno $ra
	jal binsearch
	lw $ra, 0($sp) #desempilhando o $ra
	addiu $sp, $sp, 4 #ajeitando a pilha
	j fim
fim:
	move $v0, $t0 #coloca o valor em $v0 para retorno
	jr $ra
	
	
	
	
	
	
	

.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
    save_context
    move $s1, $a0 # $s1 = linha
    move $s2, $a1 # $s2 = coluna
    move $s0, $a2 # $s0 = board
    
    li $s7, 0 # $s7 (count) = 0

    addi $s3, $s1, -1 # $s3 (i) = linha - 1

    begin_for_i_ca:
    addi $t0, $s1, 1 # $t0 = linha + 1
    bgt $s3, $t0, end_for_i_ca
    addi $s4, $s2, -1 # $s4 (j) = coluna - 1

    begin_for_j_ca:
    addi $t0, $s2 , 1 # $t0 = coluna + 1
    bgt $s4, $t0, end_for_j_ca

    blt $s3, 0, else_invalid
    bge $s3, SIZE, else_invalid
    blt $s4, 0, else_invalid
    bge $s4, SIZE, else_invalid # validações

    sll $t0, $s3, 5
    sll $t1, $s4, 2
    add $t0, $t0, $t1
    add $t0, $t0, $s0 # $t0 = endereço de board[i][j]
    lw $s6, 0($t0) # $s6 = valor de board[i][j]

    bne $s6, -1, else_invalid
    addi $s7, $s7, 1
    addi $s4, $s4, 1
    j begin_for_j_ca
    
    else_invalid:
    addi $s4, $s4, 1
    j begin_for_j_ca

    end_for_j_ca:
    addi $s3, $s3, 1
    j begin_for_i_ca

    end_for_i_ca:
    move $v0, $s7
    restore_context
    jr $ra


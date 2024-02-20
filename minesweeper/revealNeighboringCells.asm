.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells: 
    save_context
    move $s1, $a0 # $s1 == linha
    move $s2, $a1 # $s2 == col
    move $s0, $a2 # $s0 == board

    addi $s3, $s1, -1 # $s3 (i) = linha - 1

    begin_for_i_rn:
    addi $t0, $s1, 1 # $t0 = linha + 1
    bgt $s3, $t0, end_for_i_rn
    addi $s4, $s2, -1

    begin_for_j_rn:
    addi $t0, $s2, 1
    bgt $s4, $t0, end_for_j_rn

    blt $s3, 0, else_invalid
    bge $s3, SIZE, else_invalid
    blt $s4, 0, else_invalid
    bge $s4, SIZE, else_invalid # validações overflow tabuleiro

    sll $t0, $s3, 5
    sll $t1, $s4, 2
    add $t0, $t0, $t1
    add $t0, $t0, $s0 # $t0 = endereço de board[i][j]
    lw $s7, 0($t0) # $s7 = valor de board[i][j]

    bne $s7, -2, else_invalid # if (board[i][j] == -2)

    move $a0, $s3
    move $a1, $s4

    jal countAdjacentBombs # passando "i" e "j" como row e column

    move $s5, $v0 # $s5 = countAdjacentBombs

    sll $t0, $s3, 5
    sll $t1, $s4, 2
    add $t0, $t0, $t1
    add $t0, $t0, $s0 # $t0 = endereço de board[i][j]
    sw $s5, 0($t0) # board[i][j] = $s5
    
    bne $s5, 0, else_invalid
    jal revealNeighboringCells

    else_invalid:
    addi $s4, $s4, 1
    j begin_for_j_rn

    end_for_j_rn:
    addi $s3, $s3, 1
    j begin_for_i_rn

    end_for_i_rn:
    restore_context  
    jr $ra
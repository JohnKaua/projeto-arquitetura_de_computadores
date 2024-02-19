.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
    save_context
    move $s2, $a0 # s3 == linha
    move $s3, $a1 # s2 == col
    move $s0, $a2 # s3 == board
    
    
    li $t5, 0 #count = 0
    addi $t1, $s2, -1 # i = row - 1
    addi $t2, $s2, 1 # t2 = row + 1
    addi $t3, $s3, -1 # j = column - 1
    addi $t4, $s3, 1 # t4 = column + 1 
    begin_for_i_ca:
    bgt $t1, $t2, end_for_i_ca
    
    j begin_for_j_ca
    begin_for_j_ca:
    bgt $t3, $t4, end_for_j_ca
    blt $t1, 0, else_invalid
    bge $t1, SIZE, else_invalid
    blt $t3, 0, else_invalid
    bge $t3, SIZE, else_invalid
    # board[i][j] == -1
    sll $t6, $t1, 5
    sll $t7, $t3, 2
    add $t6, $t6, $t7
    add $t6, $t6, $s0
    lw $t7, 0($t6)
    bne $t7, -1, else_invalid
    addi $t5, $t5, 1
    addi $t3, $t3, 1
    j begin_for_j_ca
    
    else_invalid:
    addi $t3, $t3, 1
    j begin_for_j_ca
    end_for_j_ca:
    addi $t1, $t1, 1
    addi $t3, $s3, -1
    j begin_for_i_ca
    end_for_i_ca:
    move $v0, $t5
    restore_context
    jr $ra


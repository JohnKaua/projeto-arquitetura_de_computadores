.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells: 
    save_context
    move $s1, $a0 # s1 == linha
    move $s2, $a1 # s2 == col
    move $s0, $a2 # s3 == board

    addi $t1, $s1, -1 # i = row - 1
    addi $t2, $s1, 1 # t2 = row + 1
    addi $t3, $s2, -1 # j = column - 1
    addi $t4, $s2, 1 # t4 = column + 1 
    begin_for_i_rn:
    bgt $t1, $t2, end_for_i_rn
    j begin_for_j_rn
    begin_for_j_rn:
    bgt $t3, $t4, end_for_j_rn
    blt $t1, 0, else_invalid
    bge $t1, SIZE, else_invalid
    blt $t3, 0, else_invalid
    bge $t3, SIZE, else_invalid
    # board[i][j] == -1
    sll $t6, $t1, 5
    sll $t7, $t3, 2
    add $t6, $t6, $t7
    add $t6, $t6, $s0
    lw $t8, 0($t6)
    bne $t8, -2, else_invalid

    jal countAdjacentBombs
    move $t3, $v0 # t3 == x
    move $t6, $t3
    beq $t6, 0, revealNeighboringCells
    j end_for_i_rn

    else_invalid:
    addi $t3, $t3, 1
    j begin_for_j_rn
    end_for_j_rn:
    addi $t1, $t1, 1
    j begin_for_i_rn
    end_for_i_rn:
    
    restore_context  
    jr $ra


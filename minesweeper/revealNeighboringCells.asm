.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells: 
    save_context
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2

    sub $t1, $s1, 1 # i = row - 1
    addi $t2, $s1, 1 # t2 = row + 1
    sub $t3, $s2, 1 # j = column - 1
    addi $t4, $s2, 1 # t4 = column + 1 
    begin_for_i_rn:
    bgt $t1, $t2, end_for_i_rn
    j begin_for_j_rn
    begin_for_j_rn:
    bgt $t3, $t4, end_for_j_rn
    bge $t1, 0, else_invalid
    blt $t1, SIZE, else_invalid
    bge $t3, 0, else_invalid
    blt $t3, SIZE, else_invalid
    # board[i][j] == -1
    sll $t6, $a0, 4
    sll $t7, $a1, 2
    add $t6, $t6, $t7
    add $t6, $t6, $s0
    beq $t6, -2, else_invalid

    jal countAdjacentBombs
    sw $t3, 0($v0) # t3 == x
    move $t6, $t3
    beq $t3, 0, revealNeighboringCells

    else_invalid:
    addi $t3, $t3, 1
    j begin_for_j_rn
    end_for_j_rn:
    addi $t1, $t1, 1
    j begin_for_i_rn
    end_for_i_rn:
    
    restore_context  
    jr $ra


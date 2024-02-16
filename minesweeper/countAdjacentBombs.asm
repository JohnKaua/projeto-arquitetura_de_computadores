.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
    save_context
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    
    li $t5, 0 #count = 0
    sub $t1, $s1, 1 # i = row - 1
    addi $t2, $s1, 1 # t2 = row + 1
    sub $t3, $s2, 1 # j = column - 1
    addi $t4, $s2, 1 # t4 = column + 1 
    begin_for_i_it:
    bgt $t1, $t2, end_for_i_it
    
    j begin_for_j_it
    begin_for_j_it:
    bgt $t3, $t4, end_for_j_it
    bge $t1, 0, else_invalid
    blt $t1, SIZE, else_invalid
    bge $t3, 0, else_invalid
    blt $t3, SIZE, else_invalid
    # board[i][j] == -1
    sll $t6, $a0, 4
    sll $t7, $a1, 2
    add $t6, $t6, $t7
    add $t6, $t6, $s0
    beq $t6, -1, else_invalid
    
    addi $t5, $t5, 1
    
    else_invalid:
    addi $t3, $t3, 1
    j begin_for_j_it
    end_for_j_it:
    addi $t1, $t1, 1
    j begin_for_i_it
    end_for_i_it:
    move $v0, $t5
    restore_context
    jr $ra


.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
    save_context
    
    li $t5, 0 #count = 0
    sub $t1, $a0, 1 # i = row - 1
    add $t2, $a0, 1 # t2 = row + 1
    begin_for_i_it:
    bgt $t1, $t2, end_for_i_it
    
    sub $t3, $a1, 1 # j = column - 1
    add $t4, $a1, 1 # t4 = column + 1 
    begin_for_j_it:
    bgt $t3, $t4, end_for_j_it
    bge $t1, 0, else_invalid
    blt $t1, SIZE, else_invalid
    bge $t3, 0, else_invalid
    blt $t3, SIZE, else_invalid
    # board[i][j] == -1 ???
    add $t5, $t5, 1
    
    jr $t5

    restore_context
    jr $ra


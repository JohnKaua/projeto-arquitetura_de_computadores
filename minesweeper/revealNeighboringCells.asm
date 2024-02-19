.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells: 
    save_context
    move $s2, $a0 #$s3 == linha
    move $s3, $a1 # s2 == col
    move $s0, $a2 # s3 == board

    addi $s4, $s2, -1 # $s4 == i = row - 1
    addi $s5, $s2, 1 # s5 = row + 1
    addi $s6, $s3, -1 # j = column - 1
    addi $s7, $s3, 1 # s7 = column + 1 
    begin_for_i_rn:
    bgt $s4, $s5, end_for_i_rn

    j begin_for_j_rn
    begin_for_j_rn:
    bgt $s6, $s7, end_for_j_rn
    # board[i][j] == -1
    sll $t6, $s4, 5
    sll $t7, $s6, 2
    add $t6, $t6, $t7
    add $t6, $t6, $s0
    lw $t7, 0($t6)
    blt $s4, 0, else_invalid
    bge $s4, SIZE, else_invalid
    blt $s6, 0, else_invalid
    bge $s6, SIZE, else_invalid
    bne $t7, -2, else_invalid
    move $a0, $s4
    move $a1, $s6
    jal countAdjacentBombs
    move $t8, $v0 # s6 == x
    sw $t8, 0($t6)
    beq $t6, 0, revealNeighboringCells
    addi $s6, $s6, 1
    j begin_for_j_rn

    else_invalid:
    addi $s6, $s6, 1
    j begin_for_j_rn
    end_for_j_rn:
    addi $s4, $s4, 1
    addi $s6, $s3, -1
    j begin_for_i_rn
    end_for_i_rn:
    
    restore_context  
    jr $ra


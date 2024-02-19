.include "macros.asm"

.globl checkVictory

checkVictory:
    save_context
   	move $s0, $a2 # $s0 = board

    li   $s1, 0 #count
    li   $s3, 0 # i = 0

    begin_for_i_cv:
    li   $t1, SIZE
    bge  $s3, $t1, end_for_i_cv
    li   $s2, 0 # j = 0
    begin_for_j_cv:

    bge  $s2, $t1, end_for_j_cv
    sll	 $t4, $s3, 5
    sll	 $t5, $s2, 2
    add	 $t4, $t4, $t5
    add	 $t4, $t4, $s0
    lw   $s5, 0($t4) # $s5 = board[i][j]
    bge $s5,$zero, if_func 
    addi $s2, $s2, 1
    j begin_for_j_cv

    end_for_i_cv:
    mul $t5, $t1, $t1
    sub $t5, $t5, BOMB_COUNT
    blt $s1, $t5, return_0
    li $v0, 1
    j return_1

    if_func:
    addi $s1, $s1, 1
    addi $s2, $s2, 1
    j begin_for_j_cv

    end_for_j_cv:
    addi $s3, $s3, 1
    j begin_for_i_cv

    return_0:
    li $v0, 0

    return_1:
    restore_context
    jr $ra

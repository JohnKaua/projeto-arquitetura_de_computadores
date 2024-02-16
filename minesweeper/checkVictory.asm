.include "macros.asm"

.globl checkVictory

checkVictory:
    save_context
	move $s0, $a0

    li $t0, 0 #count
    li $t3, 0 # i = 0
    li $t2, 0 # j = 0
    begin_for_i_cv:						# for (int i = 0; i < SIZE; ++i)	
    li $t1, SIZE
    bge $t3, $t1, end_for_i_cv
    j begin_for_j_cv
    begin_for_j_cv:						# for (int j = 0; j < SIZE; ++j)
    bge $t2, $t1, end_for_j_cv
    addi $t2, $t2, 1
	bge $t4,$zero, if_func

    end_for_i_cv:
    mul $t5, $t1, $t1
    sub $t5, $t5, BOMB_COUNT
    blt $t0, $t5, return_0
    li $v0, 1
    j return_1

    if_func:
    addi $t0, $t0, 1
    j begin_for_j_cv

    end_for_j_cv:
    addi $t3, $t3, 1
    j begin_for_i_cv

    return_0:
    li $v0, 0

    return_1:
    restore_context
    jr $ra

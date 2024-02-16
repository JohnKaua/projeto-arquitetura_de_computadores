.include "macros.asm"

.globl checkVictory

checkVictory:
    save_context
	move $s0, $a0

    li $t0, 0
    li $t3, 0 # i = 0
    li $t2, 0 # j = 0
    begin_for_i:						# for (int i = 0; i < SIZE; ++i)	
    li $t1, SIZE
    bge $t0, $t1, end_for_i
    j begin_for_j_it
    begin_for_j_it:						# for (int j = 0; j < SIZE; ++j)
    bge $t2, $t1, end_for_j_it
    addi $t2, $t2, 1
	bge $t4,$zero, if_func

    end_for_i:
    mul $t5, $t1, $t1
    sub $t5, $t5, BOMB_COUNT
    blt $t0, $t5, return_0
    li $v0, 1

    return_0:
    li $v0, 0

    if_func:
    add $t0, $t0, 1

    end_for_j_it:
    addi $t3, $t3, 1
    j begin_for_i

    restore_context
    jr $ra

.include "macros.asm"

.globl play

play:
    save_context
    move $s0, $a0

    li $t1, -1
    beq $s0, $t0, return0

    li $t1, -2
    jal countAdjacentBombs
    sw $t3, 0($v0) # t3 == x
    beq $t1, $t2, x_recb_count          #if ()

    li $t2, -1
    bne $t3, $t2, revealNeighboringCells   #if(!x) revealAdjacentBombs
    
    li $t2, 1
    jr $t2      #return 1

    return0:
    li $v0, 0
    syscall

    x_recb_count:
    move $t3, $t1

    restore_context
    jr $ra
    

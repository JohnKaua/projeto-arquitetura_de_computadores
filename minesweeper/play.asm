.include "macros.asm"

.globl play

play:
    save_context
    lw $t1, 0 ($t0) #perguntar se eh isso memo
    li $t2, -1
    beq $t1, $t2, return0

    li $t2, -2
    jal countAdjacentBombs
    sw $t3, 0 () # t3 == x
    beq $t1, $t2, x_recb_count          #if ()

    li $t2, -1
    bne $t3, $t2, revealAdjacentBombs   #if(!x) revealAdjacentBombs
    
    li $t2, 1
    jr $t2      #return 1

    return0:
    jr $zero

    x_recb_count:
    move $t3, $t1

    restore_context
    jr $ra
    

.include "macros.asm"

.globl play

play:
    save_context
    li $v0, 1                                   # valor de $v0 = 1
    move $s1, $a0                               # $s1 = linha
    move $s2, $a1                               # $s2 = coluna
    move $s0, $a2                               # $s0 = board
    
    sll	$t0, $s1, 5
    sll	$t1, $s2, 2
    add	$t0, $t0, $t1
    add	$s3, $t0, $s0                           # $s3 = board[row][column] (endereço)
    lw $s4, 0($s3)                              # $s4 = valor de $s3

    li $t2, -1
    beq $s4, $t2, if_1                          # if(board[row][column] == -1)

    li $t2, -2
    beq $s4, $t2, if_2                          # if(board[row][column] == -2)
    j return1

    if_1:
    li $v0, 0                                   # return 0, game over
    j end

    if_2:
    move $a0, $s1
    move $a1, $s2
    move $a2, $s0
    jal countAdjacentBombs
    move $s5, $v0                               # $s5 = countAdjacentBombs
    sw $s5, 0($s3)                              # board = $s5

    li $t2, 0
    beq $s5, $t2, if_3                          # if($s5 == 0) revealAdjacentBombs
    j return1
    
    if_3:
    jal revealNeighboringCells

    return1:
    li $v0, 1                                   # return 1
    end:
    restore_context
    jr      $ra

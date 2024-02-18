.include "macros.asm"

.globl play

play:
    save_context
    li      $v0, 1                                  # valor de $v0 = 1
    move $s1, $a0 # s1 == linha
    move $s2, $a1 # s2 == col
    move $s0, $a2 # s3 == board
    
    sll		$t0, $s1, 5
    sll		$t1, $s2, 2
    add		$t0, $t0, $t1
    add		$t0, $t0, $s0                           # $t0 = board[row][column] (endereço)

    lw      $t1, 0($t0)                             # $t1 = valor de $t0

    li      $t2, -1
    beq     $t1, $t2, if_1                          # if(board[row][column] == -1)

    li      $t2, -2
    beq     $t1, $t2, if_2                          # if(board[row][column] == -2)
    j       return1

    if_1:
        li      $v0, 0                              # return 0, game over
        j       end

    if_2:
    	move $a0, $s1 # s1 == linha
    	move $a1, $s2 # s2 == col
    	move $a2, $s0 # s3 == board
        jal     countAdjacentBombs
        move    $t3, $v0                            # x = countAdjacentBombs
        move    $t1, $t3                            # board = x

        li      $t2, 0                              #                            !!!!!!!(falta arrumar)!!!!!!!
        beq     $t3, $t2, if_3                      # if(!x) revealAdjacentBombs !!!!!!!(falta arrumar)!!!!!!!
        j       return1
    
    if_3:
        jal     revealNeighboringCells

    return1:
        li          $v0, 1                          # return 1
    end:
    restore_context
    jr      $ra

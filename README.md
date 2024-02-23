# Relatório - Projeto Campo Minado
## **Função "play"**
```Assembly
li $v0, 1 # valor de $v0 = 1
move $s1, $a0 # $s1 = linha
move $s2, $a1 # $s2 = coluna
move $s0, $a2 # $s0 = board
```
**$v0** recebe por padrão o valor 1 e movemos as cordenadas e endereço do board para registradores **$s**

```Assembly
sll	$t0, $s1, 5
sll	$t1, $s2, 2
add	$t0, $t0, $t1
add	$s3, $t0, $s0 # $s3 = board[row][column] (endereço)
lw $s4, 0($s3) # $s4 = valor de $s3
```
**$s3** recebe o endereço da casa escolhida pelo jogador e **$s4** receber o valor
___
```Assembly
li $t2, -1
beq $s4, $t2, if_1 # if(board[row][column] == -1)

li $t2, -2
beq $s4, $t2, if_2 # if(board[row][column] == -2)
j return1
```
São feitas as verificações em relação a casa escolhida pelo jogador, se a casa está livre ou se a casa era uma bomba
___
```Assembly
if_1:
li $v0, 0 # return 0, game over
j end
```
Se o valor da casa escolhida for *-1*, ela é uma bomba, a função retorna 0 e o jogo acaba como derrota
___
```Assembly
if_2:
move $a0, $s1
move $a1, $s2
move $a2, $s0
jal countAdjacentBombs
move $s5, $v0 # $s5 = countAdjacentBombs
sw $s5, 0($s3) # board = $s5
```
Se o valor da casa escolhida for *-2*, ela é vazia, então a função **countAdjacentBoms** é chamada passando as coordenadas da casa atual como parâmetro, então o valor retornado é escrito em **$s3**
```Assembly
li $t2, 0
beq $s5, $t2, if_3 # if($s5 == 0) revealAdjacentBombs
j return1
    
if_3:
jal revealNeighboringCells

return1:
li $v0, 1 # return 1
end:
restore_context
jr      $ra5
```
E se o valor retornado por **countAdjacentBombs** for *0*, a função **revealNeighboringCells** é chamada para revelar a área em volta. Mais abaixo temos a linha para retornar *1*, dando continuidade ao jogo, e o fim da função.
### **Função equivalente em C**
```C
int play(int board[][SIZE], int row, int column) {
        if (board[row][column] == -1) {
            return 0;
        }
        if (board[row][column] == -2) {
            int x = countAdjacentBombs(board, row, column);
            board[row][column] = x;
            if (!x)
                revealAdjacentCells(board, row, column);
        }
        return 1;
    }
```
___
## **Função "checkVictory"**
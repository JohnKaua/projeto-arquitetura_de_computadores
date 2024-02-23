# Relatório - Projeto Campo Minado
Neste projeto, recebemos um código do jogo *Campo Minado* na linguagem C e um código equivalente em Assembly MIPS incompleto, nosso objetivo foi completar as seguintes funções:
* play: verifica se a casa jogada é bomba ou não e toma as ações apropriadas
* checkVictory: verifica se todas as casas vazias já foram jogadas e então dá a mensagem de vitória
* countAdjacentBombs: conta quantas bombas estão adjacentes a casa jogada
* revealNeighboringCells: revela ao redor de casas que não têm nenhuma bomba adjacente
___
## **Função "play"**
```MIPS
li $v0, 1 # valor de $v0 = 1
move $s1, $a0 # $s1 = linha
move $s2, $a1 # $s2 = coluna
move $s0, $a2 # $s0 = board
```
**$v0** recebe por padrão o valor 1 e movemos as cordenadas e endereço do board para registradores **$s**

```MIPS
sll	$t0, $s1, 5
sll	$t1, $s2, 2
add	$t0, $t0, $t1
add	$s3, $t0, $s0 # $s3 = board[row][column] (endereço)
lw $s4, 0($s3) # $s4 = valor de $s3
```
**$s3** recebe o endereço da casa escolhida pelo jogador e **$s4** receber o valor
```MIPS
li $t2, -1
beq $s4, $t2, if_1 # if(board[row][column] == -1)

li $t2, -2
beq $s4, $t2, if_2 # if(board[row][column] == -2)
j return1
```
São feitas as verificações em relação a casa escolhida pelo jogador, se a casa está livre ou se a casa era uma bomba
```MIPS
if_1:
li $v0, 0 # return 0, game over
j end
```
Se o valor da casa escolhida for *-1*, ela é uma bomba, a função retorna 0 e o jogo acaba como derrota
```MIPS
if_2:
move $a0, $s1
move $a1, $s2
move $a2, $s0
jal countAdjacentBombs
move $s5, $v0 # $s5 = countAdjacentBombs
sw $s5, 0($s3) # board = $s5
```
Se o valor da casa escolhida for *-2*, ela é vazia, então a função **countAdjacentBoms** é chamada passando as coordenadas da casa atual como parâmetro, então o valor retornado é escrito em **$s3**
```MIPS
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
```MIPS
li   $s1, 0 #count
li   $s3, 0 # i = 0
```
Declara variável count e i nos registradores **$s1** e **$s3**, respectivamente


```MIPS
begin_for_i_cv:
li   $t1, SIZE
bge  $s3, $t1, end_for_i_cv
li   $s2, 0 # j = 0
```
Declara o começo da função "begin_for_i_cv", que faz a iteração das linhas do tabuleiro. Carrega o valor de SIZE em **$t1**, logo após, verifica se o valor de **$s3** é maior ou igual que **$t1**. Caso seja, pula para "end_for_i_cv", que acaba a iteração do i. Passando pela verificação, declara/reseta o valor da coluna no registrador **$s2**.

```MIPS
bge  $s2, $t1, end_for_j_cv
sll	 $t4, $s3, 5
sll	 $t5, $s2, 2
add	 $t4, $t4, $t5
add	 $t4, $t4, $s0
lw   $s5, 0($t4) # $s5 = board[i][j]
```
bge verifica se o valor da coluna ultrapassa ou iguala 8, e, caso aconteça, o código pula para o fim da iteração do j em "end_for_j_cv". Após isso, **$t4** recebe o endereço da casa atual que está sendo verificada, e **$s5** recebe o valor da casa.
```MIPS
bge $s5,$zero, if_func 
addi $s2, $s2, 1
j begin_for_j_cv
```
Caso o valor da casa seja igual ou maior que zero, o código pula para o marcador if_func. Caso o contrário, adiciona mais um ao valor da coluna atual e recomeça a iteração do J.
```MIPS
if_func:
addi $s1, $s1, 1
addi $s2, $s2, 1
j begin_for_j_cv
```
Ao entrar no bloco "if_func" adiciona 1 ao contador e ao valor da coluna, e pula de volta à iteração "begin_for_j_cv".
```MIPS
end_for_j_cv:
addi $s3, $s3, 1
j begin_for_i_cv
```
Ao finalizar a iteração da coluna, adiciona 1 ao valor da linha e recomeça a iteração da linha.
```MIPS
end_for_i_cv:
mul $t5, $t1, $t1
sub $t5, $t5, BOMB_COUNT
blt $s1, $t5, return_0
li $v0, 1
j return_1
```
A finalizar a iteração da linha, subtrai SIZE ao  quadrado (**$t5**) menos a quantidade de bombas e, caso o contador seja menor que essa conta, pula para o código que retorna zero. Caso contrário, **$v0** recebe 1 e o código pula para retornar 1.
```MIPS
return_0:
li $v0, 0

return_1:
restore_context
jr $ra
```
Caso o código pule para "return_0", **$v0** recebe zero e assim termina restaurando e retornando 0. Caso o código pule para "return_1", **$v0** já será 1 e só retornará o valor de **$v0**.


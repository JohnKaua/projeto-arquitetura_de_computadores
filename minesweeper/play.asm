.include "macros.asm"

.globl play

play:
    save_context
    slt 
    restore_context
    jr $ra
.section .text.entry
.global _start
.extern main
.extern _stack_top
.extern _etext          # LMA of the start of .data
.extern _sdata          # VMA of the start of .data
.extern _edata          # VMA of the end of .data
.extern _sbss           # VMA of the start of .bss
.extern _ebss           # VMA of the end of .bss

_start:
    # initialize sp
    lui sp, %hi(_stack_top)
    addi sp, sp, %lo(_stack_top)

    la a0, _etext
    la a1, _sdata
    la a2, _edata

    # copy .data to its VMA
copy_data:
    beq a1, a2, copy_data_end
    lw t0, 0(a0)
    sw t0, 0(a1)
    addi a0, a0, 4
    addi a1, a1, 4
    j copy_data
copy_data_end:

    la a0, _sbss
    la a1, _ebss
    # clear .bss
clear_bss:
    beq a0, a1, clear_bss_end
    sw zero, 0(a0)
    addi a0, a0, 4
clear_bss_end:

    call main
_hang:
    j _hang

.section .text.entry
.global _start

.extern main

.extern _etext          # LMA of the start of .data
.extern _sdata          # VMA of the start of .data
.extern _edata          # VMA of the end of .data
.extern _sbss           # VMA of the start of .bss
.extern _ebss           # VMA of the end of .bss

.extern _user_stack_top
.extern _trap_stack_top
.extern m_trap
.extern trapframe
.extern m_trap_handler

_start:
    # set up user stack top
    la sp, _user_stack_top

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

    # point mtvec to m_trap in trap.s
    la t0, m_trap
    csrw mtvec, t0

    # point mscratch to trapframe in trap_handler.c
    la t0, trapframe
    csrw mscratch, t0

    # save trap stack top in trapframe
    la t1, _trap_stack_top
    sw t1, 0(t0)

    # save trap handler address in trapframe
    la t1, m_trap_handler
    sw t1, 4(t0)

    # enable global interrupt
    li t0, 8
    csrrs zero, mstatus, t0

    # go to main function
    call main
_hang:
    j _hang

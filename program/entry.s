.section .text.entry
.global _start

_start:
    call main
_hang:
    j _hang

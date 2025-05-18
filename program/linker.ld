ENTRY(_start)

__USER_STACK_SIZE = 0x1000;
__TRAP_STACK_SIZE = 0x1000;

MEMORY
{
    MEM_TEXT (rx)   : ORIGIN = 0x00000200, LENGTH = 0x00008E00
    MEM_DATA (rw)   : ORIGIN = 0x00009000, LENGTH = 0x00003000 - __USER_STACK_SIZE - __TRAP_STACK_SIZE
}

PROVIDE(_trap_stack_top = ORIGIN(MEM_DATA) + 0x3000);          /* Top of the stack */
PROVIDE(_user_stack_top = ORIGIN(MEM_DATA) + 0x3000 - __TRAP_STACK_SIZE);

SECTIONS
{
    .text : {
        /* Place section .text.entry (entry.s) at the start, before .text */
        *(.text.entry)
        *(.text .text.*)
        *(.rodata .srodata)
        . = ALIGN(4);
        _etext = .;
    } > MEM_TEXT

    .data : AT ( _etext ) {
        . = ALIGN(4);
        _sdata = .;
        *(.sdata .data .data*)
        . = ALIGN(4);
        _edata = .;
    } > MEM_DATA

    .bss (NOLOAD) : {
        . = ALIGN(4);
        _sbss = .;
        *(.bss .bss*)
        . = ALIGN(4);
        _ebss = .;
    } > MEM_DATA

}
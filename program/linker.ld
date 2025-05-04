ENTRY(_start)

MEMORY
{
    MEM_TEXT (rx)   : ORIGIN = 0x00000200, LENGTH = 0x00008E00
    MEM_DATA (rw)   : ORIGIN = 0x00009000, LENGTH = 0x00003000
}

PROVIDE(_stack_top = ORIGIN(MEM_DATA) + LENGTH(MEM_DATA));          /* Top of the stack */

SECTIONS
{
    . = ORIGIN(MEM_TEXT);
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
        *(.data .data*)
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
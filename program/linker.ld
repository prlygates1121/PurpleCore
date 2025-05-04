ENTRY(_start)

MEMORY
{
    MEM_TEXT (rx)   : ORIGIN = 0x00000200, LENGTH = 0x00009E00
    MEM_DATA (rw)   : ORIGIN = 0x0000A000, LENGTH = 0x00002000
    MEM_IO_RO (r)   : ORIGIN = 0x80000000, LENGTH = 0x00200000
    MEM_TO_RW (rw)  : ORIGIN = 0x80200000, LENGTH = 0x00400000
}

PROVIDE(_stack_top = ORIGIN(MEM_DATA) + LENGTH(MEM_DATA));          /* Top of the stack */

SECTIONS
{
    . = ORIGIN(MEM_TEXT);
    .text : {
        KEEP(*(.text.entry))
        *(.text)            /* All .text sections (code) */
        . = ALIGN(4);       /* Align to 4-byte boundary */
    } > MEM_TEXT

    . = ORIGIN(MEM_TEXT) + LENGTH(MEM_TEXT);
    .data : AT ( ADDR(.text) + SIZEOF(.text) ) {
        . = ALIGN(4);
        *(.data)           /* All .data sections */
        . = ALIGN(4);
    } > MEM_DATA

}
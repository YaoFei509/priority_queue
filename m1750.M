OUTPUT_FORMAT("coff-m1750")
OUTPUT_ARCH(m1750a)
SEARCH_DIR(/opt/m1750-ada/m1750-coff/lib);
STARTUP(art0.o)
ENTRY(start)
/*
 * Set _STACK_SIZE to the size in bytes of the main stack. The main stack
 * is used by the function 'main' and any other functions it calls. The
 * minimum size is the size is 2 bytes (assuming trivial main and no
 * interrupts). Subprograms that require a stack frame use >= 4 bytes.
 */
_STACK_SIZE = 16K;
/*
 * The interrupt stack is used by asynchronous stack-switching interrupt
 * handlers and anything that can interrupt such a handler. The minimum
 * size, assuming all 16 levels can interrupt, is 21 words per level i.e.
 * 21 * 15 = 315. The size is application dependent.  See the file
 * /opt/<product>/m1750/include/intrrpt.h.
 */
_ISTACK_SIZE = 4K;
/*
 * Set _PROM_SIZE to the size of the PROM in 8-bit bytes. If you have no
 * PROM then use the value zero. 
 */
_PROM_SIZE = 64K;
/*
 * Set _RAM_SIZE to the size of the RAM in 8-bit bytes. 
 */
_RAM_SIZE = 48K;     /* 48K  e000 for 1553, f000 for data buffer */
/*
 * Set _RAM_START to the address of the first location in RAM. 
 */
_RAM_START = 0x00010000;
/*
 * Set _PROM_START to the address of the first location in PROM. 
 */
_PROM_START = 0x00000000;
/*
 * This is the default memory layout. You may change this as necessary by
 * editing the SECTIONS statements that follow:
 *
 *             +--------------------+
 * 0x00000000  | .init              |  Entry point and
 *             |        *(.init)    |  interrupt vectors and
 *             |                    |  startup code
 *             +--------------------+
 *             +--------------------+
 *             | .text              |
 *             |        _stext      |
 *             |        *(.text)    |  Program instructions for
 *             |        _etext      |  address state 0
 *             |        _endtext    |
 *             +--------------------+
 *             +--------------------+
 *             | .rdata             |
 *             |        _srdata     |
 *             |        *(.rdata)   |  Read only data sections
 *             |        -erdata     |
 *             | .idata             |
 *             |        _sidata     |
 *             |        *(.data)    |  Data sections initial values
 *             |        -eidata     |
 *             +--------------------+
 *             +--------------------+
 * 0x00010000  | .data              |
 *             |        _sdata      |
 *             |        *(.data)    |  Initialized data sections
 *             |        _edata      |
 *             +--------------------+
 *             | .bss               |
 *             |        __bss_start |  Start of bss, cleared by crt0
 *             |        *(.bss)     |  Unitialized data sections
 *             +--------------------+
 *             |        _end        |  Start of heap, used by sbrk()
 *             |        _sheap      |  The heap grows upward (down
 *             |    heap space      |  the page) from _sheap. 
 *             /                    /
 *             /                    /
 * 0x00018ffe  |        _eheap      |
 *             +--------------------+
 * 0x00019000  | main stack         |
 *             |        _sstack     | The stack grows downward, from
 *             |   (8K)             | _estack.
 *             |                    | 
 * 0x0001affe  |        _estack     |
 *             +--------------------+
 * 0x0001b000  | interrupt stack    |
 *             |        _sistack    |
 *             |   (4K)             | The interrupt stack grows downward
 *             |                    | from _eistack.
 * 0x0001bffe  |        _eistack    |
 *             +--------------------+
 * 0x0001fffe  +--------------------+
 *
 */
_RAM_END = _RAM_START + _RAM_SIZE;
/*
 * start and end of interrupt stack
 */
_eistack = _RAM_END - 2;
_sistack = _RAM_END - _ISTACK_SIZE;
/*
 * Start and end of main stack
 */
_estack = _sistack - 2;
_sstack = _sistack - _STACK_SIZE;
/*
 * End of heap
 */
_eheap = _sstack - 2;
SECTIONS
{
  .init 0x00000000 : {
    *(.init)
  }

  .ivec 0x00000040 : {
    *(.ivec)
  }

  .text 0x00000100 : {
     _stext  =  .;
    *(.text0)
    *(.text)
     _etext  =  .;
  } 

  .rdata : {
     . = ALIGN(2);
     _srdata  =  .;
    *(.rdata)
     __CTOR_LIST__ = .;
     LONG((__CTOR_END__ - __CTOR_LIST__) / 4 - 2)
     *(.ctors)
     LONG(0)
     __CTOR_END__ = .;
     __DTOR_LIST__ = .;
     LONG((__DTOR_END__ - __DTOR_LIST__) / 4 - 2)
     *(.dtors)
     LONG(0)
     __DTOR_END__ = .;
     _erdata  =  .;
     . = ALIGN(2);
     _sidata  =  .;
  }
  .data 0x00010000 : AT (_sidata) {
     . = ALIGN(2);
     _sdata  =  .;
    *(.data)
     . = ALIGN(2);
     _edata  =  .;
  }
  .bss : { 					
     . = ALIGN(2);
     __bss_start = .;
    *(.bss)
    *(COMMON)
     _end = .;
     _sheap = .;
  }


  .stab  0 (NOLOAD) : {
    [ .stab ]
  }
  .stabstr  0 (NOLOAD) : {
    [ .stabstr ]
  }
}

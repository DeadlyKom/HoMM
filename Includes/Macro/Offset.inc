
                ifndef _MACRO_OFFSET_
                define _MACRO_OFFSET_
OFFSET          macro Offset?
                DW Offset? - $-1
                endm

                endif ; ~_MACRO_OFFSET_

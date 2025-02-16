
                ifndef _ENTRY_POINT_INCLUDE_
                define _ENTRY_POINT_INCLUDE_

                module EntryPoint
                DISP Adr.EntryPoint
Begin           EQU $
                include "EntryPoint.asm"                                        ; первый
                include "Loop.asm"                                              ; второй
                include "Swap.asm"

                display " - Entry point:\t\t\t\t\t\t\t= busy [ ", /D, $-Begin, " byte(s) ]"

                ENT
                endmodule

                endif ; ~_ENTRY_POINT_INCLUDE_

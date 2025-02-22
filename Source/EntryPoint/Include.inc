
                ifndef _ENTRY_POINT_INCLUDE_
                define _ENTRY_POINT_INCLUDE_

                module EntryPoint
                DISP Adr.EntryPoint
Begin           EQU $
                include "EntryPoint.asm"                                        ; первый
                include "Loop.asm"                                              ; второй
                include "Swap.asm"
Size            EQU $-Begin
                display " - Entry point:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " byte(s)  ]"
                ENT
                endmodule

                endif ; ~_ENTRY_POINT_INCLUDE_


                ifndef _TICK_OBJECT_INCLUDE_
                define _TICK_OBJECT_INCLUDE_

                module Object
Begin           EQU $
                include "Tick_.asm"
                include "Tick_Hero.asm"

                display " - Tick object:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_TICK_OBJECT_INCLUDE_

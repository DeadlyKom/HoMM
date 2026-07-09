
                ifndef _TICK_OBJECT_INCLUDE_
                define _TICK_OBJECT_INCLUDE_

                module Object
Begin           EQU $
                include "Tick_Character.asm"
                include "Tick_CharacterAI.asm"

                display " - Tick object:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_TICK_OBJECT_INCLUDE_

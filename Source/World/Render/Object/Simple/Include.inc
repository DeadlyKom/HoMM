
                ifndef _WORLD_RENDER_OBJECT_SIMPLE_INCLUDE_
                define _WORLD_RENDER_OBJECT_SIMPLE_INCLUDE_

                module Simple
Begin           EQU $
                include "Draw.asm"

                display " - Draw simple object:\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_WORLD_RENDER_OBJECT_SIMPLE_INCLUDE_

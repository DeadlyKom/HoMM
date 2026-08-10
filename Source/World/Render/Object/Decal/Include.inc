
                ifndef _WORLD_RENDER_OBJECT_DECAL_INCLUDE_
                define _WORLD_RENDER_OBJECT_DECAL_INCLUDE_

                module Decal
Begin           EQU $
                include "Draw.asm"

                display " - Draw Decal object:\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_WORLD_RENDER_OBJECT_DECAL_INCLUDE_

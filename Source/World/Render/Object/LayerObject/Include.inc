
                ifndef _WORLD_RENDER_LAYER_OBJECT_INCLUDE_
                define _WORLD_RENDER_LAYER_OBJECT_INCLUDE_

                module LayerObject
Begin           EQU $
                include "AlignToAttr.asm"

                display " - Render layer object:\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_WORLD_RENDER_LAYER_OBJECT_INCLUDE_

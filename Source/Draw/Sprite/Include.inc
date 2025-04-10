
                ifndef _DRAW_SPRITE_INCLUDE_
                define _DRAW_SPRITE_INCLUDE_

                module Sprite

                include "DrawClipped.asm"
                include "Draw_OR_XOR.asm"
                include "Draw_LD_ATTR.asm"
                include "Draw_OR_XOR_Save.asm"
                include "Draw_OR_XOR_ATTR.asm"
                include "RestoreBackground.asm"
                include "Functions/Include.inc"

                endmodule

                endif ; ~ _DRAW_SPRITE_INCLUDE_

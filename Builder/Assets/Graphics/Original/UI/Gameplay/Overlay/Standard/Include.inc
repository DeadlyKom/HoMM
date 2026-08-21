
                ifndef _GRAPHICS_UI_GAMEPLAY_OVERLAY_STANDARD_INCLUDE_
                define _GRAPHICS_UI_GAMEPLAY_OVERLAY_STANDARD_INCLUDE_

                module Standard
SpriteInfo      ; -----------------------------------------
.Ox             EQU -7
.Oy             EQU -24
                SPRITE 19, 31,  6+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._0
                SPRITE 19, 31,  6+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._1
                SPRITE 19, 31,  6+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._2
                SPRITE 19, 31,  6+SpriteInfo.Ox,  0+SpriteInfo.Oy, OR_XOR,  0, Sprite._3
                ; -----------------------------------------
Sprite:
._0             incbin "standard_0.bin"
._1             incbin "standard_1.bin"
._2             incbin "standard_2.bin"
._3             incbin "standard_3.bin"

                endmodule

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_OVERLAY_STANDARD_INCLUDE_


                ifndef _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_PAUSE_
                define _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_PAUSE_

                module Pause
SpriteInfo:     SPRITE 16, 32,  0,  0, OR_XOR_ATTR,  0, Sprite.pause_4
                SPRITE 16, 32,  0,  0, OR_XOR_ATTR,  0, Sprite.pause_3
                SPRITE 16, 24,  0,  0, OR_XOR_ATTR,  0, Sprite.pause_2
                SPRITE 16, 16,  0,  0, OR_XOR_ATTR,  0, Sprite.pause_1
                SPRITE 16,  8,  0,  0, OR_XOR_ATTR,  0, Sprite.pause_0
.Num            EQU ($-SpriteInfo) / FSprite
Sprite:
.pause_0        incbin "pause_0.bin"
.pause_1        incbin "pause_1.bin"
.pause_2        incbin "pause_2.bin"
.pause_3        incbin "pause_3.bin"
.pause_4        incbin "pause_4.bin"
                endmodule

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_PAUSE_

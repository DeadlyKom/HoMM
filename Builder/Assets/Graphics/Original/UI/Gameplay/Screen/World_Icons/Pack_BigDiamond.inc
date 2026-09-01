
                ifndef _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_BIG_DIAMOND_
                define _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_BIG_DIAMOND_

                module BigDiamond
                ORG #0000
Begin:          EQU $
                DB Graph.Num
Graph:          EQU $
                SPRITE_BLOCK  16,   8, 216, 104, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._0
                SPRITE_BLOCK  32,   8, 208, 112, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._1
                SPRITE_BLOCK  16,   8, 200, 120, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._21
                SPRITE_BLOCK  16,   8, 232, 120, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._22
                SPRITE_BLOCK  16,   8, 192, 128, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._31
                SPRITE_BLOCK  16,   8, 240, 128, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._32
                SPRITE_BLOCK  16,   8, 200, 136, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._41
                SPRITE_BLOCK  16,   8, 232, 136, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._42
                SPRITE_BLOCK  32,   8, 208, 144, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._5
                SPRITE_BLOCK  16,   8, 216, 152, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite._6
Graph.Num:      EQU ($-Graph) / FSpriteBlock
Sprite:
._0             incbin "big_diamond_0.bin"
._1             incbin "big_diamond_1.bin"
._21            incbin "big_diamond_2.1.bin"
._22            incbin "big_diamond_2.2.bin"
._31            incbin "big_diamond_3.1.bin"
._32            incbin "big_diamond_3.2.bin"
._41            incbin "big_diamond_4.1.bin"
._42            incbin "big_diamond_4.2.bin"
._5             incbin "big_diamond_5.bin"
._6             incbin "big_diamond_6.bin"
                SAVE_PACK "Builder/Assets/Graphics/Compressed/UI/GameWorld_BigDiamond.pack"
                endmodule

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_BIG_DIAMOND_


                ifndef _GRAPHICS_UI_GAMEPLAY_OVERLAY_FACE_OF_HEROES_SMALL_INCLUDE_
                define _GRAPHICS_UI_GAMEPLAY_OVERLAY_FACE_OF_HEROES_SMALL_INCLUDE_

                module Small
SpriteInfo      ; -----------------------------------------
                SPRITE 24, 24,  0,  0, LD_ATTR, 0, Sprite._0
                SPRITE 24, 24,  0,  0, LD_ATTR, 0, Sprite._1
                SPRITE 24, 24,  0,  0, LD_ATTR, 0, Sprite._2
                SPRITE 24, 24,  0,  0, LD_ATTR, 0, Sprite._3
                SPRITE 24, 24,  0,  0, LD_ATTR, 0, Sprite._4
                SPRITE 24, 24,  0,  0, LD_ATTR, 0, Sprite._5
                SPRITE 24, 24,  0,  0, LD_ATTR, 0, Sprite._6
                SPRITE 24, 24,  0,  0, LD_ATTR, 0, Sprite._7
                ; -----------------------------------------
Sprite:         ;
._0             incbin "small_hero_0.bin"
._1             incbin "small_hero_1.bin"
._2             incbin "small_hero_2.bin"
._3             incbin "small_hero_3.bin"
._4             incbin "small_hero_4.bin"
._5             incbin "small_hero_5.bin"
._6             incbin "small_hero_6.bin"
._7             incbin "small_hero_7.bin"
                endmodule

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_OVERLAY_FACE_OF_HEROES_SMALL_INCLUDE_

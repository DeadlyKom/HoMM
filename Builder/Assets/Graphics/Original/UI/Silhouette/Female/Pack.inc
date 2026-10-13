
                ifndef _GRAPHICS_UI_SILHOUETTE_FEMALE_PAPER_DOLL_PACK_
                define _GRAPHICS_UI_SILHOUETTE_FEMALE_PAPER_DOLL_PACK_

                DB Graph.Num
                ; относительные координаты
Graph:          EQU $
                SPRITE_BLOCK   8,  40,  24,   8, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_0
                SPRITE_BLOCK   8,  40,  32,   0, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_1
                SPRITE_BLOCK   8,  40,  40,   0, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_2
                SPRITE_BLOCK   8,  32,  48,   8, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_3
                SPRITE_BLOCK   8,  96,  56,  32, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_4
                SPRITE_BLOCK   8,  40,  64,  48, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_5
                SPRITE_BLOCK   8,  16,  48,  48, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_17
                SPRITE_BLOCK   8,  16,  40,  56, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_18
                SPRITE_BLOCK   8,  24,  48,  72, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_19
                SPRITE_BLOCK   8,  48,  64, 128, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_6
                SPRITE_BLOCK   8,  40,  56, 136, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_7
                SPRITE_BLOCK   8,  32,  48, 112, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_8
                SPRITE_BLOCK   8,  24,  40,  96, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_9
                SPRITE_BLOCK   8,  56,  32,  88, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_10
                SPRITE_BLOCK   8,  16,  24, 112, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_11
                SPRITE_BLOCK   8,  24,  24, 136, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_11_
                SPRITE_BLOCK  24,   8,   8, 160, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_12
                SPRITE_BLOCK   8, 120,  16,  40, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_13
                SPRITE_BLOCK   8,  24,  24,  64, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_14
                SPRITE_BLOCK   8,  24,   8,  64, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_15
                SPRITE_BLOCK   8,  16,   0,  72, SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Body_16
Graph.Num:      EQU ($-Graph) / FSpriteBlock
Sprite:
.Body_0         incbin "body_0.bin"
.Body_1         incbin "body_1.bin"
.Body_2         incbin "body_2.bin"
.Body_3         incbin "body_3.bin"
.Body_4         incbin "body_4.bin"
.Body_5         incbin "body_5.bin"
.Body_6         incbin "body_6.bin"
.Body_7         incbin "body_7.bin"
.Body_8         incbin "body_8.bin"
.Body_9         incbin "body_9.bin"
.Body_10        incbin "body_10.bin"
.Body_11        incbin "body_11.bin"
.Body_11_       incbin "body_11_.bin"
.Body_12        incbin "body_12.bin"
.Body_13        incbin "body_13.bin"
.Body_14        incbin "body_14.bin"
.Body_15        incbin "body_15.bin"
.Body_16        incbin "body_16.bin"
.Body_17        incbin "body_17.bin"
.Body_18        incbin "body_18.bin"
.Body_19        incbin "body_19.bin"

                endif ; ~ _GRAPHICS_UI_SILHOUETTE_FEMALE_PAPER_DOLL_PACK_

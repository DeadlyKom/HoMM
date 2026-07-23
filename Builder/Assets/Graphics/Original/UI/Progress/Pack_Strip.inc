
                ifndef _GRAPHICS_UI_PROGRESS_STRIP_PACK_
                define _GRAPHICS_UI_PROGRESS_STRIP_PACK_

                module Strip
                ORG #0000
Begin:          EQU $
                DW Progress.x1 -$-1
                DW Progress.x2 -$-1

                ; ----------------------------------------
Progress.x1     DB Progress.N.x1                                                ; 3.8%
Progress.B.x1:  EQU $
                SPRITE_BLOCK   8,  24,  16, 168, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_OR_XOR_ATTR, Sprite.progress_be
                SPRITE_BLOCK   8,  24,  24, 168, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_OR_XOR_ATTR, Sprite.progress_1
                SPRITE_BLOCK   8,  24,  32, 168, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_OR_XOR_ATTR | SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL, Sprite.progress_be
Progress.N.x1:  EQU ($-Progress.B.x1) / FSpriteBlock

                ; ----------------------------------------
Progress.x2     DB Progress.N.x2                                                ; 7.7%
Progress.B.x2:  EQU $
                SPRITE_BLOCK   8,  24,  24, 168, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_OR_XOR_ATTR, Sprite.progress_2
                SPRITE_BLOCK   8,  24,  32, 168, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_OR_XOR_ATTR, Sprite.progress_4
                SPRITE_BLOCK   8,  24,  40, 168, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_OR_XOR_ATTR | SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL, Sprite.progress_be
Progress.N.x2:  EQU ($-Progress.B.x2) / FSpriteBlock
Sprite:
.progress_be    incbin "progress_be.bin"
.progress_1     incbin "progress_1.bin"
.progress_2     incbin "progress_2.bin"
.progress_3     incbin "progress_3.bin"
.progress_4     incbin "progress_4.bin"

                SAVE_PACK "Builder/Assets/Graphics/Compressed/Progress/Strip.pack"
                endmodule

                endif ; ~ _GRAPHICS_UI_PROGRESS_STRIP_PACK_

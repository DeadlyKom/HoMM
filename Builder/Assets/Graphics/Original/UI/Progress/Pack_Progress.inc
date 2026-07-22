
                ifndef _GRAPHICS_UI_PROGRESS_PACK_
                define _GRAPHICS_UI_PROGRESS_PACK_

                module Progress
                ORG #0000
Begin:          EQU $
Ornament:       DB Ornament.Num
Ornament.Block: EQU $
                SPRITE_BLOCK  16,  24,   8, 168, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Ornament
                SPRITE_BLOCK  16,  24, 232, 168, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Sprite.Ornament
Ornament.Num:   EQU ($-Ornament.Block) / FSpriteBlock
Sprite:
.Ornament       incbin "progress.bin"

                SAVE_PACK "Builder/Assets/Graphics/Compressed/Progress/Ornament.pack"
                endmodule

                endif ; ~ _GRAPHICS_UI_PROGRESS_PACK_

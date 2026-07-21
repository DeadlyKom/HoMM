
                ifndef _GRAPHICS_UI_PROGRESS_STAGES_PACK_FRAME_
                define _GRAPHICS_UI_PROGRESS_STAGES_PACK_FRAME_

                module Stages
                ORG #0000

                DB Graph.Num
Graph:          EQU $
                SPRITE_BLOCK 256, 104,   0,   0, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Stage.Prologue
Graph.Num:      EQU ($-Graph) / FSpriteBlock
Stage:
.Prologue       incbin "prologue.bin"

                savebin "Builder/Assets/Graphics/Original/UI/Progress_Stages.pack", 0, $
                endmodule

                endif ; ~ _GRAPHICS_UI_PROGRESS_STAGES_PACK_FRAME_

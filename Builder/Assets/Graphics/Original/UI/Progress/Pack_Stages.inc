
                ifndef _GRAPHICS_UI_PROGRESS_STAGES_PACK_
                define _GRAPHICS_UI_PROGRESS_STAGES_PACK_

                module Stages
                ORG #0000
Begin:          EQU $
                DB Stage.Num
                DW Prologue                                                     ; нулевой идентификатор всегда общий
                DW Act_I
HeaderSize:     EQU $-Begin
                ; ----------------------------------------
                ; пролог
                ; ----------------------------------------
Prologue:       DB Prologue.Num
Prologue.Block: EQU $
                SPRITE_BLOCK 256, 104,   0,   8, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Stage.Prologue
Prologue.Num:   EQU ($-Prologue.Block) / FSpriteBlock

                ; ----------------------------------------
                ; Акт I
                ; ----------------------------------------
Act_I:          DB Act_I.Num
Act_I.Block:    EQU $
                SPRITE_BLOCK 256, 104,   0,   0, SPRITE_NOT_CLIPPING_POSITION | SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR, Stage.Act_I
Act_I.Num:      EQU ($-Act_I.Block) / FSpriteBlock
                ; ----------------------------------------
Stage:
.Prologue       incbin "prologue.bin"
.Act_I          incbin "prologue.bin"                                           ; ToDo: временно
.Num:           EQU 2   ; устанавливать вручную
                ; ----------------------------------------
                COMPRESSED_ASSET \
                "Builder/Assets/Graphics/Compressed/Progress/Stages.pack", \
                "Builder/Assets/Graphics/Compressed/Progress/Stages.pack.ar"
                endmodule

                endif ; ~ _GRAPHICS_UI_PROGRESS_STAGES_PACK_

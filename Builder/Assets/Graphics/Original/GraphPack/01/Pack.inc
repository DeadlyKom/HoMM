
                ifndef _GRAPHICS_PACK_01_
                define _GRAPHICS_PACK_01_
SPRITE_ID_COUNTER   defl 0                                                      ; счётчик спрайтов
MAKE_ID_SPRITE  macro Label?, Width?, Height?, SOx?, SOy?, Flags?, ExtraFlags?, Offset?
@Label?         EQU SPRITE_ID_COUNTER

                SPRITE Width?, Height?, SOx?, SOy?, Flags?, ExtraFlags?, Offset?
SPRITE_ID_COUNTER = SPRITE_ID_COUNTER + 1
                endm
MAKE_REF_SPRITES macro Label?, SpriteNum?, Offset?
@Label?         EQU SPRITE_ID_COUNTER

                SPRITE_LINKER SpriteNum?, Offset?
SPRITE_ID_COUNTER = SPRITE_ID_COUNTER + 1
                endm

                ; спрайты графического пакета №01
                MAKE_REF_SPRITES                                                \
                /*телепорт*/            SPRITE_ID_TELEPORT,                     \
                /*количество спрайтов*/ Teleport.Sprites.Num,                   \
                /*смещение*/            Teleport.Sprites

                include "Builder/Assets/Graphics/Original/Environment/Teleport/Include.inc"

                endif ; ~ _GRAPHICS_PACK_01_

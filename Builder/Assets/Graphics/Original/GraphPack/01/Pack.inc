
                ifndef _GRAPHICS_PACK_01_
                define _GRAPHICS_PACK_01_
SPRITE_ID_COUNTER   defl 0                                                      ; счётчик спрайтов
SPRITE_LINKER   macro Width?, Height?, SOx?, SOy?, Flags?, Offset?
                FSprite {{Width?, Height?, SOx?, SOy?}, 0, Flags?, Offset?}
                endm
MAKE_ID_SPRITE  macro Label?, Width?, Height?, SOx?, SOy?, Flags?, Offset?
@Label?         EQU SPRITE_ID_COUNTER

                SPRITE_LINKER Width?, Height?, SOx?, SOy?, Flags?, Offset?
SPRITE_ID_COUNTER = SPRITE_ID_COUNTER + 1
                endm

                ; спрайты графического пакета №01
                MAKE_ID_SPRITE                                                  \
                /*телепорт*/    SPRITE_ID_TELEPORT,                             \
                /*Width*/       24,                                             \
                /*Height*/      32,                                             \
                /*SOx*/         0,                                              \
                /*SOy*/         0,                                              \
                /*Flags?*/      OR_XOR_ATTR,                                    \
                /*Offset?*/     Teleport
Teleport:       incbin "Builder/Assets/Graphics/Original/Environment/Teleport/Teleport_0.spr"

                endif ; ~ _GRAPHICS_PACK_01_

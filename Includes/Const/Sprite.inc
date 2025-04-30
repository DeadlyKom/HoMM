
                ifndef _CONST_SPRITE_
                define _CONST_SPRITE_
SPRITE_BUF_MAX  EQU 126                                                         ; максимальное количество спрайтов в буфере SpriteInfoBuffer
SPRITE_TEMP_IDX EQU 127                                                         ; временный индекс спрайта
SPRITE_CUR_IDX  EQU 126                                                         ; временный индекс спрайта спрайта
SPRITE_SIZE     EQU 8                                                           ; размер структуры объекта FSprite

; флаги структуры FSpritesRef
SPRITE_REF_BIT  EQU 0x07                                                        ; флаг, используется в индексе расположения спрайта (буфер SpriteInfoBuffer)
                                                                                ; т.к. SpriteInfoBuffer имеет ограничение 128 спрайтов, старший бит (7) свободен,
                                                                                ; позволяя быстро определить тип структуры
SPRITE_CS_BIT   EQU 0x06                                                        ; флаг, спрайт является композитным

; флаги структуры FSprites
SPR_ATTR_BIT    EQU 0x07                                                        ; флаг, спрайта с атрибутами
SPR_DRAW_BIT    EQU 0x06                                                        ; тип вывода спрайта
SPR_MIRROR_BIT  EQU 0x05                                                        ; флаг, зеркального отображения спрайта по горизонтали

SPRITE_REF      EQU 1 << SPRITE_REF_BIT
SPRITE_CS       EQU 1 << SPRITE_CS_BIT
OR_XOR_SAVE     EQU 0x00 << SPR_MIRROR_BIT
OR_XOR          EQU 0x02 << SPR_MIRROR_BIT
M_OR_XOR        EQU 0x03 << SPR_MIRROR_BIT
LD_ATTR         EQU 0x04 << SPR_MIRROR_BIT
OR_XOR_ATTR     EQU 0x06 << SPR_MIRROR_BIT

                endif ; ~_CONST_SPRITE_

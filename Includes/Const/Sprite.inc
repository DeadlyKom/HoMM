
                ifndef _CONST_SPRITE_
                define _CONST_SPRITE_

SPR_ATTR_BIT    EQU 0x07                                                        ; флаг, спрайта с атрибутами
SPR_DRAW_BIT    EQU 0x06                                                        ; тип вывода спрайта
SPR_MIRROR_BIT  EQU 0x05                                                        ; флаг, зеркального отображения спрайта по горизонтали
SPR_ATTR        EQU 1 << SPR_ATTR_BIT
SPR_LD          EQU 0 << SPR_DRAW_BIT
SPR_OR_XOR      EQU 1 << SPR_DRAW_BIT
SPR_MIRROR      EQU 1 << SPR_MIRROR_BIT

                endif ; ~_CONST_SPRITE_

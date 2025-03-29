
                ifndef _CONST_SPRITE_
                define _CONST_SPRITE_

SPR_ATTR_BIT    EQU 0x07                                                        ; флаг, спрайта с атрибутами
SPR_DRAW_BIT    EQU 0x06                                                        ; тип вывода спрайта
SPR_MIRROR_BIT  EQU 0x05                                                        ; флаг, зеркального отображения спрайта по горизонтали

OR_XOR_SAVE     EQU 0x00 << SPR_MIRROR_BIT
OR_XOR          EQU 0x02 << SPR_MIRROR_BIT
M_OR_XOR        EQU 0x03 << SPR_MIRROR_BIT
LD_ATTR         EQU 0x04 << SPR_MIRROR_BIT
OR_XOR_ATTR     EQU 0x06 << SPR_MIRROR_BIT

                endif ; ~_CONST_SPRITE_

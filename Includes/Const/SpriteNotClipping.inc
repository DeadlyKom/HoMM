
                ifndef _CONST_SPRITE_NOT_CLIPPING_
                define _CONST_SPRITE_NOT_CLIPPING_

; флаги структуры FSpriteBlock
SPRITE_NOT_CLIPPING_LOCATION_BIT            EQU 0x00                            ; флаг, если 0, то поле Location хранит смещение, иначе позицию спрайта в экранных координат
SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL_BIT   EQU 0x01                            ; флаг, зеркального отображения спрайта по горизонтали
SPRITE_NOT_CLIPPING_MIRROR_VERTICAL_BIT     EQU 0x02                            ; флаг, зеркального отображения спрайта по вертикали
SPRITE_NOT_CLIPPING_DRAWING_BIT             EQU 0x03                            ; два бита, методы рисования спрайта

SPRITE_NOT_CLIPPING_LOCATION                EQU 0 << SPRITE_NOT_CLIPPING_LOCATION_BIT
SPRITE_NOT_CLIPPING_POSITION                EQU 1 << SPRITE_NOT_CLIPPING_LOCATION_BIT
SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL       EQU 1 << SPRITE_NOT_CLIPPING_MIRROR_HORIZONTAL_BIT
SPRITE_NOT_CLIPPING_MIRROR_VERTICAL         EQU 1 << SPRITE_NOT_CLIPPING_MIRROR_VERTICAL_BIT
SPRITE_NOT_CLIPPING_DRAWING_LD_ATTR         EQU 0x00 << SPRITE_NOT_CLIPPING_DRAWING_BIT
SPRITE_NOT_CLIPPING_DRAWING_OR_XOR_ATTR     EQU 0x01 << SPRITE_NOT_CLIPPING_DRAWING_BIT

                endif ; ~_CONST_SPRITE_NOT_CLIPPING_

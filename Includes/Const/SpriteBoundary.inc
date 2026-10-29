
                ifndef _CONST_SPRITE_BOUNDARY_
                define _CONST_SPRITE_BOUNDARY_

; -----------------------------------------
;   флаги управления знакоместом Boundary
; -----------------------------------------
SPRITE_BOUNDARY_NEXT_VERTICAL_BIT   EQU 0x00                                    ; флаг, продолжения вывода по вертикали
SPRITE_BOUNDARY_LAST_BIT            EQU 0x01                                    ; флаг, последнего знакоместа спрайта
SPRITE_BOUNDARY_SKIP_ATTR_BIT       EQU 0x02                                    ; флаг, пропуска записи атрибута

SPRITE_BOUNDARY_NEXT_VERTICAL       EQU 1 << SPRITE_BOUNDARY_NEXT_VERTICAL_BIT
SPRITE_BOUNDARY_LAST                EQU 1 << SPRITE_BOUNDARY_LAST_BIT
SPRITE_BOUNDARY_SKIP_ATTR           EQU 1 << SPRITE_BOUNDARY_SKIP_ATTR_BIT

                endif ; ~_CONST_SPRITE_BOUNDARY_

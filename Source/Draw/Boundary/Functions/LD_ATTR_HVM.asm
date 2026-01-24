
                ifndef _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_LOAD_ATTR_HORIZONTAL_VERTICAL_MIRROR_
                define _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_LOAD_ATTR_HORIZONTAL_VERTICAL_MIRROR_
; -----------------------------------------
; отображение двух пиксельных строк знакоместа
; In:
;   SP - адрес спрайта
;   HL - адрес экрана
;   D  - старший адрес таблицы зеркальных байт
;   BC - два байта спрайта
; Out:
; Corrupt:
; Note:
;   отображение производится вверху вниз
; -----------------------------------------
LD_2_LINES_HVM  macro
                LD (HL), C  ; первый байт всегда хранится отзеркаленый (его не трогаем)
                DEC H
                LD E, B     ; второй байт всегда хранится нормальный
                LD A, (DE)  ; зеркалим второй байт
                LD (HL), A
                DEC H
                POP BC      ; чтение двух байт спрайта
                endm
; -----------------------------------------
; отображение двух пиксельных строк знакоместа (завершающий)
; In:
;   SP - адрес спрайта
;   HL - адрес экрана
;   D  - старший адрес таблицы зеркальных байт
;   BC - два байта спрайта
; Out:
; Corrupt:
; Note:
;   отображение производится вверху вниз
; -----------------------------------------
LD_2_LINES_HVM_ macro
                LD (HL), C  ; первый байт всегда хранится отзеркаленый (его не трогаем)
                DEC H
                LD E, B     ; второй байт всегда хранится нормальный
                LD A, (DE)  ; зеркалим второй байт
                LD (HL), A
                POP BC      ; чтение двух байт спрайта
                endm
; -----------------------------------------
; отображение спрайта с атрибутами (горизонтальное отзеркаливание)
; In:
;   SP+0 - указывает на адрес спрайта
;   HL   - адрес экрана
;   BC   - два байта спрайта
; Out:
; Corrupt:
; Note:
; -----------------------------------------
LD_ATTR_HVM:    RESTORE_SCR_ADR
                LD_2_LINES_HVM
                LD_2_LINES_HVM
                LD_2_LINES_HVM
                LD_2_LINES_HVM_
                TO_ATTR_ADR
                PIXEL_UP_DE
                SET_ATTR
                JP (IY)
                
                display " - Draw sprite aligned in boundary 'LD ATTR HVM':\t", /A, LD_ATTR_HVM, "\t= busy [ ", /D, $-LD_ATTR_HVM, " byte(s)  ]"

                endif ; ~ _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_LOAD_ATTR_HORIZONTAL_VERTICAL_MIRROR_

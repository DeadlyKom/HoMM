
                ifndef _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_OR_XOR_ATTR_
                define _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_OR_XOR_ATTR_
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
OR_XOR_LINE     macro
                LD E, C     ; первый байт всегда хранится отзеркаленый
                LD A, (DE)  ; зеркалим первый байт
                OR (HL)     ; чтение байта из экрана
                XOR B       ; спрайт
                LD (HL), A  ; запись байта в экран
                INC H
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
OR_XOR_LINE_    macro
                LD E, C     ; первый байт всегда хранится отзеркаленый
                LD A, (DE)  ; зеркалим первый байт
                OR (HL)     ; чтение байта из экрана
                XOR B       ; спрайт
                LD (HL), A  ; запись байта в экран
                POP BC      ; чтение двух байт спрайта
                endm
; -----------------------------------------
; отображение спрайта с атрибутами
; In:
;   SP+0 - указывает на адрес спрайта
;   HL   - адрес экрана
;   BC   - два байта спрайта
; Out:
; Corrupt:
; Note:
; -----------------------------------------
OR_XOR_ATTR:    RESTORE_SCR_ADR
                OR_XOR_LINE
                OR_XOR_LINE
                OR_XOR_LINE
                OR_XOR_LINE
                OR_XOR_LINE
                OR_XOR_LINE
                OR_XOR_LINE
                OR_XOR_LINE_
                TO_ATTR_ADR
                PIXEL_DOWN_DE
                SET_ATTR
                JP (IY)
                
                display " - Draw sprite aligned in boundary 'OR XOR ATTR':\t", /A, OR_XOR_ATTR, "\t= busy [ ", /D, $-OR_XOR_ATTR, " byte(s)  ]"

                endif ; ~ _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_OR_XOR_ATTR_

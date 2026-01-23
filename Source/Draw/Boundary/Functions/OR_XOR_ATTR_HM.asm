
                ifndef _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_OR_XOR_ATTR_HORIZONTAL_MIRROR_
                define _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_OR_XOR_ATTR_HORIZONTAL_MIRROR_
; -----------------------------------------
; отображение пиксельной строки знакоместа
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
OR_XOR_LINE_HM  macro
                LD E, B     ; второй байт всегда хранится нормальный
                LD A, (DE)  ; зеркалим второй байт
                LD E, A     ; сохранение отзеркаленый спрайт
                LD A, (HL)  ; чтение байта из экрана
                OR C        ; первый байт всегда хранится отзеркаленый (его не трогаем)
                XOR E       ; спрайт (отзеркален)
                LD (HL), A  ; запись байта в экран
                INC H
                POP BC      ; чтение двух байт спрайта
                endm
; -----------------------------------------
; отображение пиксельной строки знакоместа (завершающий)
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
OR_XOR_LINE_HM_ macro
                LD E, B     ; второй байт всегда хранится нормальный
                LD A, (DE)  ; зеркалим второй байт
                LD E, A     ; сохранение отзеркаленый спрайт
                LD A, (HL)  ; чтение байта из экрана
                OR C        ; первый байт всегда хранится отзеркаленый (его не трогаем)
                XOR E       ; спрайт  (отзеркален)
                LD (HL), A  ; запись байта в экран
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
OR_XOR_ATTR_HM: RESTORE_SCR_ADR
                OR_XOR_LINE_HM
                OR_XOR_LINE_HM
                OR_XOR_LINE_HM
                OR_XOR_LINE_HM
                OR_XOR_LINE_HM
                OR_XOR_LINE_HM
                OR_XOR_LINE_HM
                OR_XOR_LINE_HM_
                TO_ATTR_ADR
                PIXEL_DOWN_DE
                SET_ATTR
                JP (IY)
                
                display " - Draw sprite aligned in boundary 'OR XOR ATTR HM':\t", /A, OR_XOR_ATTR_HM, "\t= busy [ ", /D, $-OR_XOR_ATTR_HM, " byte(s)  ]"

                endif ; ~ _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_OR_XOR_ATTR_HORIZONTAL_MIRROR_

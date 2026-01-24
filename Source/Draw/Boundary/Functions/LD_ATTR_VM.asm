
                ifndef _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_LOAD_ATTR_VERTICAL_MIRROR_
                define _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_LOAD_ATTR_VERTICAL_MIRROR_
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
LD_2_LINES_VM   macro
                LD E, C     ; первый байт всегда хранится отзеркаленый
                LD A, (DE)  ; зеркалим первый байт
                LD (HL), A
                DEC H
                LD (HL), B  ; второй байт всегда хранится нормальный
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
LD_2_LINES_VM_  macro
                LD E, C     ; первый байт всегда хранится отзеркаленый
                LD A, (DE)  ; зеркалим первый байт
                LD (HL), A
                DEC H
                LD (HL), B  ; второй байт всегда хранится нормальный
                POP BC      ; чтение двух байт спрайта
                endm
; -----------------------------------------
; отображение спрайта с атрибутами (вертикальное отзеркаливание)
; In:
;   SP+0 - указывает на адрес спрайта
;   HL   - адрес экрана
;   BC   - два байта спрайта
; Out:
; Corrupt:
; Note:
; -----------------------------------------
LD_ATTR_VM:     RESTORE_SCR_ADR
                LD_2_LINES_VM
                LD_2_LINES_VM
                LD_2_LINES_VM
                LD_2_LINES_VM_
                TO_ATTR_ADR
                PIXEL_UP_DE
                SET_ATTR
                JP (IY)

                display " - Draw sprite aligned in boundary 'LD ATTR VM':\t", /A, LD_ATTR_VM, "\t= busy [ ", /D, $-LD_ATTR_VM, " byte(s)  ]"

                endif ; ~ _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_LOAD_ATTR_VERTICAL_MIRROR_

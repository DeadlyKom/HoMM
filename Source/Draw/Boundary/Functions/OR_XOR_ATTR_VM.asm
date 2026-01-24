
                ifndef _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_OR_XOR_ATTR_VERTICAL_MIRROR_
                define _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_OR_XOR_ATTR_VERTICAL_MIRROR_
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
OR_XOR_LINE_VM  macro
                LD E, C     ; первый байт всегда хранится отзеркаленый
                LD A, (DE)  ; зеркалим первый байт
                OR (HL)     ; чтение байта из экрана
                XOR B       ; спрайт
                LD (HL), A  ; запись байта в экран
                DEC H
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
OR_XOR_LINE_VM_ macro
                LD E, C     ; первый байт всегда хранится отзеркаленый
                LD A, (DE)  ; зеркалим первый байт
                OR (HL)     ; чтение байта из экрана
                XOR B       ; спрайт
                LD (HL), A  ; запись байта в экран
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
OR_XOR_ATTR_VM: RESTORE_SCR_ADR
                OR_XOR_LINE_VM
                OR_XOR_LINE_VM
                OR_XOR_LINE_VM
                OR_XOR_LINE_VM
                OR_XOR_LINE_VM
                OR_XOR_LINE_VM
                OR_XOR_LINE_VM
                OR_XOR_LINE_VM_
                TO_ATTR_ADR
                PIXEL_UP_DE
                SET_ATTR
                JP (IY)
                
                display " - Draw sprite aligned in boundary 'OR XOR ATTR VM':\t", /A, OR_XOR_ATTR_VM, "\t= busy [ ", /D, $-OR_XOR_ATTR_VM, " byte(s)  ]"

                endif ; ~ _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_OR_XOR_ATTR_VERTICAL_MIRROR_

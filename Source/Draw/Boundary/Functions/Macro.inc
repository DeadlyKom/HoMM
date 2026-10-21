
                ifndef _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_MACRO_
                define _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_MACRO_
; -----------------------------------------
; восстановление адреса экрана
; In:
;   SP - адрес спрайта
;   HL - адрес знакоместа атрибутов
;   DE - адрес экрана
;   BC - два байта спрайта
; Out:
;   HL - адрес экрана
;   D  - старший адрес таблицы зеркальных байт
; Corrupt:
;   DE
; Note:
;   отображение производится вверху вниз
; -----------------------------------------
RESTORE_SCR_ADR macro
                EX DE, HL
                LD D, HIGH Adr.ByteMirrorTable                                  ; адреса таблицы зеркальных байт/буфера
                endm
; -----------------------------------------
; установка атрибута
; In:
;   SP - адрес спрайта
;   HL - адрес атрибутов
;   DE - адрес экрана
;   BC - два байта спрайта
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SET_ATTR        macro
                LD (HL), C  ; запись байта в экран атрибутов
                LD A, B
                POP BC      ; чтение двух байт спрайта
                endm

                endif ; ~ _DRAW_BOUNDARY_SPRITE_NOT_CLIPPING_MACRO_

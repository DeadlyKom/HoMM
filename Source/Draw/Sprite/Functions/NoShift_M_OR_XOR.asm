
                ifndef _DRAW_SPRITE_FUNCTION_NO_SHIFT_M_OR_XOR_
                define _DRAW_SPRITE_FUNCTION_NO_SHIFT_M_OR_XOR_

                module M_OR_XOR
Begin_NoShift:  EQU $
; -----------------------------------------
;
; In:
;   HL  - адрес экрана (начало строки)
;   DE  - адрес экрана (текущий)
;   B   - количество оставшихся строк в знакоместе
;   C   - количество оставшихся строк рисования
;   H'  - старший адрес таблицы зеркальных байт
;   D'  - старший адрес таблицы сдвига
;   BC' - 2 батйа спрайта (значение маски и спрайта)
;   SP  - адрес спрайта
; Out:
; Corrupt:
; Note:
;   форма хранения спрайта:
;   первый байт всегда отзеркален, что позволяет исключить два раза зеркалить и маску и спрайт
; -----------------------------------------

NoShiftLR:
._OX_XXX_X      POP AF
._OX_XX_X       POP AF
._OX_X_X        POP AF
                JP NoShift._OX_X
._OX_XX_XX      POP AF
._OX_X_XX       POP AF
                JP NoShift._OX_XX
._OX_X_XXX      POP AF
                JP NoShift._OX_XXX
NoShift:
._OX_XXXX       LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска всегда хранится отзеркаленная
                LD L, B     ; спрайт всегда хранится нормальный
                XOR (HL)    ; зеркалим спрайт
                EXX

                LD (DE), A  ; запись байта в экран
                DEC E       ; предыдущее знакоместо

._OX_XXX        LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска всегда хранится отзеркаленная
                LD L, B     ; спрайт всегда хранится нормальный
                XOR (HL)    ; зеркалим спрайт
                EXX

                LD (DE), A  ; запись байта в экран
                DEC E       ; предыдущее знакоместо

._OX_XX         LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска всегда хранится отзеркаленная
                LD L, B     ; спрайт всегда хранится нормальный
                XOR (HL)    ; зеркалим спрайт
                EXX

                LD (DE), A  ; запись байта в экран
                DEC E       ; предыдущее знакоместо

._OX_X          LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                OR C        ; маска всегда хранится отзеркаленная
                LD L, B     ; спрайт всегда хранится нормальный
                XOR (HL)    ; зеркалим спрайт
                EXX

                LD (DE), A  ; запись байта в экран

; NextRow:        ; новая строка
                DEC C
                JP Z, Kernel.Sprite.DrawM_OR_XOR.Exit
                INC D
                DJNZ .NextRow

                LD B, #08
                LD A, L
                ADD A, #20
                LD L, A
                JR C, .NextBoundary
                LD D, H                                                         ; восстановление адреса экрана
                LD E, L
                JP (IY)

.NextBoundary   LD H, D                                                         ; сохранение старший байт адреса экрана
.NextRow        LD E, L                                                         ; восстановление младший байт адреса экрана
                JP (IY)
NoShift.Table:
.OX_8           DW NoShift._OX_X,       NoShift._OX_X                           ;  1.0

                DW NoShiftLR._OX_X_X,   NoShiftLR._OX_X_X                       ; -1.0
.OX_16          DW NoShift._OX_XX,      NoShift._OX_XX                          ;  2.0
                DW NoShift._OX_X,       NoShiftLR._OX_X_X                       ; +1.0

                DW NoShiftLR._OX_XX_X,  NoShiftLR._OX_XX_X                      ; -2.0
                DW NoShiftLR._OX_X_XX,  NoShiftLR._OX_X_XX                      ; -1.0
.OX_24          DW NoShift._OX_XXX,     NoShift._OX_XXX
                DW NoShift._OX_XX,      NoShiftLR._OX_X_XX                      ; +1.0
                DW NoShift._OX_X,       NoShiftLR._OX_XX_X                      ; +2.0

                DW NoShiftLR._OX_XXX_X, NoShiftLR._OX_XXX_X                     ; -3.0
                DW NoShiftLR._OX_XX_XX, NoShiftLR._OX_XX_XX                     ; -2.0
                DW NoShiftLR._OX_X_XXX, NoShiftLR._OX_X_XXX                     ; -1.0
.OX_32          DW NoShift._OX_XXXX,    NoShift._OX_XXXX
                DW NoShift._OX_XXX,     NoShiftLR._OX_X_XXX                     ; +1.0
                DW NoShift._OX_XX,      NoShiftLR._OX_XX_XX                     ; +2.0
                DW NoShift._OX_X,       NoShiftLR._OX_XXX_X                     ; +3.0

                display " - Draw function 'No Shift Mirror OR & XOR':\t\t", /A, Begin_NoShift, "\t= busy [ ", /D, $ - Begin_NoShift, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_SPRITE_FUNCTION_NO_SHIFT_M_OR_XOR_

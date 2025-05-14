
                ifndef _DRAW_SPRITE_FUNCTION_SHIFT_OR_XOR_
                define _DRAW_SPRITE_FUNCTION_SHIFT_OR_XOR_

                module OR_XOR
Begin_Shift:    EQU $
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

Shift_OX:
._xx            ;  1.0 байт
                LD A, (DE)
                EXX
                JP Shift_OX_oOO_Xx.R
._xXx           ;  2.0 байт
                LD A, (DE)
                EXX
                JP Shift_OX_oO_XXx.R
._xXXx          ;  3.0 байт
                LD A, (DE)
                EXX
                JP Shift_OX_o_XXXx.R
Shift_OX_Left:
._x_XXXx        ; -0.5 байт
                EXX
                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                EXX
                JP Shift_OX_o_XXXx
._xX_XXx        ; -1.5 байт
                POP AF
._x_XXx         ; -0.5 байт
                EXX
                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                EXX
                JP Shift_OX_oO_XXx
._xXX_Xx        ; -2.5 байт
                POP AF
._xX_Xx         ; -1.5 байт
                POP AF
._x_Xx          ; -0.5 байт
                EXX
                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                EXX
                JP Shift_OX_oOO_Xx
._xXXX_x        ; -3.5 байт
                POP AF
._xXX_x         ; -2.5 байт
                POP AF
._xX_x          ; -1.5 байт
                POP AF
._x_x           ; -0.5 байт
                EXX
                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                EXX
                JP Shift_OX_oOOO_x
Shift_OX_xXXXx  ;  4.0 байт
                LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо
Shift_OX_o_XXXx ;
                LD A, (DE)  ; чтение байта из экрана

                EXX
                INC H       ; второй байт таблицы смещения (хвост)
                LD L, C     ; маска модифицированна ранее
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; применение смещение спрайта
                DEC H       ; первый байт таблицы смещения (начало)
                EX DE, HL

.R              POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо
Shift_OX_oO_XXx ;
                LD A, (DE)  ; чтение байта из экрана

                EXX
                INC H       ; второй байт таблицы смещения (хвост)
                LD L, C     ; маска модифицированна ранее
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; применение смещение спрайта
                DEC H       ; первый байт таблицы смещения (начало)
                EX DE, HL

.R              POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо
Shift_OX_oOO_Xx ;
                LD A, (DE)  ; чтение байта из экрана

                EXX
                INC H       ; второй байт таблицы смещения (хвост)
                LD L, C     ; маска модифицированна ранее
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; применение смещение спрайта
                DEC H       ; первый байт таблицы смещения (начало)
                EX DE, HL

.R              POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо
Shift_OX_oOOO_x ; правая половина байта
                LD A, (DE)  ; чтение байта из экрана

                EXX
                INC H       ; второй байт таблицы смещения (хвост)
                LD L, C     ; маска модифицированна ранее
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; применение смещение спрайта
                DEC H       ; первый байт таблицы смещения (начало)
                EX DE, HL
                EXX

                LD (DE), A  ; запись байта в экран
NextRow:        ; новая строка
                DEC C
                JP Z, Kernel.Sprite.DrawOR_XOR.Exit
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

Shift_OX_Right:
._xXX_Xx_       ; +1.5 байт
                POP AF
._xXX_Xx        ; +1.5 байт
._xXX_x         ; +1.5 байт

                LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EX DE, HL
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо
                JP ._xXX_x_
._xX_XXx_       ; +2.5 байт
                POP AF
._xX_Xx_        ; +1.5 байт
                POP AF
._xX_XXx        ; +2.5 байт
._xX_Xx         ; +1.5 байт
._xX_x          ; +0.5 байт
                LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EX DE, HL
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо
                JP ._xX_x_
._xXXX_x        ; +0.5 байт
                LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EX DE, HL
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._xXXX_x_       LD A, (DE)  ; чтение байта из экрана

                EXX
                INC H       ; второй байт таблицы смещения (хвост)
                LD L, C     ; маска модифицированна ранее
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; применение смещение спрайта
                DEC H       ; первый байт таблицы смещения (начало)
                EX DE, HL

                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._xXX_x_        LD A, (DE)  ; чтение байта из экрана

                EXX
                INC H       ; второй байт таблицы смещения (хвост)
                LD L, C     ; маска модифицированна ранее
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; применение смещение спрайта
                DEC H       ; первый байт таблицы смещения (начало)
                EX DE, HL

                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EXX

                LD (DE), A  ; запись байта в экран
                INC E       ; следующее знакоместо

._xX_x_         LD A, (DE)  ; чтение байта из экрана

                EXX
                INC H       ; второй байт таблицы смещения (хвост)
                LD L, C     ; маска модифицированна ранее
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; применение смещение спрайта
                DEC H       ; первый байт таблицы смещения (начало)
                EX DE, HL

                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EXX

                LD (DE), A  ; запись байта в экран
                JP NextRow
._x_XXXx_       ; +3.5 байт
                POP AF
._x_XXx_        ; +2.5 байт
                POP AF
._x_Xx_         ; +1.5 байт
                POP AF
._x_x           ; +0.5 байт
._x_Xx          ; +1.5 байт
._x_XXx         ; +2.5 байт
._x_XXXx        ; +3.5 байт
                LD A, (DE)  ; чтение байта из экрана

                EXX
                POP BC
                LD L, C     ; маска всегда хранится отзеркаленная
                LD C, (HL)  ; возвращаем прежнее значение
                EX DE, HL
                LD L, C
                OR (HL)     ; применение смещение маски
                LD L, B
                XOR (HL)    ; спрайт всегда хранится нормальный
                EX DE, HL
                EXX

                LD (DE), A  ; запись байта в экран
                JP NextRow

Shift.Table:
                DW Shift_OX_Left._x_x,      Shift_OX_Left._x_x                  ; -0.5 байт
.OX_8           DW Shift_OX._xx,            Shift_OX._xx                        ;  1.0 байт
                DW Shift_OX_Right._x_x,     Shift_OX_Right._x_x                 ; +0.5 байт

                DW Shift_OX_Left._xX_x,     Shift_OX_Left._xX_x                 ; -1.5 байт
                DW Shift_OX_Left._x_Xx,     Shift_OX_Left._x_Xx                 ; -0.5 байт
.OX_16          DW Shift_OX._xXx,           Shift_OX._xXx                       ;  2.0 байт
                DW Shift_OX_Right._xX_x,    Shift_OX_Right._xX_x                ; +0.5 байт
                DW Shift_OX_Right._x_Xx,    Shift_OX_Right._x_Xx_               ; +1.5 байт

                DW Shift_OX_Left._xXX_x,    Shift_OX_Left._xXX_x                ; -2.5 байт
                DW Shift_OX_Left._xX_Xx,    Shift_OX_Left._xX_Xx                ; -1.5 байт
                DW Shift_OX_Left._x_XXx,    Shift_OX_Left._x_XXx                ; -0.5 байт
.OX_24          DW Shift_OX._xXXx,          Shift_OX._xXXx                      ;  3.0 байт
                DW Shift_OX_Right._xXX_x,   Shift_OX_Right._xXX_x               ; +0.5 байт
                DW Shift_OX_Right._xX_Xx,   Shift_OX_Right._xX_Xx_              ; +1.5 байт
                DW Shift_OX_Right._x_XXx,   Shift_OX_Right._x_XXx_              ; +2.5 байт

                DW Shift_OX_Left._xXXX_x,   Shift_OX_Left._xXXX_x               ; -3.5 байт
                DW Shift_OX_Left._xXX_Xx,   Shift_OX_Left._xXX_Xx               ; -2.5 байт
                DW Shift_OX_Left._xX_XXx,   Shift_OX_Left._xX_XXx               ; -1.5 байт
                DW Shift_OX_Left._x_XXXx,   Shift_OX_Left._x_XXXx               ; -0.5 байт
.OX_32          DW Shift_OX_xXXXx,          Shift_OX_xXXXx                      ;  4.0 байт
                DW Shift_OX_Right._xXXX_x,  Shift_OX_Right._xXXX_x              ; +0.5 байт
                DW Shift_OX_Right._xXX_Xx,  Shift_OX_Right._xXX_Xx_             ; +1.5 байт
                DW Shift_OX_Right._xX_XXx,  Shift_OX_Right._xX_XXx_             ; +2.5 байт
                DW Shift_OX_Right._x_XXXx,  Shift_OX_Right._x_XXXx_             ; +3.5 байт

                display " - Draw function 'Shift OR & XOR': \t\t\t", /A, Begin_Shift, "\t= busy [ ", /D, $ - Begin_Shift, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_SPRITE_FUNCTION_SHIFT_OR_XOR_

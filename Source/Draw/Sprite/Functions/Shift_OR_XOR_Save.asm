
                ifndef _DRAW_SPRITE_FUNCTION_SHIFT_OR_XOR_SAVE_
                define _DRAW_SPRITE_FUNCTION_SHIFT_OR_XOR_SAVE_

                module OR_XOR_SAVE
Begin_Shift:    EQU $
; -----------------------------------------
;
; In:
;   SP  - адрес спрайта
;   HL  - адрес экрана вывода (копия)
;   DE  - адрес экрана вывода
;   B   - количество строк в знакоместе
;   C   - количество отображаемых строк
;   H'  - старший байт адреса таблицы сдвига
;   DE' - адрес буфера
; Out:
; Corrupt:
; Note:
; -----------------------------------------

Shift_OX:
._xx            ;  1.0 байт
                LD A, (DE)
                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                JP Shift_OX_oOO_Xx.R
._xXx           ;  2.0 байт
                LD A, (DE)
                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                JP Shift_OX_oO_XXx.R
._xXXx          ;  3.0 байт
                LD A, (DE)
                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                JP Shift_OX_o_XXXx.R
Shift_OX_Left:
; ._x_XXXx        ; -0.5 байт
;                 EXX
;                 POP BC
;                 EXX
;                 JP Shift_OX_o_XXXx
; ._xX_XXx        ; -1.5 байт
;                 POP AF
._x_XXx         ; -0.5 байт
                EXX
                POP BC
                EXX
                JP Shift_OX_oO_XXx
; ._xXX_Xx        ; -2.5 байт
;                 POP AF
._xX_Xx         ; -1.5 байт
                POP AF
._x_Xx          ; -0.5 байт
                EXX
                POP BC
                EXX
                JP Shift_OX_oOO_Xx
; ._xXXX_x        ; -3.5 байт
;                 POP AF
._xXX_x         ; -2.5 байт
                POP AF
._xX_x          ; -1.5 байт
                POP AF
._x_x           ; -0.5 байт
                EXX
                POP BC
                EXX
                JP Shift_OX_oOOO_x
; Shift_OX_xXXXx  ;  4.0 байт
;                 LD A, (DE)
;                 EXX
;                 POP BC
;                 LD L, C 
;                 OR (HL)
;                 LD L, B
;                 XOR (HL)
;                 EXX
;                 LD (DE), A
;                 INC E
Shift_OX_o_XXXx ;
                LD A, (DE)

                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                INC H
                LD L, C
                OR (HL)
                LD L, B
                XOR (HL)
                DEC H
.R              POP BC
                LD L, C 
                OR (HL)
                LD L, B
                XOR (HL)
                EXX
                LD (DE), A
                INC E
Shift_OX_oO_XXx ;
                LD A, (DE)

                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                INC H
                LD L, C
                OR (HL)
                LD L, B
                XOR (HL)
                DEC H

.R              POP BC
                LD L, C 
                OR (HL)
                LD L, B
                XOR (HL)
                EXX

                LD (DE), A
                INC E
Shift_OX_oOO_Xx ;
                LD A, (DE)

                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                INC H
                LD L, C
                OR (HL)
                LD L, B
                XOR (HL)
                DEC H

.R              POP BC
                LD L, C 
                OR (HL)
                LD L, B
                XOR (HL)
                EXX

                LD (DE), A
                INC E
Shift_OX_oOOO_x ; правая половина байта
                LD A, (DE)

                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                INC H
                LD L, C
                OR (HL)
                LD L, B
                XOR (HL)
                DEC H
                EXX

                LD (DE), A
NextRow:        ; новая строка
                DEC C
                JP Z, Kernel.Sprite.DrawOR_XOR_Save.Exit
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
.NextRow        LD E, L                                                         ; восстановление младший байт фдреса экрана
                JP (IY)

Shift_OX_Right:
; ._xXX_Xx_       ; +1.5 байт
;                 POP AF
; ._xXX_Xx        ; +1.5 байт
._xXX_x         ; +1.5 байт
                LD A, (DE)

                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                POP BC
                LD L, C
                OR (HL)
                LD L, B
                XOR (HL)
                EXX

                LD (DE), A
                INC E
                JP ._xXX_x_
; ._xX_XXx_       ; +2.5 байт
;                 POP AF
._xX_Xx_        ; +1.5 байт
                POP AF
; ._xX_XXx        ; +2.5 байт
._xX_Xx         ; +1.5 байт
._xX_x          ; +0.5 байт
                LD A, (DE)

                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                POP BC
                LD L, C
                OR (HL)
                LD L, B
                XOR (HL)
                EXX

                LD (DE), A
                INC E
                JP ._xX_x_
; ._xXXX_x        ; +0.5 байт
;                 LD A, (DE)
;                 EXX
;                 POP BC
;                 LD L, C
;                 OR (HL)
;                 LD L, B
;                 XOR (HL)
;                 EXX
;                 LD (DE), A
;                 INC E
; ._xXXX_x_       LD A, (DE)
;                 EXX
;                 INC H
;                 LD L, C
;                 OR (HL)
;                 LD L, B
;                 XOR (HL)
;                 DEC H
;                 POP BC
;                 LD L, C 
;                 OR (HL)
;                 LD L, B
;                 XOR (HL)
;                 EXX
;                 LD (DE), A
;                 INC E
._xXX_x_        ;
                LD A, (DE)

                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                INC H
                LD L, C
                OR (HL)
                LD L, B
                XOR (HL)
                DEC H
                POP BC
                LD L, C 
                OR (HL)
                LD L, B
                XOR (HL)
                EXX
                
                LD (DE), A
                INC E
._xX_x_         ;
                LD A, (DE)

                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                INC H
                LD L, C
                OR (HL)
                LD L, B
                XOR (HL)
                DEC H

                POP BC
                LD L, C 
                OR (HL)
                LD L, B
                XOR (HL)
                EXX

                LD (DE), A
                JP NextRow
; ._x_XXXx_       ; +3.5 байт
;                 POP AF
._x_XXx_        ; +2.5 байт
                POP AF
._x_Xx_         ; +1.5 байт
                POP AF
._x_x           ; +0.5 байт
._x_Xx          ; +1.5 байт
._x_XXx         ; +2.5 байт
; ._x_XXXx        ; +3.5 байт
                LD A, (DE)

                EXX
                LD (DE), A                                                      ; сохранение фона
                INC DE
                POP BC
                LD L, C
                OR (HL)
                LD L, B
                XOR (HL)
                EXX
                
                LD (DE), A
                JP NextRow
Shift.Table:
.OX_8_          DW Shift_OX_Left._x_x,      Shift_OX_Left._x_x                  ; -0.5 байт
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

                display " - Draw function 'Shift OR & XOR - Save': \t\t", /A, Begin_Shift, "\t= busy [ ", /D, $ - Begin_Shift, " byte(s)  ]"
                endmodule

                endif ; ~ _DRAW_SPRITE_FUNCTION_SHIFT_OR_XOR_SAVE_

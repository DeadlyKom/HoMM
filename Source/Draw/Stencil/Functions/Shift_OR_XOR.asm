
                ifndef _DRAW_STENCIL_FUNCTION_SHIFT_OR_XOR_
                define _DRAW_STENCIL_FUNCTION_SHIFT_OR_XOR_

                module OR_XOR
Begin_Shift:    EQU $
; -----------------------------------------
; вывод спрайт OR & XOR используя трафарет
; In:
;   SP - адрес спрайта
;   H  - старший байт адреса таблицы сдвига
;   DE - адрес экрана (текущий)
;   IX - адрес трафарета (текущий)
;   IY - адрес функции вывода "последующего"
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Shift_OX:       ;
                S_OR_XOR_HEAD_  ; применеие OR & XOR - начинающий (начало)
                APPLY_STENCIL   ; применение трафарета
                ; -----------------------------------------
                S_OR_XOR_TAIL   ; применеие OR & XOR (хвост)
                S_OR_XOR_HEAD   ; применеие OR & XOR (начало)
                APPLY_STENCIL   ; применение трафарета
                ; -----------------------------------------
                S_OR_XOR_TAIL_  ; применеие OR & XOR - завершающий (хвост)
                APPLY_STENCIL_  ; применение трафарета - завершающий

;   HL' - адрес экрана (начало строки)
;   DE' - адрес экрана (текущий)
;   B'  - количество оставшихся строк в знакоместе
;   C'  - количество оставшихся строк рисования
NextRow:        LD (.ContainerSpr), SP
.ContainerSP    EQU $+1
                LD SP, #0000

                ; переход к следующей строке трафарета
.StencilStep    EQU $+1
                LD BC, #0000
                ADD IX, BC

                EXX
                
                ; новая строка
                DEC C
                RET Z                                                           ; выход, если спрайт полностью выведен

                INC D
                DJNZ .NextRow

                ; переход к следующему знакоместу по вертикали
                LD B, #08                                                       ; количество оставшихся строк в знакоместе
                LD A, L
                ADD A, #20
                LD L, A
                JR C, .NextBoundary                                             ; преход, если 1/3 часть экрана пересечена 

                ; восстановление адреса экрана (начальной строки)
                LD D, H
                LD E, L

.PrepareJump    ; подготовка к переходу новой строки
                PUSH DE                                                         ; адрес экрана (текщий)
                EXX
                POP DE
                
                ; защитная от порчи данных с разрешённым прерыванием
                LD (NextRow.ContainerSP), SP

                ; чтение двух байт спрайта
.ContainerSpr   EQU $+1
                LD HL, #0000
                LD C, (HL)
                INC HL
                LD B, (HL)
                INC HL
                LD SP, HL

.ShiftTable     EQU $+1
                LD H, #00                                                       ; HIGH Adr.ShiftTable
                
                ;   SP - адрес спрайта
                ;   H  - старший байт адреса таблицы сдвига
                ;   DE - адрес экрана (текущий)
                ;   BC - пара данных спрайта OR & XOR
                ;   IX - адрес трафарета (текущий)
                JP (IY)

.NextBoundary   LD H, D                                                         ; сохранение старший байт адреса экрана
.NextRow        LD E, L                                                         ; восстановление младший байт адреса экрана
                JP .PrepareJump
Shift.Table:    ; первая функция идёт для IY
.OX_32          DW Shift_OX_xXXXx,          Shift_OX_xXXXx,                     ;  4.0 байт
                DW Shift_OX_Right._xXXX_x,  Shift_OX_Right._xXXX_x              ; +0.5 байт
                DW Shift_OX_Right._xXX_Xx_, Shift_OX_Right._xXX_Xx              ; +1.5 байт
                DW Shift_OX_Right._xX_XXx_, Shift_OX_Right._xX_XXx              ; +2.5 байт
                DW Shift_OX_Right._x_XXXx_, Shift_OX_Right._x_XXXx              ; +3.5 байт

                display " - Draw stencil function 'Shift OR & XOR':\t\t\t\t= busy [ ", /D, $-Shift_OX, " byte(s) ]"
                endmodule

                endif ; ~ _DRAW_STENCIL_FUNCTION_SHIFT_OR_XOR_

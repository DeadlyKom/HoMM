
                ifndef _DRAW_STENCIL_FUNCTION_NO_SHIFT_OR_XOR_
                define _DRAW_STENCIL_FUNCTION_NO_SHIFT_OR_XOR_

                module OR_XOR
Begin_NoShift:  EQU $
; -----------------------------------------
; вывод спрайта OR & XOR без смещения через трафарет
; In:
;   DE - адрес экрана (текущий)
;   BC - начальная пара данных спрайта OR & XOR
;   IX - адрес трафарета (текущий)
;   IY - адрес функции вывода последующей строки
;   SP - адрес следующей пары данных спрайта
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX, SP
; Note:
; -----------------------------------------
NoShift_OX:     NS_OR_XOR_HEAD                                                  ; применение OR & XOR начального байта
                APPLY_STENCIL_                                                  ; применение трафарета - завершающий
.ContinueDraw   EQU $+1
                JP #0000                                                        ; переход к продолжению вывода строки
                ; -----------------------------------------
.XXXXXX         NS_OR_XOR_BYTE                                                  ; отображение строки (6.0 байт)
                ; -----------------------------------------
.XXXXX_X        NS_OR_XOR_BYTE                                                  ; отображение строки (5.0 байт)
                ; -----------------------------------------
.XXXX_XX        ; отображение строки (4.0 байт), с пропуском (2.0 байт)
.XXXX           NS_OR_XOR_BYTE                                                  ; отображение строки (4.0 байт)
                ; -----------------------------------------
.XXX_XXX        ; отображение строки (3.0 байт), с пропуском (3.0 байт)
.XXX_X          NS_OR_XOR_BYTE                                                  ; отображение строки (3.0 байт)
                ; -----------------------------------------
.XX_XXXX        ; отображение строки (2.0 байт), с пропуском (4.0 байт)
.XX_XX          NS_OR_XOR_BYTE                                                  ; отображение строки (2.0 байт)
                JP NextRow
NoShift_Right:  ; обработчики правого отсечения
._X_XXXXX_     ; пропуск (+5.0 байт) перед отображением последующих строк
                POP BC  ; +4.0 байт
._XX_XXXX_     ; пропуск (+4.0 байт) перед отображением последующих строк
                POP BC  ; +3.0 байт
._XXX_XXX_     ; пропуск (+3.0 байт) перед отображением последующих строк
._X_XXX_       ; пропуск (+3.0 байт) перед отображением последующих строк
                POP BC  ; +2.0 байт
._XXXX_XX_     ; пропуск (+2.0 байт) перед отображением последующих строк
._XX_XX_       ; пропуск (+2.0 байт) перед отображением последующих строк
                POP BC  ; +1.0 байт
._XXXXX_X_     ; пропуск (+1.0 байт) перед отображением последующих строк
._XXX_X_       ; пропуск (+1.0 байт) перед отображением последующих строк
                POP BC
                JP NoShift_OX
.X_XXXXX        EQU NextRow
.X_XXX          EQU NextRow
NoShift.Table:  ; функция для IY, функция первой строки, продолжение вывода
.OX_48          DW NoShift_OX,                  NoShift_OX,                 NoShift_OX.XXXXXX           ; 6.0 байт
                DW NoShift_Right._XXXXX_X_,     NoShift_OX,                 NoShift_OX.XXXXX_X          ; 5.0 байт
                DW NoShift_Right._XXXX_XX_,     NoShift_OX,                 NoShift_OX.XXXX_XX          ; 4.0 байт
                DW NoShift_Right._XXX_XXX_,     NoShift_OX,                 NoShift_OX.XXX_XXX          ; 3.0 байт
                DW NoShift_Right._XX_XXXX_,     NoShift_OX,                 NoShift_OX.XX_XXXX          ; 2.0 байт
                DW NoShift_Right._X_XXXXX_,     NoShift_OX,                 NoShift_Right.X_XXXXX       ; 1.0 байт
.OX_32          DW NoShift_OX,                  NoShift_OX,                 NoShift_OX.XXXX             ; 4.0 байт
                DW NoShift_Right._XXX_X_,       NoShift_OX,                 NoShift_OX.XXX_X            ; 3.0 байт
                DW NoShift_Right._XX_XX_,       NoShift_OX,                 NoShift_OX.XX_XX            ; 2.0 байт
                DW NoShift_Right._X_XXX_,       NoShift_OX,                 NoShift_Right.X_XXX         ; 1.0 байт

                display " - Draw stencil function 'No Shift OR & XOR':\t\t\t= busy [ ", /D, $-Begin_NoShift, " byte(s) ]"
                endmodule

                endif ; ~ _DRAW_STENCIL_FUNCTION_NO_SHIFT_OR_XOR_

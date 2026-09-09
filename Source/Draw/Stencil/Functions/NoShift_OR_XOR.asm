
                ifndef _DRAW_STENCIL_FUNCTION_NO_SHIFT_OR_XOR_
                define _DRAW_STENCIL_FUNCTION_NO_SHIFT_OR_XOR_

                module OR_XOR
Begin_NoShift:  EQU $
; -----------------------------------------
;
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
NoShift_OX_XX:  ; 
                NS_OR_XOR_HEAD  ; применение OR & XOR без смещения (начало)
                APPLY_STENCIL   ; применение трафарета
                ; -----------------------------------------
                NS_OR_XOR_TAIL  ; применение OR & XOR без смещения (хвост)
                APPLY_STENCIL_  ; применение трафарета - завершающий

                JP Function.OR_XOR.NextRow

                display " - Draw stencil function 'OR XOR':\t\t\t\t= busy [ ", /D, $-Begin_NoShift, " byte(s) ]"
                endmodule

                endif ; ~ _DRAW_STENCIL_FUNCTION_NO_SHIFT_OR_XOR_

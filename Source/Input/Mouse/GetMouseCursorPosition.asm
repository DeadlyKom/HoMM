                        
                ifndef _INPUT_MOUSE_GET_CURSOR_POSITION_
                define _INPUT_MOUSE_GET_CURSOR_POSITION_
                        
; -----------------------------------------
; In :
; Out :
;   A - значение счетчика координаты X положения мыши
; Corrupt :
;   BC, A
; -----------------------------------------
GetMouseX:      LD BC, #FBDF
                IN A, (C)
                RET
; -----------------------------------------
; In :
; Out :
;   A - значение счетчика координаты Y положения мыши
; Corrupt :
;   BC, A
; -----------------------------------------
GetMouseY:      LD BC, #FFDF
                IN A, (C)
                RET

; -----------------------------------------
; In :
; Out :
;   E - значение счетчика координаты X положения мыши
;   D - значение счетчика координаты Y положения мыши
; Corrupt :
;   BC, DE
; -----------------------------------------
GetMouseXY:     LD BC, #FBDF
                IN E, (C)
                LD B, #FF
                IN D, (C)
                RET

                endif ; ~_INPUT_MOUSE_GET_CURSOR_POSITION_

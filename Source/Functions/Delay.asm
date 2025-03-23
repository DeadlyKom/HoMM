
                ifndef _FUNCTIONS_DELAY_
                define _FUNCTIONS_DELAY_
; -----------------------------------------
; задержка 4 фрейма
; In:
; Out:
; Corrupt:
;   B
; Note:
; -----------------------------------------
Delay:          LD B, #04
.DelayLoop      HALT
                DJNZ .DelayLoop
                RET
; -----------------------------------------
; задержка 4 фрейма
; In:
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
DelaySwapScreen:LD B, #04
.DelayLoop      HALT
                PUSH BC
                SWAP_SCREEN                                                     ; переключение экрана
                POP BC
                DJNZ .DelayLoop
                RET

                endif ; ~_FUNCTIONS_DELAY_

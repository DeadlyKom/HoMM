
                    ifndef _INPUT_CHECK_KEY_STATE_
                    define _INPUT_CHECK_KEY_STATE_

; -----------------------------------------
; проверить состояние виртуальной клавиши
; In :
;   A  - Виртуальная Клавиша
; Out :
;   флаг Z сброшен, если кнопка отжата
; Corrupt :
;   BC, AF
; -----------------------------------------
CheckKeyState:      PUSH HL
                    LD HL, .RET
                    LD (.VK), A
                    OR A
                    ifdef ENABLE_MOUSE
                    JP M, Mouse.CheckKeyState
                    endif
                    JP P, .IsJoystick
.VK                 EQU $+1
.RET                LD A, #00
                    POP HL
                    RET

.IsJoystick         BIT VK_KEMPSTON_BIT, A
                    JP Z, Keyboard.CheckKeyState
                    JP Kempston.CheckKeyState

                    endif ; ~_INPUT_CHECK_KEY_STATE_
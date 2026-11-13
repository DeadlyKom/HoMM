
                    ifndef _INPUT_KEMPSTON_CHECK_KEY_STATE_
                    define _INPUT_KEMPSTON_CHECK_KEY_STATE_

; -----------------------------------------
; проверить состояние клавиш Kempston
; In :
;   A  - "виртуальная клавиша"
;   HL - адрес возврата
; Out :
;   флаг Z установлен, если клавиша нажата
; Corrupt :
;   BC, AF
; Note:
; -----------------------------------------
CheckKeyState:      ; KEMPSTON_JOYSTICK_SHIFT = 3
                    AND %00111000
                    OR INSTRUCTION_BIT
                    LD (.BIT), A
                    XOR A
                    IN A, (#1F)
                    CPL
.BIT                EQU $+1                                                     ; BIT n, A
                    DB #CB, #00

                    JP (HL)

                    endif ; ~_INPUT_KEMPSTON_CHECK_KEY_STATE_

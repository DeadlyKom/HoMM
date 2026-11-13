                        
                    ifndef _INPUT_MOUSE_GET_KEY_STATE_
                    define _INPUT_MOUSE_GET_KEY_STATE_
; -----------------------------------------
; чтение состояние клавиш мыши
; In:
;   A  - "виртуальная клавиша"
;   HL - адрес возврата
; Out:
;   флаг Z установлен, если клавиша мыши нажата
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
CheckKeyState:  AND SVK_BUTTON_MASK
                LD BC, #FADF
                IN C, (C)
                AND C
                JP (HL)
; -----------------------------------------
; чтение счётчика колёсика мыши
; In:
; Out:
;   A - значение счётчика колёсика мыши
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
WheelCounter:   LD BC, #FADF
                IN A, (C)
                AND #F0
                RRCA
                RRCA
                RRCA
                RRCA
                RET

                endif ; ~_INPUT_MOUSE_GET_KEY_STATE_

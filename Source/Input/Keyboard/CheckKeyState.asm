
                ifndef _INPUT_KEYBOARD_CHECK_KEY_STATE_
                define _INPUT_KEYBOARD_CHECK_KEY_STATE_
; -----------------------------------------
; проверить состояние клавиши
; In :
;   A  - "виртуальная клавиша"
;   HL - адрес возврата
; Out :
;   флаг Z установлен, если кнопка нажата
; Corrupt :
;   BC, AF
; Note:
; -----------------------------------------
CheckKeyState:  ; расчёт индекса клавиши в таблице из кода 1–40
                DEC A
                LD BC, VirtKeysTable
                ADD A, A    ; x2
                ADD A, C
                LD C, A
                ADC A, B
                SUB C
                LD B, A
                LD A, (BC)
                LD (.BIT), A
                INC BC
                LD A, (BC)
                IN A, (#FE)
.BIT            EQU $+1                                                         ; BIT n, A
                DB #CB, #00
                JP (HL)

                endif ; ~_INPUT_KEYBOARD_CHECK_KEY_STATE_

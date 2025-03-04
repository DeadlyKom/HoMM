
                    ifndef _INPUT_KEYBOARD_PRESSED_KEY_1_5_
                    define _INPUT_KEYBOARD_PRESSED_KEY_1_5_
; -----------------------------------------
; получить нажатую клавишу 1-5
; In:
; Out:
;   C  - номер клавиши
;   если была нажата клавиша флаг переполнения Carry установлен
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
GetPressed_1_5: ; #F7FE
                ;   +----+----+----+----+----+----+----+----+
                ;   |  7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 |
                ;   +----+----+----+----+----+----+----+----+
                ;   | .. | .. | .. |  5 |  4 |  3 |  2 |  1 |
                ;   +----+----+----+----+----+----+----+----+

                LD BC, #F7FE
                IN A, (C)
                CPL
                LD BC, #0500

.NextBit        RRA
                RET C
                INC C
                DJNZ .NextBit

                RET

                endif ; ~_INPUT_KEYBOARD_PRESSED_KEY_1_5_

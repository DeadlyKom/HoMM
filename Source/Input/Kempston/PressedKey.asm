
                    ifndef _INPUT_KEMPSTON_PRESSED_KEY_STATE_
                    define _INPUT_KEMPSTON_PRESSED_KEY_STATE_
; -----------------------------------------
; получить Виртуальную Клавишу нажатой клавиши кемпстон джойстика
; In:
; Out:
;   если была нажата клавиша флаг переполнения Carry установлен,
;   регистре E хранится Виртуальная Клавиша, в противном случае флаг cброшен
; Corrupt:
;   DE, AF
; Note:
; -----------------------------------------
GetPressedKey:  ; проверка наличия кемстон джойстика
                CHECK_HARDWARE_FLAG_A HARDWARE_KEMPSTON_BIT
                JR Z, .Skip                                                     ; переход, т.к. кемпстон не поддерживается

                ; тип кемпстон джойстика 5 или 8 кнопочный
                CHECK_FLAG_A HARDWARE_KEMPSTON_BUTTON_BIT
                LD D, #05
                JR Z, $+4
                LD D, #08

                LD E, VK_KEMPSTON_RIGHT
                XOR A
                IN A, (#1F)
.NextBit        RRA
                RET C
                INC E
                DEC D
                JR NZ, .NextBit

.Skip           OR A
                RET
WaitPressedKey: ; проверка наличия кемстон джойстика
                CHECK_HARDWARE_FLAG_A HARDWARE_KEMPSTON_BIT
                RET Z
                
                HALT
                CALL GetPressedKey
                RET C
                JR WaitPressedKey
                
; ожидание отпускание ранее нажатой клавиши
WaitReleasedKey ; проверка наличия кемстон джойстика
                CHECK_HARDWARE_FLAG_A HARDWARE_KEMPSTON_BIT
                RET Z
                
                HALT
                CALL GetPressedKey
                RET NC
                JR WaitReleasedKey

; проверка нажатия любой клавиши
; если флаг нуля установлен, нажата
AnyKeyPressed:  ; проверка наличия кемстон джойстика
                CHECK_HARDWARE_FLAG_A HARDWARE_KEMPSTON_BIT
                SCF
                RET Z                                                           ; выход, т.к. кемпстон не поддерживается

                ; тип кемпстон джойстика 5 или 8 кнопочный
                CHECK_FLAG_A HARDWARE_KEMPSTON_BUTTON_BIT
                LD D, %00011111
                JR Z, $+4
                LD D, %11111111
                
                XOR A
                IN A, (#1F)
                OR D
                RET

                endif ; ~_INPUT_KEMPSTON_PRESSED_KEY_STATE_


                ifndef _INPUT_MENPSTON_INITIALIZE_
                define _INPUT_MENPSTON_INITIALIZE_
; -----------------------------------------
; инициализация кемпстон джойстика
; In :
; Out :
;   флаг переполнения Carry сброшен, если кемпстон обнаружен
; Corrupt :
;   HL, E, BC, AF
; Note:
;   благодарность от https://t.me/Jerri1977 (C)
; -----------------------------------------
Initialize:     ; проверка наличия 5 кнопочного (класического)
                LD BC, #001F
                LD L, B
                LD E, B

.Loop           IN A, (C)
                OR E
                LD E, A
                DEC L
                JR NZ, .Loop

                LD A, E
                AND C
                JR NZ, .Error

                SET_HARD_INPUT_FLAG HARD_INPUT_KEMPSTON_BIT

                ; проверка возможности наличия 8 кнопочного
                IN A, (C)
                AND %11100000
                JR Z, .Button_8

.Button_5       RES_HARD_INPUT_FLAG HARD_INPUT_KEMPSTON_BUTTON_BIT
                ifdef _DEBUG
                LD HL, SCR_ADR_BASE + ScreenSize - 1
                SET_ATTR_IP BLACK, GREEN
                endif
                RET

.Button_8       SET_HARD_INPUT_FLAG HARD_INPUT_KEMPSTON_BUTTON_BIT
                ifdef _DEBUG
                LD HL, SCR_ADR_BASE + ScreenSize - 1
                SET_ATTR_IP BLACK, BLUE
                endif
                RET

.Error          RES_HARD_INPUT_FLAG HARD_INPUT_KEMPSTON_BIT
                SCF
                ifdef _DEBUG
                LD HL, SCR_ADR_BASE + ScreenSize - 1
                SET_ATTR_IP BLACK, RED
                endif
                RET
                
                endif ; ~_INPUT_MENPSTON_INITIALIZE_
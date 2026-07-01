
                ifndef _MAIN_MENU_INPUT_SKIP_INTRO_
                define _MAIN_MENU_INPUT_SKIP_INTRO_
; -----------------------------------------
; сканирование устроиств ввода
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SkipIntro:      ; проверка наличие флага символа "Чур"
                CHECK_FLAG_MODIFY MainMenu.Base.Render.UpdateScreen.ChurFlag
                RET NZ                                                          ; выход, если флаг установлени

                ; проверка клавиши 'SPACE'
                LD A, VK_SPACE
                CALL Input.CheckKeyState
                JR Z, .IncCounter                                               ; переход, если клавиша нажата

                ; DEC CLAMP ZERO (уменьшение до нуля)
                LD A, (MainMenu.Base.Render.Draw_Chur.Counter)
                LD C, A
                SUB #01
                ADC A, #00
                LD (MainMenu.Base.Render.Draw_Chur.Counter), A
                CP C
                JR NZ, .SetFlag                                                 ; переход, если значение изменилось
                RET

.IncCounter     LD HL, MainMenu.Base.Render.Draw_Chur.Counter
                LD A, (HL)
                CP #13
                RET Z   ; ToDo активировать скип
                INC (HL)

.SetFlag        ; установка флага обновления символа "Чур"
                SET_FLAG_MODIFY MainMenu.Base.Render.UpdateScreen.ChurFlag
                RET



                endif ; ~_MAIN_MENU_INPUT_SKIP_INTRO_

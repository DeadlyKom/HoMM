
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
                RET Z                                                           ; выход, ели значение не изменилось

                ; значение изменилось

                ; установить таблицу обратного прохода
                LD HL, MainMenu.Base.Render.Draw_Chur.BackwardTable
                LD (MainMenu.Base.Render.Draw_Chur.Direction), HL

.SetFlag        ; установка флага обновления символа "Чур"
                SET_FLAG_MODIFY MainMenu.Base.Render.UpdateScreen.ChurFlag
                RET

.IncCounter     LD HL, MainMenu.Base.Render.Draw_Chur.Counter
                LD A, (HL)
                CP #13+1
                
                CALL .SetFlag
                JP Z, .SkipIntro                                                ; переход, если прогроесс достих максимального значения

                INC (HL)

                ; установить таблицу прямого прохода
                LD HL, MainMenu.Base.Render.Draw_Chur.ForwardTable
                LD (MainMenu.Base.Render.Draw_Chur.Direction), HL
                RET

.SkipIntro      ; активировать скип интро
                SET_FLAG_MODIFY MainMenu.Base.Input.Scan.DisableSkipFlag        ; установка флага запрещения пропуска интро
                SET_FLAG_MODIFY MainMenu.Base.Render.ActivateIntro.Flag         ; установка флага активации завершения интро
                RET

                endif ; ~_MAIN_MENU_INPUT_SKIP_INTRO_

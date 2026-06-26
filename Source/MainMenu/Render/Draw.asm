
                ifndef _MAIN_MENU_RENDER_DRAW_
                define _MAIN_MENU_RENDER_DRAW_
; -----------------------------------------
; отображение "главного меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; -----------------------------------------
                ; точка входа отображения
                ; -----------------------------------------

.Transiton      ; -----------------------------------------
                ; переход между меню
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_TRANSITION_BIT
                JR Z, .Enter

                ; ToDo: временная инициализация, без взаимодействия с пользователем
                ;---------------------------------------------------------------
                ; создание слота сохранения и инициализация
                RES_USER_HANDLER                                                ; отключение обработчика прерываний
                LAUNCH_ASSET_FUNCTION_RESTORE Session.Make, ExecuteModule.Session

                ; ToDo: временная проверка запуска меню
                ifndef ENABLE_MAIN_MENU
                ; проверка клавиш 'М'
                LD A, VK_M
                CALL Input.CheckKeyState
                JR Z, .InitMenu

                ; установка флага завершение цикла
                SET_MAIN_FLAG ML_EXIT_BIT
                JR .Enter
                endif

.InitMenu       CALL MainMenu.Base.Core.Initialize                              ; первичная инициализация "главного меню"
                RES_FLAG_MODIFY MainMenu.Base.Render.Draw.Flag                  ; сброс флага завершения
                ;---------------------------------------------------------------

.Enter          ; -----------------------------------------
                ; первичная инициализация
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_ENTER_BIT
                JR Z, .Update

.Update         ; -----------------------------------------
                ; обновление
                ; -----------------------------------------
                CHECK_MAIN_FLAG ML_UPDATE_BIT
                JR Z, .Tick

.Tick           ; -----------------------------------------
                ; тик
                ; -----------------------------------------
                ; проверка флага проигрывания портала
.Flag           EQU $
                NOP
                CALL C, Update                                                  ; переход, если проигрывание анимации портала завершено
                
                RES_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; выборочный сброс Render флагов
                RET

; -----------------------------------------
; обновление экрана
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
UpdateScreen:   SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                CALL MainMenu.Base.Particle.RestoreScreen
                JP MainMenu.Base.Particle.Draw
Update:         CALL MainMenu.Base.Particle.RefillPointQueue                    ; пополнение очереди точек
                CALL MainMenu.Base.Particle.ParticleSampling                    ; выборка частиц из очереди точек
                CALL MainMenu.Base.Particle.UpdateParticles                     ; обновление позиции активных частиц

                RES_FLAG_MODIFY MainMenu.Base.Render.Draw.Flag                  ; сброс флага завершения
                RET
.Force          SET_FLAG_MODIFY MainMenu.Base.Render.Draw.Flag
                RET

                display " - Main draw:\t\t\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~_MAIN_MENU_RENDER_DRAW_

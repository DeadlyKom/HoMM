
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
                RES_FLAG_MODIFY MainMenu.Base.Render.Draw.Flag                  ; сброс флага завершения проигрывании анимации портала
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
.Flag           FLAG_MODIFY 0                                                   ; флаг завершения проигрывании анимации портала
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
UpdateScreen:   CALL MainMenu.Base.Particle.RestoreScreen                       ; восстановление экрана
                CALL MainMenu.Base.Render.Portal.Play                           ; проигрывание анимации "портала"
.ChurFlag       FLAG_MODIFY 0                                                   ; флаг обновления символа "Чур"
                CALL C, Draw_Chur                                               ; отображение символа "Чур"
                CALL MainMenu.Base.Particle.Draw                                ; отображение частиц
                SET_FLAG_MODIFY MainMenu.Base.Render.Draw.Flag                  ; установка флага завершения проигрывании анимации портала
                RET
Update:         ; проверка наличие флага активации завершения интро (блокируется пропуском интро)
                CHECK_FLAG_MODIFY MainMenu.Base.Render.ActivateIntro.Flag
                JR C, .ResetFlag                                                ; переход, если активен флаг активации завершения интро
                                                                                ; позволяет блокировать появление новых частиц (ВАЖНО)

                CALL MainMenu.Base.Particle.RefillPointQueue                    ; пополнение очереди точек
                CALL MainMenu.Base.Particle.ParticleSampling                    ; выборка частиц из очереди точек
                CALL MainMenu.Base.Particle.UpdateParticles                     ; обновление позиции активных частиц

.ResetFlag      RES_FLAG_MODIFY MainMenu.Base.Render.Draw.Flag                  ; сброс флага завершения проигрывании анимации портала
                RET
; -----------------------------------------
; активации пропуска интро
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
ActivateIntro:  ; проверка наличие завершения проигрывании анимации портала (блокируется обновлением частиц)
                CHECK_FLAG_MODIFY MainMenu.Base.Render.Draw.Flag
                RET C                                                           ; выход, если активен флаг завершения проигрывании анимации портала
                                                                                ; позволяет блокировать завершение интро, 
                                                                                ; пока незавершится цикл обновления оставшихся частиц (ВАЖНО)

.Flag           FLAG_MODIFY 0                                                   ; флаг завершения интро
                RET NC

                RES_FLAG_MODIFY MainMenu.Base.Render.ActivateIntro.Flag         ; сброс флага активации завершения интро
                SET_FLAG_MODIFY MainMenu.Base.Render.PrepareIntro.Flag          ; установка флага активации подготовки завершения интро
                JP MainMenu.Base.Render.Draw_Flash.Show

; -----------------------------------------
; подготовка пропуска интро
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
PrepareIntro:
.Flag           FLAG_MODIFY 0                                                   ; флаг активации подготовки завершения интро
                RET NC

                RES_FLAG_MODIFY MainMenu.Base.Render.PrepareIntro.Flag          ; сброс флага активации подготовки завершения интро

                ; ToDo: добавить флаг для следующего фрейма, где будет проигрываться эффект волны, скрытия частиц
                JP MainMenu.Base.Render.Draw_Flash.Hide

                display " - Main draw:\t\t\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~_MAIN_MENU_RENDER_DRAW_

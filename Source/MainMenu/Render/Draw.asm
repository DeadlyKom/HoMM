
                ifndef _MAIN_MENU_RENDER_DRAW_
                define _MAIN_MENU_RENDER_DRAW_
; -----------------------------------------
; отображение "мира"
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
                ; проверка клавиш 'М'
                LD A, VK_M
                CALL Input.CheckKeyState
                JR Z, .InitMenu

                ; установка флага завершение цикла
                SET_MAIN_FLAG ML_EXIT_BIT
                JR .Enter

.InitMenu       ; загрузка данных контента "главного меню"
                CALL MainMenu.Base.Content.Portal.Load
                CALL MainMenu.Base.Render.Portal.Initialize                     ; первичная инициализация
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
                CALL Portal.Play                                                ; проигрывание анимации "портала"

                ; SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                RES_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; выборочный сброс Render флагов
                SET_RENDER_FLAG FRAME_READY_BIT                                 ; установка флага готовности кадра
                RET

                display " - Main draw:\t\t\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~_MAIN_MENU_RENDER_DRAW_

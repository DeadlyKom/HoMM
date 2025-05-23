
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

                ; ToDo: временноя инициализация, без взаимодействия с пользователем
                ;---------------------------------------------------------------
                ; создание слота сохранения и инициализация
                RES_USER_HANDLER                                                ; отключение обработчика прерываний
                LAUNCH_ASSET_FUNCTION_RESTORE Session.Make, ExecuteModule.Session

                ; установка флага завершение цикла
                SET_MAIN_FLAG ML_EXIT_BIT
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

                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана
                RES_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE             ; выборочный сброс Render флагов
                SET_RENDER_FLAG FINISHED_BIT                                    ; установка флага завершения отрисовки
                RET

                display " - Main draw:\t\t\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~_MAIN_MENU_RENDER_DRAW_


                ifndef _MAIN_MENU_MAIN_LOOP_
                define _MAIN_MENU_MAIN_LOOP_
; -----------------------------------------
; главный цикл "главного меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Loop:           
.Render         ; ************ RENDER ************
                CHECK_RENDER_FLAG FRAME_READY_BIT
                RET NZ

                ; проверка завершение цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
.FuncDraw       EQU $+1
                JP Z, $

                ; сброс флага завершение цикла
                RES_MAIN_FLAG ML_EXIT_BIT

                ; установка флагов
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE
                
                ;---------------------------------------------------------------
                ; загрузка сессии из слота сохраниея
                RES_USER_HANDLER                                                ; отключение обработчика прерываний
                LAUNCH_ASSET_FUNCTION_RESTORE Session.Load, ExecuteModule.Session
                ;---------------------------------------------------------------
                RES_USER_HANDLER                                                ; отключение обработчика перед освобождением главного меню
                CALL Core.ReleaseAsset                                          ; заранее освобождение текущего ресурса
                CALL Content.Font.Release                                       ; освобождение ресурса шрифта
                CALL Content.Portal.Release                                     ; освобождение контент данных "главного меню"
                CALL Content.Music.Release                                      ; освобождение контент данных "музыка"
                ;---------------------------------------------------------------
                JP ExecuteModule.World                                          ; запуск "мира"

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_MAIN_MENU_MAIN_LOOP_

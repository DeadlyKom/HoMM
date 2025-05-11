
                ifndef _MAIN_MENU_MAIN_LOOP_
                define _MAIN_MENU_MAIN_LOOP_
; -----------------------------------------
; главный цикл "мира"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Loop:           
.Render         ; ************ RENDER ************
                CHECK_RENDER_FLAG FINISHED_BIT
                RET NZ

                ; проверка завершение цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
.FuncDraw       EQU $+1
                JP Z, $

                ; сброс флага завершение цикла
                RES_MAIN_FLAG ML_EXIT_BIT

                ; установка флагов
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE
                
                ; загрузка сессии из слота сохраниея
                RES_USER_HANDLER                                                ; отключение обработчика прерываний
                LAUNCH_ASSET_FUNCTION_RESTORE Session.Load, ExecuteModule.Session
                RES_USER_HANDLER                                                ; отключение обработчика прерываний,
                                                                                ; т.к. после возвращения исполнения функции
                                                                                ; проинициализируется модуль главного меню
                                                                                ; и адрес обработчикм прерывания будет восстановлен
                CALL Core.ReleaseAsset                                          ; заранее освобождение текущего ресурса
                JP ExecuteModule.World                                          ; запуск "мира"

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_MAIN_MENU_MAIN_LOOP_

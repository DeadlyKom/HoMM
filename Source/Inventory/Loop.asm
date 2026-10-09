
                ifndef _INVENTORY_MAIN_LOOP_
                define _INVENTORY_MAIN_LOOP_
; -----------------------------------------
; главный цикл "инвентаря"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Loop:           ; главный цикл "инвентаря"
.Render         ; ************ RENDER ************
                ; проверка готовности кадра к показу
                CHECK_RENDER_FLAG FRAME_READY_BIT
                RET NZ                                                          ; выход, если готовый кадр ещё ожидает показа

                ; проверка запроса завершения текущего цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
.FuncDraw       EQU $+1
                JP Z, $                                                         ; переход, если завершение цикла не запрошено

.Exit           ; завершение текущего цикла
                RES_MAIN_FLAG ML_EXIT_BIT                                       ; сброс запроса завершения текущего цикла

                ; подготовка флагов для перехода между циклами
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE

                ; проверка запроса перехода в характеристики
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                CP UI_MODE_CHARACTERISTICS
                JP Z, ExecuteModule.Characteristics                             ; переход, если запрошен переход в характеристики

                ; проверка запроса возврата в мир
                CP UI_MODE_WORLD
                RET NZ                                                          ; выход, если возврат в мир не запрошен

                JP_EXE_ASSETS_NOT_PARAM ASSETS_ID_WORLD, World.Restore          ; восстановление состояния мира

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_INVENTORY_MAIN_LOOP_

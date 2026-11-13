
                ifndef _COMBAT_MAIN_LOOP_
                define _COMBAT_MAIN_LOOP_
; -----------------------------------------
; главный цикл "сражения"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
; -----------------------------------------
Loop:           ; главный цикл "сражения"
.Render         ; ************ RENDER ************
                ; проверка готовности кадра к показу
                CHECK_RENDER_FLAG FRAME_READY_BIT
                RET NZ                                                          ; выход, если готовый кадр ещё ожидает показа

                ; проверка запроса смены UI режима
                CALL UI.Runtime.Process
                JR NC, .CheckExit                                               ; переход, если переход UI режима не начат

                ; завершение перехода UI перед выходом из "сражения"
                SET_MAIN_FLAG ML_EXIT_BIT                                       ; запрос завершения главного цикла "сражения"
                CALL UI.Runtime.Complete                                        ; завершение смены UI режима

.CheckExit      ; проверка запроса завершения текущего цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
.FuncDraw       EQU $+1
                JP Z, Render.Draw                                               ; переход, если завершение цикла не запрошено

.Exit           ; завершение текущего цикла
                RES_MAIN_FLAG ML_EXIT_BIT                                       ; завершение работы текущего цикла

                ; подготовка флагов для перехода между циклами
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE

                ; выбор запускаемого модуля по запрошенному UI режиму
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                LD HL, .JumpTable
                JP Func.JumpTable

.Restore        ; восстановление состояния "мира"
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                PRE_LAUNCH_CHECK ASSETS_ID_WORLD                                ; проверка перед запуском ресурса
                JP_EXE_ASSETS_NOT_PARAM ASSETS_ID_WORLD, World.Restore

.JumpTable      DW .NoMode                                                      ; UI_MODE_NONE
                DW .NoMode                                                      ; UI_MODE_CHARACTERISTICS
                DW .NoMode                                                      ; UI_MODE_INVENTORY
                DW .NoMode                                                      ; UI_MODE_SPELLBOOK
                DW .NoMode                                                      ; UI_MODE_MAP
                DW .NoMode                                                      ; UI_MODE_QUEST_LOG
                DW .NoMode                                                      ; UI_MODE_GAME_MENU
                DW .NoMode                                                      ; UI_MODE_OPTIONS
                DW .NoMode                                                      ; UI_MODE_SAVE
                DW .Restore                                                     ; UI_MODE_WORLD
                DW .NoMode                                                      ; UI_MODE_COMBAT
.NoMode         RET                                                             ; выход без запуска другого модуля
                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_COMBAT_MAIN_LOOP_


                ifndef _CHARACTERISTICS_MAIN_LOOP_
                define _CHARACTERISTICS_MAIN_LOOP_
; -----------------------------------------
; главный цикл "характеристик"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
; -----------------------------------------
Loop:           ; главный цикл "характеристик"
.Render         ; ************ RENDER ************
                ; проверка готовности кадра к показу
                CHECK_RENDER_FLAG FRAME_READY_BIT
                RET NZ                                                          ; выход, если готовый кадр ещё ожидает показа

                ; проверка запроса завершения текущего цикла
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

.Restore        ; восстановление состояния мира
                JP_EXE_ASSETS_NOT_PARAM ASSETS_ID_WORLD, World.Restore

.JumpTable      DW .NoMode                                                      ; UI_MODE_NONE
                DW .NoMode                                                      ; UI_MODE_CHARACTERISTICS
                DW ExecuteModule.Inventory                                      ; UI_MODE_INVENTORY
                DW .NoMode                                                      ; UI_MODE_SPELLBOOK
                DW .NoMode                                                      ; UI_MODE_MAP
                DW .NoMode                                                      ; UI_MODE_QUEST_LOG
                DW .NoMode                                                      ; UI_MODE_SETTINGS
                DW .NoMode                                                      ; UI_MODE_GAME_PAUSE
                DW .Restore                                                     ; UI_MODE_WORLD
                DW .NoMode                                                      ; UI_MODE_BATTLE
.NoMode         RET                                                             ; выход без запуска другого модуля

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_CHARACTERISTICS_MAIN_LOOP_

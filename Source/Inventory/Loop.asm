
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
                ; проверка показа готового основного экрана
                CHECK_RENDER_FLAG SWAPPED_PENDING_BIT
                JP NZ, Render.CopyScreen                                        ; переход, если основной экран показан и ожидает переноса

                ; проверка готовности кадра к показу
                CHECK_RENDER_FLAG FRAME_READY_BIT
                RET NZ                                                          ; выход, если готовый кадр ещё ожидает показа

                ; проверка запроса перехода UI режима
                SET_MODULE_PAGE_Inventory                                       ; включение страницы модуля инвентаря
                CALL UI.Runtime.Process
                JP C, Inventory.SharedCode.UI.Transition.World                  ; переход, если начат переход UI режима

                ; проверка запроса завершения текущего цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
.FuncDraw       EQU $+1
                JP Z, $                                                         ; переход, если завершение цикла не запрошено

.Exit           ; завершение текущего цикла
                RES_MAIN_FLAG ML_EXIT_BIT                                       ; сброс запроса завершения текущего цикла

                ; подготовка флагов для перехода между циклами
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE

                ; выбор запускаемого модуля по запрошенному UI режиму
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                LD HL, .JumpTable
                JP Func.JumpTable

.Restore        ; восстановление состояния мира
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                PRE_LAUNCH_CHECK ASSETS_ID_WORLD                                ; проверка перед запуском ресурса
                JP_EXE_ASSETS_NOT_PARAM ASSETS_ID_WORLD, World.Restore

.JumpTable      DW .NoMode                                                      ; UI_MODE_NONE
                DW ExecuteModule.Characteristics                                ; UI_MODE_CHARACTERISTICS
                DW .NoMode                                                      ; UI_MODE_INVENTORY
                DW .NoMode                                                      ; UI_MODE_SPELLBOOK
                DW .NoMode                                                      ; UI_MODE_MAP
                DW .NoMode                                                      ; UI_MODE_QUEST_LOG
                DW .NoMode                                                      ; UI_MODE_SETTINGS
                DW .NoMode                                                      ; UI_MODE_GAME_PAUSE
                DW .Restore                                                     ; UI_MODE_WORLD
                DW .NoMode                                                      ; UI_MODE_BATTLE
.NoMode         RET                                                             ; выход без запуска другого модуля

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_INVENTORY_MAIN_LOOP_

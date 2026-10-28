
                ifndef _MODULE_INVENTORY_RESTORE_STATE_
                define _MODULE_INVENTORY_RESTORE_STATE_
; -----------------------------------------
; возобновление работы модуля инвентаря
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
;   состояния в странице модуля сохраняются до его полной выгрузки
; -----------------------------------------
RestoreState:   ; сохранение предыдущего UI режима до возобновления работы
                LD A, (GameState.UIRuntime + FUIRuntime.PreviousMode)
                PUSH AF

                CALL Launch.Deploy                                              ; восстановление общих блоков кода инвентаря
                CALL Launch.ClearState                                          ; очистка состояний
                CALL Launch.InitSprites                                         ; выбор и подготовка спрайтов текущего персонажа
                CALL Launch.Window                                              ; отображение окна "инвентаря"
                CALL Launch.Initialize                                          ; восстановление UI, главного цикла и обработчиков

                ; проверка перехода из характеристик
                POP AF
                CP UI_MODE_CHARACTERISTICS
                RET NZ                                                          ; выход, если переход выполнен не из характеристик

                JP_MARK_ASSETS_UNCLAIMED_IN_PAGE ASSETS_ID_CHARACTERISTICS      ; пометка модуля "характеристик" как невостребованного

                endif ; ~_MODULE_INVENTORY_RESTORE_STATE_

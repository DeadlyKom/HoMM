
                ifndef _MODULE_CHARACTERISTICS_RESTORE_STATE_
                define _MODULE_CHARACTERISTICS_RESTORE_STATE_
; -----------------------------------------
; возобновление работы модуля "характеристик" (горячий запуск)
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "характеристик"
;   рабочий код и настройки восстанавливаются из образа ресурса
; -----------------------------------------
RestoreState:   ; сохранение предыдущего UI режима до возобновления работы
                LD A, (GameState.UIRuntime + FUIRuntime.PreviousMode)
                PUSH AF

                CALL Launch.Deploy                                              ; восстановление общих блоков кода "характеристик"
                CALL Launch.ClearState                                          ; очистка временных состояний "характеристик"
                CALL Launch.InitSprites                                         ; загрузка и инициализация спрайтов
                CALL Launch.Window                                              ; отображение окна "характеристик"
                CALL Launch.Initialize                                          ; восстановление UI, главного цикла и обработчиков

                ; проверка перехода из "инвентаря"
                POP AF
                CP UI_MODE_INVENTORY
                RET NZ                                                          ; выход, если переход выполнен не из "инвентаря"

                JP_MARK_ASSETS_UNCLAIMED_IN_PAGE ASSETS_ID_INVENTORY            ; пометка модуля "инвентаря" как невостребованного после переключения

                endif ; ~_MODULE_CHARACTERISTICS_RESTORE_STATE_

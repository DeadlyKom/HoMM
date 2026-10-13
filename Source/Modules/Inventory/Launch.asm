
                ifndef _MODULE_INVENTORY_LAUNCH_
                define _MODULE_INVENTORY_LAUNCH_
; -----------------------------------------
; запуск "инвентаря"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Launch:         SAVE_ASSETS_PAGE Kernel.Modules.Inventory.Page                  ; сохранение страницы загруженного ресурса

                ; сохранение предыдущего UI режима до инициализации инвентаря
                LD A, (GameState.UIRuntime + FUIRuntime.PreviousMode)
                PUSH AF

                CALL Launch.Deploy                                              ; развёртывание общего кода инвентаря
                CALL Launch.InitSprites                                         ; загрузка и инициализация спрайтов
                CALL Launch.Window                                              ; отображение окна "инвентаря"
                CALL Launch.Initialize                                          ; инициализация "инвентаря"

                ; проверка перехода из характеристик
                POP AF
                CP UI_MODE_CHARACTERISTICS
                RET NZ                                                          ; выход, если переход выполнен не из характеристик

                JP_MARK_ASSETS_UNCLAIMED_IN_PAGE ASSETS_ID_CHARACTERISTICS      ; пометка модуля "характеристик" как невостребованного после переключения

                display " - Launch 'Inventory':\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_INVENTORY_LAUNCH_

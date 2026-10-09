
                ifndef _MODULE_CHARACTERISTICS_LAUNCH_
                define _MODULE_CHARACTERISTICS_LAUNCH_
; -----------------------------------------
; запуск "характеристик"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Launch:         SAVE_ASSETS_PAGE Kernel.Modules.Characteristics.Page            ; сохранение страницы загруженного ресурса

                ; сохранение предыдущего UI режима до инициализации характеристик
                LD A, (GameState.UIRuntime + FUIRuntime.PreviousMode)
                PUSH AF

                CALL Launch.Deploy                                              ; развёртывание общего кода характеристик
                CALL Launch.InitSprites                                         ; загрузка и инициализация спрайтов
                CALL Launch.Window                                              ; отображение окна "характеристик"
                CALL Launch.Initialize                                          ; инициализация "характеристик"

                ; проверка перехода из инвентаря
                POP AF
                CP UI_MODE_INVENTORY
                RET NZ                                                          ; выход, если переход выполнен не из инвентаря

                JP_RELEASE_ASSETS_IN_PAGE ASSETS_ID_INVENTORY                   ; освобождение модуля "инвентаря" после переключения

                display " - Launch 'Characteristics':\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_CHARACTERISTICS_LAUNCH_

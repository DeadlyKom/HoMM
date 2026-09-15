
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
Launch:         ; -----------------------------------------
                ; сохранение страницы
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Kernel.Modules.Characteristics.Page), A

                CALL Launch.Deploy                                              ; развёртывание общего кода характеристик
                JP Launch.Initialize                                            ; инициализация "характеристик"

                display " - Launch 'Characteristics':\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_CHARACTERISTICS_LAUNCH_

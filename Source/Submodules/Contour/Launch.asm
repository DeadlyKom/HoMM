
                ifndef _SUBMODULES_CONTOUR_LAUNCH_
                define _SUBMODULES_CONTOUR_LAUNCH_
; -----------------------------------------
; запуск сабмодуля "обводки"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Launch:         ; сохранение страницы сабмодуля "обводки"
                SAVE_ASSETS_PAGE Kernel.Submodules.Contour.Page                 ; сохранение страницы загруженного ресурса
                ; SAVE_ASSETS_ADDRESS Kernel.Submodules.Contour.Address           ; сохранение адреса загруженного ресурса

                CALL Launch.Allocate                                            ; выделение рабочего буфера
                CALL Launch.Relocate                                            ; настройка адресов таблицы и рабочих масок
                CALL Submodules.Contour.Tables.TG_Contour                       ; генерация таблицы расширения маски
                CALL Launch.Initialize                                          ; инициализация сабмодуля "обводки"

                RET
                display " - Launch submodule 'Contour':\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_SUBMODULES_CONTOUR_LAUNCH_

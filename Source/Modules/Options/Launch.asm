
                ifndef _MODULE_OPTIONS_LAUNCH_
                define _MODULE_OPTIONS_LAUNCH_
; -----------------------------------------
; запуск "опций" (холодный запуск)
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Launch:         SAVE_ASSETS_PAGE Kernel.Modules.Options.Page                    ; сохранение страницы загруженного ресурса

                CALL Launch.Deploy                                              ; развёртывание общего кода опций
                CALL Launch.ClearState                                          ; очистка временных состояний опций
                CALL Launch.Window                                              ; отображение окна "опций"
                CALL Launch.Initialize                                          ; инициализация "опций"

                RET
                display " - Launch 'Options':\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_OPTIONS_LAUNCH_

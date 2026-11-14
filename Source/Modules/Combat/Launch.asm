
                ifndef _MODULE_COMBAT_LAUNCH_
                define _MODULE_COMBAT_LAUNCH_
; -----------------------------------------
; запуск "сражения" (холодный запуск)
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Launch:         SAVE_ASSETS_PAGE Kernel.Modules.Combat.Page                     ; сохранение страницы загруженного ресурса

                CALL Launch.Deploy                                              ; развёртывание общего кода "сражения"
                CALL Launch.ClearState                                          ; очистка временных состояний "сражения"
                CALL Launch.Window                                              ; отображение окна "сражения"
                CALL Launch.Initialize                                          ; инициализация "сражения"

                RET
                display " - Launch 'Combat':\t\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_COMBAT_LAUNCH_

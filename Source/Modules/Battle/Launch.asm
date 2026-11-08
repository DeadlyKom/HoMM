
                ifndef _MODULE_BATTLE_LAUNCH_
                define _MODULE_BATTLE_LAUNCH_
; -----------------------------------------
; запуск "битвы" (холодный запуск)
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Launch:         SAVE_ASSETS_PAGE Kernel.Modules.Battle.Page                     ; сохранение страницы загруженного ресурса

                CALL Launch.Deploy                                              ; развёртывание общего кода битвы
                CALL Launch.ClearState                                          ; очистка временных состояний битвы
                CALL Launch.Window                                              ; отображение окна "битвы"
                CALL Launch.Initialize                                          ; инициализация "битвы"

                RET
                display " - Launch 'Battle':\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_BATTLE_LAUNCH_

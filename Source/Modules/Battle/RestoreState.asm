
                ifndef _MODULE_BATTLE_RESTORE_STATE_
                define _MODULE_BATTLE_RESTORE_STATE_
; -----------------------------------------
; возобновление работы модуля битвы (горячий запуск)
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "битвы"
;   рабочий код и настройки восстанавливаются из образа ресурса
; -----------------------------------------
RestoreState:   ; восстановление рабочего окружения битвы
                CALL Launch.Deploy                                              ; восстановление общих блоков кода битвы
                CALL Launch.ClearState                                          ; очистка временных состояний битвы
                CALL Launch.Window                                              ; отображение окна "битвы"
                CALL Launch.Initialize                                          ; восстановление UI, главного цикла и обработчиков

                RET

                endif ; ~_MODULE_BATTLE_RESTORE_STATE_

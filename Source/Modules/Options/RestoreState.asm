
                ifndef _MODULE_OPTIONS_RESTORE_STATE_
                define _MODULE_OPTIONS_RESTORE_STATE_
; -----------------------------------------
; возобновление работы модуля опций (горячий запуск)
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "опций"
;   рабочий код и настройки восстанавливаются из образа ресурса
; -----------------------------------------
RestoreState:   ; восстановление рабочего окружения опций
                CALL Launch.Deploy                                              ; восстановление общих блоков кода опций
                CALL Launch.ClearState                                          ; очистка временных состояний опций
                CALL Launch.Window                                              ; отображение окна "опций"
                CALL Launch.Initialize                                          ; восстановление UI, главного цикла и обработчиков

                RET

                endif ; ~_MODULE_OPTIONS_RESTORE_STATE_


                ifndef _MODULE_COMBAT_RESTORE_STATE_
                define _MODULE_COMBAT_RESTORE_STATE_
; -----------------------------------------
; возобновление работы модуля "сражения" (горячий запуск)
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "сражения"
;   рабочий код и настройки восстанавливаются из образа ресурса
; -----------------------------------------
RestoreState:   ; восстановление рабочего окружения "сражения"
                ; сохранение индекса направления Up до замены общего кода "мира"
                LD A, (World.SharedCode.Render.Object.Character.Indexes + 4)
                LD (Combat.ContourTest.State.Index), A

                CALL Launch.Deploy                                              ; восстановление общих блоков кода "сражения"
                CALL Launch.ClearState                                          ; очистка временных состояний "сражения"
                CALL Launch.Window                                              ; отображение окна "сражения"
                CALL Launch.Initialize                                          ; восстановление UI, главного цикла и обработчиков
                CALL Combat.ContourTest.Initialize                              ; временный тест анимации спрайта и обводки

                RET

                endif ; ~_MODULE_COMBAT_RESTORE_STATE_


                ifndef _TICK_OBJECT_UI_
                define _TICK_OBJECT_UI_
; -----------------------------------------
; обработчик тика объекта "UI"
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   C  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   F' - флаг переполнения установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   все регистры, кроме IX
; Note:
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI:             ; получение адреса настроек текущего UI объекта
                LD A, (IX + FObject.Settings)                                   ; настройки объекта по умолчанию
                CALL Object.Utilities.GetSettingsAdr.HL

                ; переход к полю поведения внутри FODS_UI
                LD A, L
                ADD A, FODS_UI.Behavior
                LD L, A
                LD A, (HL)                                                      ; FODS_UI.Behavior

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_UI_BEHAVIOR_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого поведения UI
                endif

                ; проверка, быстрого вход в поведение по умолчанию
                OR A                                                            ; OBJECT_UI_BEHAVIOR_DEFAULT
                JP Z, UI.Default

                ; расчёт адреса цепочки поведения UI объекта
                LD L, A
                LD H, #00
                ADD HL, HL                                                      ; индекс адреса в таблице цепочек поведения
                LD DE, UI.Behavior.Table
                ADD HL, DE

                ; чтение адреса цепочки поведения
                LD E, (HL)
                INC HL
                LD D, (HL)

                ; получение адреса сохранённой фазы поведения
                LD B, (IX + FObjectUI.Phase)                                    ; индекс выполняемой фазы

                ; расчёт адреса выполняемой фазы
                LD IYL, B
                LD IYH, #00
                ; размер структуры FUIBehaviorPhase
                ADD IY, IY  ; x2
                ADD IY, IY  ; x4
                ADD IY, DE

.ExecutePhase   ; получение адреса настроек функции фазы
                LD DE, (IY + FUIBehaviorPhase.Settings)

                ; получение индекса функции фазы
                LD A, (IY + FUIBehaviorPhase.Function)

                ; ловушка
                ifdef _DEBUG
                CP UI_BEHAVIOR_PHASE_FUNCTION_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такой функции фазы UI
                endif

                ; сохранение состояния исполнителя и входного состояния мирового тика
                PUSH IY                                                         ; адрес выполняемой фазы
                PUSH BC                                                         ; индекс выполняемой фазы и относительный временной шаг
                EX AF, AF'
                PUSH AF                                                         ; состояние мирового тика
                EX AF, AF'

                ; выполнение функции фазы
                LD HL, .FunctionTable
                CALL Func.JumpTable

                ; восстановление входного состояния мирового тика и состояния исполнителя
                EX AF, AF'
                POP AF                                                          ; состояние мирового тика
                EX AF, AF'
                POP BC                                                          ; индекс выполняемой фазы и относительный временной шаг
                POP IY                                                          ; адрес выполненной фазы

                ; проверка завершения выполняемой фазы
                JR NC, .CheckStop                                               ; переход, если фаза не завершена
                
                ; ----------------------------------------
                ; завершена фаза
                ; ----------------------------------------

                ; проверка, может ли завершённая фаза изменить сохранённый индекс
                LD A, (IX + FObjectUI.Phase)                                    ; индекс фазы объекта
                CP B                                                            ; сравнение с индексом фактически выполненной фазы
                JR NZ, .CheckStop                                               ; переход, если завершена временная фаза

                ; проверка необходимости повторного запуска завершённой фазы
                BIT UI_BEHAVIOR_PHASE_LOOP_BIT, (IY + FUIBehaviorPhase.Flags)
                JR NZ, .CheckStop                                               ; переход, если необходимо заново запустить текущую фазу

                INC (IX + FObjectUI.Phase)                                      ; переход к следующей фазе

.CheckStop      ; проверка необходимости остановки цепочки в текущем тике
                BIT UI_BEHAVIOR_PHASE_STOP_BIT, (IY + FUIBehaviorPhase.Flags)
                RET NZ                                                          ; выход, если дальнейшее выполнение фаз остановлено

                ; переход к следующей фазе в текущем тике
                INC B
                LD DE, FUIBehaviorPhase
                ADD IY, DE
                JR .ExecutePhase

.FunctionTable  DW UI.None                                                      ; UI_BEHAVIOR_PHASE_FUNCTION_NONE
                DW UI.Default                                                   ; UI_BEHAVIOR_PHASE_FUNCTION_DEFAULT
                DW UI.UpdateProgress                                            ; UI_BEHAVIOR_PHASE_FUNCTION_UPDATE_PROGRESS
                DW UI.SetAnimRange                                              ; UI_BEHAVIOR_PHASE_FUNCTION_SET_ANIMATION_RANGE
                DW UI.SetFlags                                                  ; UI_BEHAVIOR_PHASE_FUNCTION_SET_FLAGS
                DW UI.ResetFlags                                                ; UI_BEHAVIOR_PHASE_FUNCTION_RESET_FLAGS

                endif ; ~_TICK_OBJECT_UI_

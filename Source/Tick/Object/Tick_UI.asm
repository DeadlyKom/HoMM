
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
UI:             CALL .CheckAnimationFrame

                ; получение адреса настроек текущего UI объекта
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

; -----------------------------------------
; проверка смены кадра анимации UI объекта
; In:
;   IX - адрес структуры объекта (FObjectUI)
; Out:
;   флаг OBJECT_DIRTY установлен, если фактический кадр изменился
; Corrupt:
;   B, DE, AF
; -----------------------------------------
.CheckAnimationFrame:; проверка разрешения анимировать UI объект
                BIT LAYER_OBJECT_ANIMATION_ENABLED_BIT, (IX + FObjectUI.Layer.Flags)
                RET Z                                                           ; выход, если анимация выключена

                ; проверка смены тика объектов
                LD A, (GameState.TickCounter + FTick.Objects)
                CP (IX + FObjectUI.Animation.LastTick)
                RET Z                                                           ; выход, если кадр уже обновлялся в текущем тике объектов

                ; сохранение текущего тика как обработанного
                LD (IX + FObjectUI.Animation.LastTick), A

                ; получение первого и последнего кадров диапазона
                LD A, (IX + FObjectUI.Animation.Range)
                LD B, A
                AND UI_ANIMATION_RANGE_FIRST_MASK
                RRCA
                RRCA
                RRCA
                RRCA                                                            ; A = первый кадр диапазона
                LD D, A                                                         ; первый кадр диапазона

                LD A, B
                AND UI_ANIMATION_RANGE_FRAME_MAX_MASK                           ; максимальный локальный номер кадра
                RET Z                                                           ; выход, если диапазон содержит один кадр
                ADD A, D
                LD E, A                                                         ; последний кадр диапазона

                ; выбор направления проигрывания анимации
                LD A, (IX + FObject.Sprite)                                     ; текущий кадр диапазона
                BIT UI_ANIMATION_MODE_REVERSE_BIT, (IX + FObjectUI.Layer.Flags)
                JR NZ, .AnimReverse                                             ; переход, если анимация проигрывается в обратном направлении

.AnimForward    ; проверка достижения последнего кадра
                CP E
                JR C, .AnimIncrement                                            ; переход, если последний кадр ещё не достигнут

                ; проверка флага ping-pong
                BIT UI_ANIMATION_MODE_PING_PONG_BIT, (IX + FObjectUI.Layer.Flags)
                JR Z, .AnimFirst                                                ; переход к первому кадру при циклическом проигрывании

                SET UI_ANIMATION_MODE_REVERSE_BIT, (IX + FObjectUI.Layer.Flags) ; изменение направления проигрывания на обратное
                DEC A                                                           ; переход к предыдущему кадру без повторения последнего
                JR .AnimStore

.AnimIncrement  INC A                                                           ; переход к следующему кадру
                JR .AnimStore

.AnimReverse    ; проверка достижения первого кадра
                CP D
                JR NZ, .AnimDecrement                                           ; переход, если первый кадр ещё не достигнут

                ; проверка флага ping-pong
                BIT UI_ANIMATION_MODE_PING_PONG_BIT, (IX + FObjectUI.Layer.Flags)
                JR Z, .AnimLast                                                 ; переход к последнему кадру при циклическом проигрывании

                RES UI_ANIMATION_MODE_REVERSE_BIT, (IX + FObjectUI.Layer.Flags) ; изменение направления проигрывания на прямое
                INC A                                                           ; переход к следующему кадру без повторения первого
                JR .AnimStore

.AnimDecrement  ; переход к предыдущему кадру
                DEC A
                JR .AnimStore

.AnimFirst      ; переход к первому кадру диапазона
                LD A, D
                JR .AnimStore

.AnimLast       ; переход к последнему кадру диапазона
                LD A, E

.AnimStore      ; сохранение нового кадра и обновление UI объекта
                LD (IX + FObject.Sprite), A
; -----------------------------------------
; пометка UI объекта для обновления
; In:
;   IX - адрес структуры объекта (FObjectUI)
; Out:
; Corrupt:
; Note:
;   флаг заставляет рендер обновить область предыдущего bound и заново вывести UI
;
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.MarkDirty:   ; установить флаг, объект требуется обновиться
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)                      ; установить флаг, объект требуется обновить
                RET

                endif ; ~_TICK_OBJECT_UI_

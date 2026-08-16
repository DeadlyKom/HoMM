
                ifndef _TICK_OBJECT_UI_
                define _TICK_OBJECT_UI_
; -----------------------------------------
; обработчик тика объекта "UI"
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   C  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   F' - Carry установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   все регистры, кроме IX
; Note:
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI:             ; проверка наличия объекта привязки
                LD A, (IX + FObjectUI.Anchor)
                CP UI_ANCHOR_NONE
                JR Z, .Countdown                                                ; переход к отсчёту Lifetime, если объект привязки отсутствует

                ; ----------------------------------------
                ; обновление положения UI объекта
                ; ----------------------------------------

                ; получение объекта привязки
                CALL Object.Utilities.GetAdr.IY

                ; синхронизация чанка UI с чанком объекта привязки
                PUSH BC                                                         ; сохранение относительного временного шага
                PUSH IY                                                         ; сохранение адреса объекта привязки
                LD A, (IY + FObject.Chunk)
                CALL Object.Utilities.UpdateChunk
                POP IY                                                          ; восстановление адреса объекта привязки
                POP BC                                                          ; восстановление относительного временного шага

                ; ----------------------------------------
                ; обработка поведения UI объекта
                ; ----------------------------------------

                ; получение настроек UI объекта
                LD A, (IX + FObject.Settings)
                CALL Object.Utilities.GetSettingsAdr.HL
                INC L                                                           ; пропуск FObjectDefaultSettings.Class
                INC L                                                           ; пропуск FObjectDefaultSettings.Flags
                INC L                                                           ; пропуск FObjectDefaultSettings.Variable_A
                INC L                                                           ; пропуск FObjectDefaultSettings.Variable_B

                ; проверка поддержки hover-поведения
                BIT OBJECT_UI_HOVER_BIT, (HL)                                   ; FODS_UI.Flags
                JR Z, .Countdown                                                ; переход к отсчёту для обычного временного UI

                ; проверка попадания курсора в bound объекта привязки
                BIT OBJECT_CURSOR_HIT_STATE_BIT, (IY + FObject.Flags)
                JR Z, .Countdown                                                ; переход к отсчёту, если курсор покинул объект привязки

                ; обновление времени жизни hover UI
                DEC L                                                           ; переход к FObjectDefaultSettings.Variable_B
                DEC L                                                           ; переход к FObjectDefaultSettings.Variable_A
                LD A, (HL)
                LD (IX + FObjectUI.Lifetime), A
                JR .Dirty

.Countdown      ; ----------------------------------------
                ; обработка времени жизни UI объекта
                ; ----------------------------------------

                ; проверка неограниченного времени жизни
                LD A, (IX + FObjectUI.Lifetime)
                OR A                                                            ; UI_LIFETIME_INFINITE
                JR Z, .Dirty                                                    ; переход, если время жизни бесконечно

                LD E, A                                                         ; сохранение текущего времени жизни

                ; расчёт временного шага: 1, 2 или 4
                LD A, #02
                SUB C
                LD (.Jump), A
                LD A, #FF   ; x1
.Jump           EQU $+1
                JR $
                ADD A, A    ; x4
                ADD A, A    ; x2

                ; уменьшение времени жизни
                ADD A, E
                JR Z, .PendingKill                                              ; переход, если время жизни закончилось
                JR NC, .PendingKill                                             ; переход, если время жизни меньше нуля
                LD (IX + FObjectUI.Lifetime), A
                JR .Dirty

.PendingKill    LD (IX + FObjectUI.Lifetime), UI_LIFETIME_INFINITE
                SET OBJECT_PENDING_KILL_STATE_BIT, (IX + FObject.Flags)         ; объект помечен на удаление

.Dirty          ; ToDo: временное обновление UI каждый тик необходимо для обработки старого bound;
                ;       заменить установкой флага при изменении объекта привязки или отображения UI
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)                     ; установить флаг, объект требуется обновиться
                RET

                endif ; ~_TICK_OBJECT_UI_

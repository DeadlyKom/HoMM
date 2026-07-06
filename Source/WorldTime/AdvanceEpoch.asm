
                ifndef _WORLD_TIME_ADVANCE_EPOCH_
                define _WORLD_TIME_ADVANCE_EPOCH_
; -----------------------------------------
; начало новой cadence-эпохи
; In:
; Out:
; Corrupt:
;   HL, DE, BC, IX, AF
; Note:
;   вызывается только на переходе CadenceStep 7 -> 0;
;   если остались запрошенные "мировые тики", новая эпоха продвигает игровое время
;   с масштабом до GameConfig.PlaybackSpeed без повторного обхода планировщика
; ----------------------------------------
AdvanceEpoch:   ; сброс флага, активной фазы предыдущей cadence-эпохи
                LD HL, GameSession.WorldTimeCtrl + FWorldTimeControl.Flags
                RES WORLD_EPOCH_ACTIVE_BIT, (HL)

                ; проверка количества ожидающих "мировых тиков"
                LD HL, (GameSession.WorldTimeCtrl + FWorldTimeControl.AdvanceLeft)
                LD A, H
                OR L
                RET Z                                                           ; выход, если ожидающие "мировые тики" отсутствуют

                ; расчёт масштаба текущей cadence-эпохи и остатка запроса:
                ;   PlaybackScale = min(AdvanceLeft, PlaybackSpeed)
                ;   AdvanceLeft  -= PlaybackScale
                LD A, (GameConfig.PlaybackSpeed)
                ifdef _DEBUG

                OR A
                DEBUG_BREAK_POINT_Z                                             ; произошла ошибка!
                endif
                LD C, A                                                         ; сохранение PlaybackSpeed для полного пакета
                LD E, A
                LD D, #00                                                       ; DE - 16-битное значение PlaybackSpeed

                ; проверка достаточности оставшихся "мировых тиков" для полного пакета
                OR A                                                            ; сброс Carry перед вычитанием
                SBC HL, DE
                JR NC, .FullScale                                               ; переход, если AdvanceLeft не меньше PlaybackSpeed

                ; формирование неполного пакета из остатка запроса
                ADD HL, DE                                                      ; восстановить остаток запроса
                LD A, L                                                         ; остаток меньше PlaybackSpeed и помещается в байт
                LD HL, #0000                                                    ; запрос полностью исчерпан
                JR .StoreScale                                                 ; переход к сохранению рассчитанных значений

.FullScale      ; формирование полного пакета с сохранением остатка запроса
                LD A, C                                                         ; A - PlaybackScale, HL - новый AdvanceLeft

.StoreScale     ; сохранение масштаба эпохи и остатка запроса
                LD (GameSession.WorldTimeCtrl + FWorldTimeControl.PlaybackScale), A
                LD (GameSession.WorldTimeCtrl + FWorldTimeControl.AdvanceLeft), HL

                ; включить активную фазу "мирового тика" для новой cadence-эпохи
                LD HL, GameSession.WorldTimeCtrl + FWorldTimeControl.Flags
                SET WORLD_EPOCH_ACTIVE_BIT, (HL)

                ; календарь получает весь пакет без повторного обхода мира
                LD B, A
                LD IX, GameSession.WorldTime
.TickCalendar   PUSH BC
                CALL Tick
                POP BC

                ; проверка завершения обработки пакета "мировых тиков"
                DJNZ .TickCalendar                                              ; переход, если пакет "мировых тиков" обработан не полностью
                RET
; -----------------------------------------
; запрос на прокрутку игрового времени
; In:
;   HL - продолжительность в "мировых тиках"
; Out:
; Corrupt:
; Note:
;   заменяет оставшееся время текущего запроса;
;   длительности параллельных действий здесь не складываются
; ----------------------------------------
RequestAdvance: LD (GameSession.WorldTimeCtrl + FWorldTimeControl.AdvanceLeft), HL
                RET
; -----------------------------------------
; остановка дальнейшей прокрутки игрового времени
; In:
; Out:
; Corrupt:
;   HL
; Note:
;   уже выполненные изменения не откатываются;
;   активная фаза не прерывается: текущий "мировой тик" получат все диапазоны
; ----------------------------------------
StopAdvance:    LD HL, #0000
                LD (GameSession.WorldTimeCtrl + FWorldTimeControl.AdvanceLeft), HL
                RET
; -----------------------------------------
; завершение активной фазы "мирового тика"
; In:
; Out:
; Corrupt:
; Note:
;   сохраняет HL и AF, чтобы вызываться из шага планировщика;
;   вызывается после полного завершения CadenceStep 4
; ----------------------------------------
CloseEpoch:     PUSH HL
                LD HL, GameSession.WorldTimeCtrl + FWorldTimeControl.Flags
                RES WORLD_EPOCH_ACTIVE_BIT, (HL)
                POP HL
                RET

                endif ; ~_WORLD_TIME_ADVANCE_EPOCH_

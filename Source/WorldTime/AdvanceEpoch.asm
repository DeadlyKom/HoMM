
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
;   на пакет до WORLD_TICK_PLAYBACK_SPEED тиков без повторного обхода планировщика
; ----------------------------------------
AdvanceEpoch:   ; сброс флага, активной фазы предыдущей cadence-эпохи
                LD HL, GameSession.WorldTimeCtrl + FWorldTimeControl.Flags
                RES WORLD_EPOCH_ACTIVE_BIT, (HL)
                XOR A
                LD (GameSession.WorldTimeCtrl + FWorldTimeControl.Delta), A

                ; проверка количества ожидающих "мировых тиков"
                LD HL, (GameSession.WorldTimeCtrl + FWorldTimeControl.AdvanceLeft)
                LD A, H
                OR L
                RET Z

                ; за одну эпоху обработать не больше WORLD_TICK_PLAYBACK_SPEED;
                ; последний пакет может содержать меньшее число "мировых тиков"
                LD DE, WORLD_TICK_PLAYBACK_SPEED
                OR A
                SBC HL, DE
                JR NC, .FullDelta
                ADD HL, DE                                                      ; восстановить остаток запроса
                LD A, L                                                        ; остаток меньше WORLD_TICK_PLAYBACK_SPEED и помещается в байт
                LD HL, #0000
                JR .StoreDelta

.FullDelta      LD A, WORLD_TICK_PLAYBACK_SPEED
.StoreDelta     LD (GameSession.WorldTimeCtrl + FWorldTimeControl.Delta), A
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
                DJNZ .TickCalendar
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

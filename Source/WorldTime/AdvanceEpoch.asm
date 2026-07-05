
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
;   ровно на один "мировой тик"
; ----------------------------------------
AdvanceEpoch:   ; сброс флага, активной фазы предыдущей cadence-эпохи
                LD HL, GameSession.WorldTimeCtrl + FWorldTimeControl.Flags
                RES WORLD_EPOCH_ACTIVE_BIT, (HL)

                ; проверка и уменьшение количества ожидающих "мировых тиков"
                LD HL, (GameSession.WorldTimeCtrl + FWorldTimeControl.AdvanceLeft)
                LD A, H
                OR L
                RET Z
                DEC HL
                LD (GameSession.WorldTimeCtrl + FWorldTimeControl.AdvanceLeft), HL

                ; включить активную фазу "мирового тика" для новой cadence-эпохи
                LD HL, GameSession.WorldTimeCtrl + FWorldTimeControl.Flags
                SET WORLD_EPOCH_ACTIVE_BIT, (HL)

                LD IX, GameSession.WorldTime
                JP Tick
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

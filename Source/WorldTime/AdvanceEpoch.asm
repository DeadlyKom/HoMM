
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
;   каждая новая эпоха продвигает игровое время
;   с масштабом GameConfig.PlaybackSpeed без повторного обхода планировщика
; ----------------------------------------
AdvanceEpoch:   ; чтение скорости проигрывания
                LD A, (GameConfig.PlaybackSpeed)

                ifdef _DEBUG
                OR A
                DEBUG_BREAK_POINT_Z                                             ; произошла ошибка!
                endif

                ; сохранить масштаб текущей cadence-эпохи
                LD (GameSession.WorldTimeCtrl + FWorldTimeControl.PlaybackScale), A

                ; включить фазу "мирового тика" и запросить обновление фазы суток
                SET_WORLD_CHRONO_FLAGS WORLD_EPOCH_ACTIVE | WORLD_DAY_PHASE_UPDATE

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
; завершение активной фазы "мирового тика"
; In:
; Out:
; Corrupt:
; Note:
;   сохраняет HL и AF, чтобы вызываться из шага планировщика;
;   вызывается после полного завершения CadenceStep 4
; ----------------------------------------
CloseEpoch:     PUSH HL
                RES_WORLD_CHRONO_FLAG WORLD_EPOCH_ACTIVE_BIT                    ; сброс флага активной фазы "мирового тика"
                POP HL
                RET

                endif ; ~_WORLD_TIME_ADVANCE_EPOCH_

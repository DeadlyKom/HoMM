
                ifndef _WORLD_TIME_GET_TICK_FOR_CADENCE_
                define _WORLD_TIME_GET_TICK_FOR_CADENCE_
; -----------------------------------------
; определение наличия "мирового тика" в текущем cadence-проходе
; In:
; Out:
;   A - #B7: код команды OR A, если "мировой тик" отсутствует
;       #37: код команды SCF,  если "мировой тик" присутствует
; Corrupt:
;   AF
; Note:
;   при активной фазе каждый диапазон один раз получает масштаб мирового времени cadence-эпохи
;   при установленном флаге фактически применённый масштаб хранится в FWorldTimeControl.PlaybackScale:
;     CadenceStep 1 -> диапазон 1/2
;     CadenceStep 2 -> диапазон 1/4
;     CadenceStep 4 -> диапазон 1/8
; ----------------------------------------
IsWorldTick:    ; проверка активной фазы "мирового тика"
                LD A, (GameSession.WorldTimeCtrl + FWorldTimeControl.Flags)
                AND WORLD_EPOCH_ACTIVE
                LD A, #B7                                                       ; OR A - сбросить Carry
                RET Z

                ; проверка cadence-прохода в пределах [0..7]
                LD A, (TickScheduler.Variables + FTickScheduler.CadenceStep)
                DEC A                                                           ; 1
                JR Z, .WorldTick
                DEC A                                                           ; 2
                JR Z, .WorldTick
                CP #02                                                          ; 4
                JR Z, .WorldTick
                LD A, #B7                                                       ; OR A - сбросить Carry
                RET

.WorldTick      LD A, #37                                                       ; SCF - установить Carry
                RET

                endif ; ~_WORLD_TIME_GET_TICK_FOR_CADENCE_


                ifndef _TICK_OBJECT_UI_UPDATE_LIFETIME_
                define _TICK_OBJECT_UI_UPDATE_LIFETIME_
; -----------------------------------------
; обновление времени жизни UI объекта
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   C  - диапазон cadence: 0 - 1/2, 1 - 1/4, 2 - 1/8
;   F' - флаг переполнения установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
; Corrupt:
;   HL, DE, AF
; Note:
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.UpdateLifetime:
                ; проверка неограниченного времени жизни
                LD A, (IX + FObjectUI.Lifetime)
                OR A                                                            ; UI_LIFETIME_INFINITE
                RET Z                                                           ; выход, если время жизни бесконечно

                LD E, A                                                         ; сохранение текущего времени жизни

                ; расчёт временного шага: -1, -2 или -4
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
                RET

.PendingKill    ; обнуляем Lifetime и откладываем безопасное удаление до завершения тика объекта
                LD (IX + FObjectUI.Lifetime), UI_LIFETIME_INFINITE
                SET OBJECT_PENDING_KILL_STATE_BIT, (IX + FObject.FastFlags)     ; объект помечен на удаление
                RET

                endif ; ~_TICK_OBJECT_UI_UPDATE_LIFETIME_

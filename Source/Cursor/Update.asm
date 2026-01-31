
                ifndef _CURSOR_UPDATE_
                define _CURSOR_UPDATE_
; -----------------------------------------
; обновление курсора
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Update:         LD IX, UI_Cursor.CurrentState

                ; проверка состояния курсора
                LD A, (IX + FCursorState.State)
                OR A                                                            ; CURSOR_STATE_NONE
                JR NZ, .StateTick

                ; состояние курсора отсутствует

                ; проверка нажатия клавиши "выбор"
                LD A, (GameState.Input.Value)
                BIT SELECT_KEY_BIT, A
                LD A, CURSOR_STATE_CLICK
                JR NZ, .SetState_A                                              ; переход, была нажата клавиша "выбор"

                ; проверка бездействия курсора
                LD A, (Mouse.PositionFlag)                                      ; если курсор не поменяет позицию, хранит #FF
                OR A
                JR Z, .SetState_Idle                                            ; переход, если курсор переместился

.StateTick      ; уменьшение счётчика
                DEC (IX + FCursorState.Counter)
                SCF                                                             ; установик флаг отображения курсора
                RET NZ                                                          ; выход, если счётчик бездействия курсора не обнулён

                ; счётчик времени достик нуля,
                ; необходимо перейти к следующему кадру
                LD A, (IX + FCursorState.SpriteIndex)
                ADD A, (IX + FCursorState.Direction)
                JP M, .SetState_Idle                                            ; переход, если достигли последнего кадра анимации flip-flop

                ; проверка достижения максимального кадра
                CP (IX + FCursorState.IndexMax)
                JR NZ, .SetAnimIndex                                            ; переход, если не достигли максимальный кадр анимации

                ; достигли максимальный кадр анимации,
                ; необходимо сменить направление анимации
                LD (IX + FCursorState.Direction), CURSOR_ANIMATION_BACK
                JR .SetSubcounter

.SetState_Idle  LD A, CURSOR_STATE_IDLE
.SetState_A     CALL Initialize.SetState
                SCF                                                             ; установик флаг отображения курсора
                RET

.SetAnimIndex   ; сохранение индекса анимации
                LD (IX + FCursorState.SpriteIndex), A

.SetSubcounter  ; установка промежуточного счётчика
                LD (IX + FCursorState.Counter), DURATION.DELAY_CURSOR
                SCF                                                             ; установик флаг отображения курсора
                RET

                endif ; ~_CURSOR_UPDATE_

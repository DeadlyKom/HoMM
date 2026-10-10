
                ifndef _TICK_UTILS_RECONNAISSANCE_
                define _TICK_UTILS_RECONNAISSANCE_
; -----------------------------------------
; создать событие разведки для группы владельца персонажа
; In:
;   IX - адрес объекта персонажа (FObjectCharacter)
;   DE - координаты разведки (D - Y, E - X)
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   HL, DE, BC, AF, AF', IY
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
Request:        ; ToDo: учесть модификатор разведки гексагонального тайла
                ;       из Adr.SurfProperty и дополнительные корректировки
                ;       от навыков персонажа, их состав и порядок пока неизвестны

                ; получение идентификатора владельца персонажа
                LD A, (IX + FObjectCharacter.CharacterID)
                CALL Character.Utilities.GetAdr.HL                              ; получение адреса персонажа
                INC L                                                           ; пропуск FCharacter.Class
                INC L                                                           ; пропуск FCharacter.RepresentID
                LD A, (HL)                                                      ; FCharacter.ParticipantID

                ; получение группы владельца
                CALL Participant.Utilities.GetAdr.HL                            ; получение адреса участника
                LD A, (HL)                                                      ; FParticipant.Faction.Flags
                AND PLAYER_GROUP_MASK
.Group          EX AF, AF'                                                      ; сохранение группы владельца персонажа

                ; определение радиуса рекогносцировки
                CALL Character.Utilities.GetViewRadius                          ; получение радиуса обзора персонажа
                LD (Adr.EventBuffer + FEventReconnaissance.Radius), A           ; сохранение радиуса обзора в событии

                ; создание события рекогносцировки для группы
                LD HL, Adr.EventBuffer
                LD (HL), EVENT_BEFORE_RENDER | EVENT_LIFETIME_CONDITION         ; FEventReconnaissance.Super.Flags
                INC L
                INC L
                LD (HL), Page.Page1                                             ; FEventReconnaissance.Super.Page
                INC L
                LD (HL), LOW BufferUtilities.Reconnaissance.Event               ; FEventReconnaissance.Super.Function + 0
                INC L
                LD (HL), HIGH BufferUtilities.Reconnaissance.Event              ; FEventReconnaissance.Super.Function + 1
                INC L
                EX AF, AF'                                                      ; восстановление группы владельца персонажа
                LD (HL), A                                                      ; FEventReconnaissance.Group
                INC L
                LD (HL), E                                                      ; FEventReconnaissance.Position.X
                INC L
                LD (HL), D                                                      ; FEventReconnaissance.Position.Y
                JP Event.Add

                endif ; ~_TICK_UTILS_RECONNAISSANCE_

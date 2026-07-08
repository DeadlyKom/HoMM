
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
;   код расположен в странице 0
; -----------------------------------------
Request:        ; получить ParticipantID владельца объекта
                LD A, (IX + FObjectCharacter.CharacterID)
                CALL Character.Utilities.GetAdr.HL                              ; получить адрес персонажа
                INC HL
                LD A, (HL)                                                      ; FCharacter.ParticipantID

                ; получить группу владельца
                CALL Participant.Utilities.GetAdr.HL                            ; получить адрес участника

                LD A, (HL)                                                      ; FParticipant.Faction.Flags
                AND PLAYER_GROUP_MASK

.Group          ; расчёт адреса группы в таблицы
                ADD A, LOW .FogBitTable
                LD L, A
                ADC A, HIGH .FogBitTable
                SUB L
                LD H, A
                LD A, (HL)                                                      ; чтение номера бита из таблицы

                ; сформировать событие
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
                LD (HL), A                                                      ; FEventReconnaissance.FogBit
                INC L
                LD (HL), E                                                      ; FEventReconnaissance.Position.X
                INC L
                LD (HL), D                                                      ; FEventReconnaissance.Position.Y
                JP Event.Add

.FogBitTable    DB MAP_META_FOG_PLAYER_1_BIT
                DB MAP_META_FOG_PLAYER_2_BIT
                DB MAP_META_FOG_PLAYER_3_BIT
                DB MAP_META_FOG_PLAYER_4_BIT

                endif ; ~_TICK_UTILS_RECONNAISSANCE_

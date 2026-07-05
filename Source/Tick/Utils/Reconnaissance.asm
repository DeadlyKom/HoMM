
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
; -----------------------------------------
Request:        PUSH DE                                                         ; сохранить координаты разведки

                ; получить ParticipantID владельца объекта
                LD L, (IX + FObjectCharacter.CharacterID)
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32
                LD DE, Adr.CharacterArray
                ADD HL, DE
                INC HL                                                          ; FCharacter.ParticipantID
                LD A, (HL)

                ; получить группу владельца
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32
                LD DE, Adr.ParticipantArray
                ADD HL, DE
                LD A, (HL)
                AND PLAYER_GROUP_MASK
                LD D, A                                                         ; группа владельца

                ; собрать маску видимости всех участников той же группы
                LD A, (GameSession.SaveSlot + FSaveSlot.MapInfo.Participants)
                LD B, A
                LD C, #00                                                       ; ParticipantID
                LD E, #00                                                       ; результирующая маска
                LD HL, Adr.ParticipantArray

.ParticipantLoop
                LD A, (HL)
                AND PLAYER_GROUP_MASK
                CP D
                JR NZ, .NextParticipant

                PUSH HL
                LD A, C
                LD HL, .FogMaskTable
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A
                LD A, (HL)
                OR E
                LD E, A
                POP HL

.NextParticipant
                LD A, L
                ADD A, PARTICIPANT_SIZE
                LD L, A
                JR NC, $+3
                INC H
                INC C
                DJNZ .ParticipantLoop

                ; сформировать событие
                LD IY, Adr.EventBuffer
                LD (IY + FEventReconnaissance.Super.Flags), EVENT_BEFORE_RENDER | EVENT_LIFETIME_CONDITION
                LD (IY + FEventReconnaissance.Super.Page), Page.Page1
                LD (IY + FEventReconnaissance.Super.Function + 0), LOW BufferUtilities.Reconnaissance.Event
                LD (IY + FEventReconnaissance.Super.Function + 1), HIGH BufferUtilities.Reconnaissance.Event
                LD (IY + FEventReconnaissance.FogMask), E
                POP DE
                LD (IY + FEventReconnaissance.Position.X), E
                LD (IY + FEventReconnaissance.Position.Y), D
                JP Event.Add

.FogMaskTable   DB MAP_META_FOG_PLAYER_1_MASK
                DB MAP_META_FOG_PLAYER_2_MASK
                DB MAP_META_FOG_PLAYER_3_MASK
                DB MAP_META_FOG_PLAYER_4_MASK

                endif ; ~_TICK_UTILS_RECONNAISSANCE_


                ifndef _PARTICIPANT_ADD_PLAYER_
                define _PARTICIPANT_ADD_PLAYER_
; -----------------------------------------
; добавить игрока
; In:
;   IX - указатель на адрес структуры FParticipantSettings
;   C  - индекс добавляемого игрока
; Out:
;   флаг переполнения Carry установлен, 
;   в случае успешного добавления персонажа с первым героем
; Corrupt:
; Note:
; -----------------------------------------
Add_Player:     ;---------------------------------------------------------------
                ; расчёт адреса распологаемого игрока
                ; IY = PARTICIPANT_SIZE * индекс добовляемого игрока (8)
                LD A, C
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                ADD A, A    ; x32
                LD IYL, A
                LD IYH, HIGH Adr.ParticipantArray
                ;---------------------------------------------------------------
                ; инициализация FParticipant

                ; флаги принадлежности участника
                LD A, (IX + FParticipantSettings.Faction)
                LD (IY + FParticipant.Faction), A

                ; идентификатор стартового замка
                LD A, (IX + FParticipantSettings.CastleID)
                LD (IY + FParticipant.CastleID), A

                ; инициализация массива идентификаторов ID героев данного участника
                LD (IY + FParticipant.HeroesNum), #00
                ;---------------------------------------------------------------
                ; расчтёт адреса структуры FHeroSettings
                ; DE = IX + FParticipantSettings.Hero
                PUSH IX
                POP HL
                LD DE, FParticipantSettings.Hero
                ADD HL, DE
                EX DE, HL

                ; стартовая позиция игрока
                LD HL, (IX + FParticipantSettings.HeroLocation)
                ; JP Add_Hero

                display " - Add player:\t\t\t\t\t", /A, Add_Player, "\t= busy [ ", /D, $-Add_Player, " byte(s)  ]"

                endif ; ~_PARTICIPANT_ADD_PLAYER_

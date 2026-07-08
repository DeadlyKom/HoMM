
                ifndef _PARTICIPANT_ADD_CHARACTER_
                define _PARTICIPANT_ADD_CHARACTER_
; -----------------------------------------
; добавить персонажа
; In:
;   HL - стартовая позиция игрока
;   DE - указатель на адрес структуры FCharacterSettings
;   IY - указатель на адрес структуры FParticipant
;   C  - идентификатор владельца героем
; Out:
;   флаг переполнения Carry установлен,
;   в случае успешного добавления персонажа
; Corrupt:
; Note:
;   код расположен в странице 0
; -----------------------------------------
Add_Character:  ; проверка достижения максимального количества игроков
                LD A, (IY + FParticipant.CharactersNum)                         ; получение индекса доступного элемента в массиве героев у игрока
                CP MAX_PARTICIPANT_CHARACTERS
                RET NC                                                          ; выход, если массив переполнен

                PUSH HL                                                         ; сохранение стартовой позиции игрока
                ; проверка переполнения массива Adr.CharacterArray не требуется, т.к.
                ; позволяет вместить максимальное количество героев для каждого игрока
                LD HL, GameSession.WorldInfo + FWorldInfo.HeroNum
                LD B, (HL)                                                      ; чтение свободного идентификатора персонажа
                INC (HL)                                                        ; увеличение общего счётчика героев в массиве Adr.CharacterArray
                PUSH BC                                                         ; сохранение CharacterID и ParticipantID до спавна объекта
                ;--------------------------------------
                ; добавление CharacterID в массив персонажей участника
                PUSH IY
                POP HL
                PUSH BC                                                         ; сохранить CharacterID и ParticipantID
                LD BC, FParticipant.Characters
                ADD HL, BC
                POP BC

                LD A, (IY + FParticipant.CharactersNum)                        ; индекс персонажа внутри массива участника
                ADD A, L
                LD L, A
                LD (HL), B                                                      ; добавить CharacterID персонажа участнику
                INC (IY + FParticipant.CharactersNum)                           ; увеличение счётчика персонажей у игрока
                ;---------------------------------------------------------------
                LD A, B
                CALL Character.Utilities.GetAdr.HL                              ; получить адрес персонажа
                ; инициализация FCharacter
                LD A, (DE)
                INC DE
                LD (HL), A                                                      ; FCharacter.Class
                INC L
                LD (HL), C                                                      ; FCharacter.ParticipantID
                INC L
                EX DE, HL
                LD BC, FCharacterSkills
                CALL Memcpy.FastLDIR                                            ; копирование FCharacter.Skills
                EX DE, HL
                ; обнуление FCharacter.CombatStates и FCharacter.Equipment
                XOR A
                LD B, FCombatStates + FCharacterEquipment
.ClearLoop      LD (HL), A
                INC L
                DJNZ .ClearLoop
                ; -----------------------------------------
                ; спавн объекта
                ; In:
                ;   B  - тип объекта (настройки по умолчанию)
                ;   DE - положение объекта в знакоместах (D - y, E - x)
                ; Out:
                ;   A' - идентификатор объекта
                ;   IX - адрес структуры FObjectDefaultSettings
                ;   IY - адрес структуры FObject (FObjectCharacter)
                ;   флаг переполнения Carry установлен, если нет свободного места в массиве
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; Note:
                ; -----------------------------------------
                POP BC                                                          ; восстановление идентификатора персонажа и участника

                ; тип объекта определяется принадлежностью участника
                LD A, (IY + FParticipant.Faction.Flags)
                AND COMPUTER
                EXX
                LD B, ODS_ID_CHARACTER
                JR Z, .Spawn
                LD B, ODS_ID_AI_CHARACTER
.Spawn
                POP DE                                                          ; восстановление стартовой позиции игрока
                CALL Object.Spawn
                EXX
                JR C, .Exit                                                     ; переход, если была ошибка
                                                                                ; пропус инициализации объекта
                LD (IY + FObjectCharacter.CharacterID), B                       ; установка идентификатора владельца
                EX AF, AF'
                LD (HL), A                                                      ; FCharacter.ObjectID
                EX AF, AF'

.Exit           CCF                                                             ; инверсия флага, после спавна персонажа
                                                                                ; см. описание спавна
                RET

                display " - Add character:\t\t\t\t\t", /A, Add_Character, "\t= busy [ ", /D, $-Add_Character, " byte(s)  ]"

                endif ; ~_PARTICIPANT_ADD_CHARACTER_

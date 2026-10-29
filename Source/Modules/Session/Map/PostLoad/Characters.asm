
                ifndef _MODULE_SESSION_MAP_POST_LOAD_CHARACTERS_
                define _MODULE_SESSION_MAP_POST_LOAD_CHARACTERS_
; -----------------------------------------
; создание и инициализация тестовых персонажей
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Characters:     ; создание тестовых участников и персонажей
                ; из загруженного массива информации о картах FMapInfo.
                ; пользователь выбирет необходимую или по сюжету будет выбрана подходящая.
                ; из структуры FMapInfo можно понять количество участников, а также
                ; пользователь должен настроить кто за кого играет компьютер/человек и в каких группах
                ; заполенняя массив участников структур FParticipantSettings,
                ; размер массива храниться в GameSession.SaveSlot + FSaveSlot.MapInfo.Participants

                LD A, #01
                LD (GameSession.SaveSlot + FSaveSlot.MapInfo.Participants), A
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                LD IX, .TmpParticipant                                          ; адрес расположения массива FParticipantSettings
                CALL Participant.Append                                         ; добавить участников

                ; назначение тестовой экипировки главному персонажу
                LD A, PLAYER_CHARACTER_ID_MAIN
                CALL Character.Utilities.GetAdr.IX
                LD (IX + FCharacter.Equipment.Amulet.ID), #00
                LD (IX + FCharacter.Equipment.Breast.ID), #03

                ; -----------------------------------------
                ; ToDo: отладочная установка активного игрока
                LD A, PLAYER_CHARACTER_ID_MAIN
                LD (GameState.PlayerActions + FPlayerActions.SelectedHeroID), A
                LD A, PLAYER_ACTION_NONE
                LD (GameState.PlayerActions + FPlayerActions.Action), A
                ; -----------------------------------------

                ifdef ENABLE_DEBUG_AI_MOVEMENT
                CALL SpawnUnits                                                 ; спавн тестовых AI-агенты по карте
                endif

                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами

                ; проверка наличия персонажей для первичной рекогносцировки
                LD A, (GameSession.WorldInfo + FWorldInfo.HeroNum)
                OR A
                RET Z                                                           ; выход, если персонажи отсутствуют
                LD B, A
                LD C, #00

                ; --------------------------------------------------------------

.ReconLoop      PUSH BC                                                         ; сохранение счётчика и идентификатора персонажа

                ; получение координат персонажа
                LD A, C
                ; -----------------------------------------
                ; получить позицию персонажа в гексагонах
                ; In:
                ;   A  - индекс персонажа (CharacterID)
                ; Out:
                ;   DE - координаты персонажа (D - y, E - x) в гексах
                ; Corrupt:
                ;   HL, DE, AF, IX, IY
                ; -----------------------------------------
                CALL Character.Utilities.GetPosHexagon

                ; получение радиуса обзора персонажа
                CALL Character.Utilities.GetViewRadius                          ; получение радиуса обзора персонажа
                EX AF, AF'                                                      ; сохранение радиуса обзора до переключения страницы

                ; получение группы владельца персонажа
                LD A, (IX + FCharacter.ParticipantID)
                ; -----------------------------------------
                ; получить адрес участника
                ; In:
                ;   A  - идентификатор участника
                ; Out:
                ;   HL - адрес структуры участника (FParticipant)
                ; Corrupt:
                ;   HL, AF
                ; -----------------------------------------
                CALL Participant.Utilities.GetAdr.HL

                LD A, (HL)
                AND PLAYER_GROUP_MASK
                LD L, A                                                         ; сохранение группы перед переключением страницы

                ; получение номера бита разведки группы
                SET_PAGE_MAP                                                    ; включить страницу работы с картой
                LD A, L
                ; -----------------------------------------
                ; получение номера бита разведки группы
                ; In:
                ;   A - номер группы
                ; Out:
                ;   C - номер бита разведки
                ; Corrupt:
                ;   HL, AF
                ; -----------------------------------------
                CALL BufferUtilities.GetFogBit

                ; первичная рекогносцировка в позиции персонажа
                EX AF, AF'                                                      ; восстановление радиуса обзора персонажа
                ; -----------------------------------------
                ; рекогносцировка
                ; In:
                ;   A  - радиус обзора в тайлах
                ;   C  - номер бита туман отвечающий за игрока
                ;   DE - координаты в тайлах (D - y, E - x)
                ; -----------------------------------------
                CALL BufferUtilities.Reconnaissance

                ; следующий персонаж
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                POP BC
                INC C
                DJNZ .ReconLoop
                RET

.TmpParticipant FParticipantSettings {
                    { HUMANOID | PLAYER_GROUP_0 },                              ; фракция участника
                    CASTLE_ID_NONE,                                             ; идентификатор стартового замка
                    { 5, 8 },                                                   ; стартовая позиция игрока

                    ; настройки стартового героя участника
                    ; FCharacterSettings
                    {
                        Character.Gender.Male | \
                        Character.Class.Druid,                                  ; гендер и класс героя
                        REPRESENT_ID_DRUID,                                     ; представление героя
                        ; навыки героя
                        ; FCharacterSkills
                        {
                            ; основные навыки
                            ; FPrimarySkill
                            {
                                3,                                              ; навык атаки
                                1,                                              ; навык защиты
                                4,                                              ; сила заклинаний
                                2                                               ; навык знаний
                            },
                            ; вторичные навыки
                            ; FSecondarySkill
                            {
                                SKILL_LEVEL_NONE                                ; Pathfinding, эксперт
                            }
                        }
                    }
                }

                ifdef ENABLE_DEBUG_AI_MOVEMENT
AI_UNIT_COUNT   EQU 1
SpawnUnits:     LD IX, .AIAgent
                LD HL, .ChunkPositions
                LD B, AI_UNIT_COUNT
                LD C, #01                                                       ; участник 0 уже занят игроком

                LD A, AI_UNIT_COUNT + 1
                LD (GameSession.SaveSlot + FSaveSlot.MapInfo.Participants), A

.SpawnLoop      ; установка координат спавна
                LD A, (HL)
                LD (IX + FParticipantSettings.HeroLocation.X), A
                INC HL
                LD A, (HL)
                LD (IX + FParticipantSettings.HeroLocation.Y), A
                INC HL

                PUSH BC
                PUSH HL
                CALL Participant.Add_Player                                     ; добавить тестового AI-участника
                POP HL
                POP BC
                INC C
                DJNZ .SpawnLoop
                RET

.ChunkPositions ; позиции
                DB 3, 3

.AIAgent        FParticipantSettings {
                    { COMPUTER | PLAYER_GROUP_1 },                              ; компьютерный противник из другой группы
                    CASTLE_ID_NONE,
                    { 0, 0 },                                                   ; первая точка демонстрационного маршрута

                    ; настройки компьютерного героя участника
                    ; FCharacterSettings
                    {
                        Character.Gender.Male | \
                        Character.Class.Wizard,                                 ; гендер и класс героя
                        REPRESENT_ID_WIZARD,                                    ; представление героя
                        {
                            {
                                3,
                                1,
                                4,
                                2
                            },
                            {
                                SKILL_LEVEL_NONE                                ; Pathfinding отсутствует
                            }
                        }
                    }
                }
                endif

                endif ; ~_MODULE_SESSION_MAP_POST_LOAD_CHARACTERS_

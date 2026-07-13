
                ifndef _MAIN_MENU_MAIN_LOOP_
                define _MAIN_MENU_MAIN_LOOP_
; -----------------------------------------
; главный цикл "главного меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Loop:           
.Render         ; ************ RENDER ************
                CHECK_RENDER_FLAG FRAME_READY_BIT
                RET NZ

                ; проверка завершение цикла
                CHECK_MAIN_FLAG ML_EXIT_BIT
.FuncDraw       EQU $+1
                JP Z, $

                ; сброс флага завершение цикла
                RES_MAIN_FLAG ML_EXIT_BIT

                ; установка флагов
                SET_MAIN_FLAGS ML_TRANSITION | ML_ENTER | ML_UPDATE
                
                ;---------------------------------------------------------------
                ; загрузка сессии из слота сохраниея
                RES_USER_HANDLER                                                ; отключение обработчика прерываний
                LAUNCH_ASSET_FUNCTION_RESTORE Session.Load, ExecuteModule.Session
                ;---------------------------------------------------------------
                RES_USER_HANDLER                                                ; отключение обработчика прерываний,
                                                                                ; т.к. после возвращения исполнения функции
                                                                                ; проинициализируется модуль главного меню
                                                                                ; и адрес обработчикм прерывания будет восстановлен
                CALL Core.ReleaseAsset                                          ; заранее освобождение текущего ресурса
                CALL Content.Font.Release                                       ; освобождение ассета шрифта
                CALL Content.Portal.Release                                     ; освобождение контент данных "главного меню"
                CALL Content.Music.Release                                      ; освобождение контент данных "музыка"
                ;---------------------------------------------------------------
                ; из загруженного массива информации о картах FMapInfo.
                ; пользователь выбирет необходимую или по сюжету будет выбрана подходящая.
                ; из структуры FMapInfo можно понять количество участников, а также
                ; пользователь должен настроить кто за кого играет компьютер/человек и в каких группах
                ; заполенняя массив участников структур FParticipantSettings,
                ; размер массива храниться в GameSession.SaveSlot + FSaveSlot.MapInfo.Participants

                LD A, #01
                LD (GameSession.SaveSlot + FSaveSlot.MapInfo.Participants), A
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                LD IX, .TmpParticipant; Adr.ExtraBuffer                                          ; адрес расположения массива FParticipantSettings
                CALL Participant.Append                                         ; добавить участников

                ifdef ENABLE_DEBUG_AI_MOVEMENT
                CALL SpawnUnits                                                 ; спавн тестовых AI-агенты по карте
                endif
                ;---------------------------------------------------------------
                JP ExecuteModule.World                                          ; запуск "мира"

.TmpParticipant FParticipantSettings {
                    { HUMANOID | PLAYER_GROUP_0 },                              ; фракция участника
                    CASTLE_ID_NONE,                                             ; идентификатор стартового замка
                    { 2, 3 },                                                   ; стартовая позиция игрока

                    ; настройки стартового героя участника
                    ; FCharacterSettings
                    {
                        Character.Class.Druid,                                  ; класс героя
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

.SpawnLoop      ; установка координат спавна
                LD A, (HL)
                LD (IX + FParticipantSettings.HeroLocation.X), A
                INC HL
                LD A, (HL)
                LD (IX + FParticipantSettings.HeroLocation.Y), A
                INC HL
                
                LD A, #01
                PUSH BC
                PUSH HL
                CALL Participant.Append                                         ; добавить учасника
                POP HL
                POP BC
                DJNZ .SpawnLoop
                RET

                
.ChunkPositions ; позиции
                DB 3, 3

.AIAgent        FParticipantSettings {
                    { COMPUTER | PLAYER_GROUP_1 },                              ; компьютерный противник из другой группы
                    CASTLE_ID_NONE,
                    { 0, 0 },                                                   ; первая точка демонстрационного маршрута

                    {
                        Character.Class.Druid,
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

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_MAIN_MENU_MAIN_LOOP_

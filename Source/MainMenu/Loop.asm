
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
                ifdef ENABLE_DEBUG_AI_MOVEMENT
                LD A, #02                                                      ; игрок и тестовый компьютерный противник
                else
                LD A, #01
                endif
                LD (GameSession.SaveSlot + FSaveSlot.MapInfo.Participants), A
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                LD IX, .TmpParticipant; Adr.ExtraBuffer                                          ; адрес расположения массива FParticipantSettings
                CALL Participant.Append                                         ; добавить участников

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
                                ; ToDo: вскоре появятся....
                            }
                        }
                    }
                }

                ifdef ENABLE_DEBUG_AI_MOVEMENT
.TmpOpponent    FParticipantSettings {
                    { COMPUTER | PLAYER_GROUP_1 },                              ; компьютерный противник из другой группы
                    CASTLE_ID_NONE,
                    { 3, 3 },                                                   ; первая точка демонстрационного маршрута

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
                            }
                        }
                    }
                }
                endif

                display " - Main loop:\t\t\t\t\t\t", /A, Loop, "\t= busy [ ", /D, $-Loop, " byte(s)  ]"

                endif ; ~_MAIN_MENU_MAIN_LOOP_

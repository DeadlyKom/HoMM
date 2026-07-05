
                ifndef _STRUCTS_GAME_SESSION_
                define _STRUCTS_GAME_SESSION_

                struct FGameSession                                             ; переменные состояния сессии                                   [байт]
SaveSlotID      DB #00                                                          ; номер активного слота сохранения                              [байт]
; ToDo: SaveSlot не должен находиться в текущей структуре, так как это временная структура,
;       которая формируется после загрузки или перед сохранением соответственно.
;       При вынесении необходимо пересмотреть инициализацию зависимых полей FGameSession
SaveSlot        FSaveSlot                                                       ; временные данные слота                                        [байт]
WorldInfo       FWorldInfo                                                      ; информация о "мире"                                           [байт]
PeriodTick      FTick                                                           ; период тиков                                                  [4 байта]
WorldTime       FWorldTime                                                      ; календарное игровое время                                     [7 байт]
WorldTimeCtrl   FWorldTimeControl                                               ; управление прокруткой игрового времени                        [3 байта]

                ends

                endif ; ~_STRUCTS_GAME_SESSION_

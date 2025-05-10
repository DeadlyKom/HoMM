
                ifndef _STRUCTS_GAME_SESSION_
                define _STRUCTS_GAME_SESSION_

                struct FGameSession                                             ; переменные состояния сессии                                   [байт]
SaveSlotID      DB #00                                                          ; номер активного слота сохранения                              [байт]
SaveSlot        FSaveSlot                                                       ; информация о слоте                                            [байт]
WorldInfo       FWorldInfo                                                      ; информация о "мире"                                           [байт]
PeriodTick      FTick                                                           ; период тиков                                                  [3 байта]

                ends

                endif ; ~_STRUCTS_GAME_SESSION_

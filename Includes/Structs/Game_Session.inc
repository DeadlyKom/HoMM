
                ifndef _STRUCTS_GAME_SESSION_
                define _STRUCTS_GAME_SESSION_

                struct FGameSession                                             ; переменные состояния сессии                                   [байт]
MapInfo         FMapInfo                                                        ; информация о карте                                            [3 байт]
WorldInfo       FWorldInfo                                                      ; информация о "мире"                                           [байт]
PeriodTick      FTick                                                           ; период тиков                                                  [2 байта]

                ends

                endif ; ~_STRUCTS_GAME_SESSION_

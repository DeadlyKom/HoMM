
                ifndef _VARIABLES_GAME_SESSION_
                define _VARIABLES_GAME_SESSION_
GameSession     EQU Adr.GameSession                                             ; адрес структуры состояния сессии
.MapInfo        EQU GameSession + FGameSession.MapInfo                          ; онформация о карте структура FMapInfo
.MapSize        EQU GameSession + FGameSession.MapInfo.Size                     ; размер карты

                endif ; ~_VARIABLES_GAME_SESSION_

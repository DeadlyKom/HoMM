
                ifndef _VARIABLES_GAME_SESSION_
                define _VARIABLES_GAME_SESSION_
GameSession     EQU Adr.GameSession                                             ; адрес структуры состояния сессии
.MapInfo        EQU GameSession + FGameSession.MapInfo                          ; онформация о карте структура FMapInfo
.MapSize        EQU GameSession + FGameSession.MapInfo.Size                     ; размер карты
.MapSize.Width  EQU GameSession + FGameSession.MapInfo.Size.Width               ; размер карты по горизонтали
.MapSize.Height EQU GameSession + FGameSession.MapInfo.Size.Height              ; размер карты по вертикали
.WorldInfo      EQU GameSession + FGameSession.WorldInfo                        ; информация о "мире"
.PeriodTick     EQU GameSession + FGameSession.PeriodTick                       ; период тиков
.SaveSlot       EQU GameSession + FGameSession.SaveSlot                         ; номер слота

                endif ; ~_VARIABLES_GAME_SESSION_

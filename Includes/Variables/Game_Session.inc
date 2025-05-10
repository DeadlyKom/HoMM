
                ifndef _VARIABLES_GAME_SESSION_
                define _VARIABLES_GAME_SESSION_
GameSession     EQU Adr.GameSession                                             ; адрес структуры состояния сессии
.SaveSlot       EQU GameSession + FGameSession.SaveSlot                         ; струтура описывающая сохраняемые данные
.MapInfo        EQU GameSession + FGameSession.SaveSlot.MapInfo                 ; онформация о карте структура FMapInfo
.MapSize        EQU GameSession + FGameSession.SaveSlot.MapInfo.Size            ; размер карты
.MapSize.Width  EQU GameSession + FGameSession.SaveSlot.MapInfo.Size.Width      ; размер карты по горизонтали
.MapSize.Height EQU GameSession + FGameSession.SaveSlot.MapInfo.Size.Height     ; размер карты по вертикали
.WorldInfo      EQU GameSession + FGameSession.WorldInfo                        ; информация о "мире"
.PeriodTick     EQU GameSession + FGameSession.PeriodTick                       ; период тиков

                endif ; ~_VARIABLES_GAME_SESSION_

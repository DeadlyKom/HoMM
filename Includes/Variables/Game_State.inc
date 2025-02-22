
                ifndef _VARIABLES_GAME_STATE_
                define _VARIABLES_GAME_STATE_
GameState       EQU Adr.GameState                                               ; адрес структуры состояния игры
.Render         EQU GameState + FGameState.Render                               ; флаги отрисовки
.Screen         EQU GameState + FGameState.Screen                               ; старший бит адрес экрана
.Assets         EQU GameState + FGameState.Assets                               ; копия данных об ассете

                endif ; ~_VARIABLES_GAME_STATE_

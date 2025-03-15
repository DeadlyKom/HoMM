
                ifndef _VARIABLES_GAME_STATE_
                define _VARIABLES_GAME_STATE_
GameState       EQU Adr.GameState                                               ; адрес структуры состояния игры
.MainLoop       EQU GameState + FGameState.MainLoop                             ; флаги главного цикла
.Render         EQU GameState + FGameState.Render                               ; флаги отрисовки
.Screen         EQU GameState + FGameState.Screen                               ; старший бит адрес экрана
.Input          EQU GameState + FGameState.Input                                ; флаги ввода
.Input.Value    EQU GameState + FGameState.Input.Value                          ; дополнительный флаг (см описание в структуре)
.Input.HotKeys  EQU GameState + FGameState.Input.HotKeys                        ; флаг ввода горячих клавиш
.Input.Scroll   EQU GameState + FGameState.Input.Scroll                         ; флаги ввода скролла карты
.Assets         EQU GameState + FGameState.Assets                               ; копия данных об ассете

                endif ; ~_VARIABLES_GAME_STATE_

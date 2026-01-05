
                ifndef _VARIABLES_GAME_STATE_
                define _VARIABLES_GAME_STATE_
GameState       EQU Adr.GameState                                               ; адрес структуры состояния игры
.MainLoop       EQU GameState + FGameState.MainLoop                             ; флаги главного цикла
.Render         EQU GameState + FGameState.Render                               ; флаги отрисовки
.Interrupt      EQU GameState + FGameState.Interrupt                            ; флаги прерывания
.Screen         EQU GameState + FGameState.Screen                               ; старший бит адрес экрана
.Input          EQU GameState + FGameState.Input                                ; флаги ввода
.Input.VK       EQU GameState + FGameState.Input.VK                             ; номер "виртуальной" клавишаи
.Input.Value    EQU GameState + FGameState.Input.Value                          ; дополнительный флаг (см описание в структуре)
.Input.HotKeys  EQU GameState + FGameState.Input.HotKeys                        ; флаг ввода горячих клавиш
.Input.Timer    EQU GameState + FGameState.Input.Timer                          ; флаги таймера ввода
.View           EQU GameState + FGameState.View                                 ; флаги вида
.Event          EQU GameState + FGameState.Event                                ; событие
.AssetID        EQU GameState + FGameState.AssetID                              ; идентификатор последнего загруженного ассета
.Assets         EQU GameState + FGameState.Assets                               ; копия данных последнего загруженного ассета
.SpriteInfoNum  EQU GameState + FGameState.SpriteInfoNum                        ; количество спрайтов в массиве SpriteInfoBuffer
.LeftEdge       EQU GameState + FGameState.LeftEdge                             ; левая грань видимой части     (в пикселах)
.VisibleWidth   EQU GameState + FGameState.VisibleWidth                         ; ширина видимой части          (в знакоместах)
.TopEdge        EQU GameState + FGameState.TopEdge                              ; верхняя грань видимой части   (в пикселах)
.VisibleHeight  EQU GameState + FGameState.VisibleHeight                        ; высота видимой части          (в пикселах)
.TickCounter    EQU GameState + FGameState.TickCounter                          ; счётчик тиков
                endif ; ~_VARIABLES_GAME_STATE_

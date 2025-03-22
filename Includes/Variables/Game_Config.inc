
                ifndef _VARIABLES_GAME_CONFIG_
                define _VARIABLES_GAME_CONFIG_
GameConfig      EQU Adr.GameConfig                                              ; адрес структуры конфигурации игры
.Keys           EQU GameConfig + FGameConfig.Keys                               ; массив клавиш
.KeyUp          EQU GameConfig + FGameConfig.Keys.Up                            ; клавиша по умолчанию "Вверх"
.KeyDown        EQU GameConfig + FGameConfig.Keys.Down                          ; клавиша по умолчанию "Вниз"
.KeyLeft        EQU GameConfig + FGameConfig.Keys.Left                          ; клавиша по умолчанию "Влево"
.KeyRight       EQU GameConfig + FGameConfig.Keys.Right                         ; клавиша по умолчанию "Вправо"
.KeySelect      EQU GameConfig + FGameConfig.Keys.Select                        ; клавиша по умолчанию "выбор"
.KeyAccel       EQU GameConfig + FGameConfig.Keys.Acceleration                  ; клавиша по умолчанию "ускорить"
.KeyESC         EQU GameConfig + FGameConfig.Keys.ESC                           ; клавиша по умолчанию "выход"
.Hardware       EQU GameConfig + FGameConfig.Hardware                           ; флаги ограничения железа
.SpeedScroll    EQU GameConfig + FGameConfig.SpeedScroll                        ; скорость скролла тайловой карты
.TopEdge        EQU GameConfig + FGameConfig.TopEdge                            ; верхняя грань видимой части
.LeftEdge       EQU GameConfig + FGameConfig.LeftEdge                           ; левая грань видимой части
.VisibleWidth   EQU GameConfig + FGameConfig.VisibleWidth                       ; ширина видимой части
.VisibleHeight  EQU GameConfig + FGameConfig.VisibleHeight                      ; высота видимой части

                endif ; ~_VARIABLES_GAME_CONFIG_

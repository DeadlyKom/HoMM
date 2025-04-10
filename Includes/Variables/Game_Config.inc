
                ifndef _VARIABLES_GAME_CONFIG_
                define _VARIABLES_GAME_CONFIG_
GameConfig      EQU Adr.GameConfig                                              ; адрес структуры конфигурации игры
.Keys           EQU GameConfig + FGameConfig.Keys                               ; массив клавиш
.KeyUp          EQU GameConfig + FGameConfig.Keys.Up                            ; клавиша по умолчанию "Вверх"
.KeyDown        EQU GameConfig + FGameConfig.Keys.Down                          ; клавиша по умолчанию "Вниз"
.KeyLeft        EQU GameConfig + FGameConfig.Keys.Left                          ; клавиша по умолчанию "Влево"
.KeyRight       EQU GameConfig + FGameConfig.Keys.Right                         ; клавиша по умолчанию "Вправо"
.KeySelect      EQU GameConfig + FGameConfig.Keys.Select                        ; клавиша по умолчанию "выбор"
.KeyESC         EQU GameConfig + FGameConfig.Keys.ESC                           ; клавиша по умолчанию "выход"
.KeyAccel       EQU GameConfig + FGameConfig.Keys.Acceleration                  ; клавиша по умолчанию "ускорить"
.KeyMenu        EQU GameConfig + FGameConfig.Keys.Menu                          ; клавиша по умолчанию "меню/пауза"
.Options        EQU GameConfig + FGameConfig.Options                            ; флаги игровых настроек
.Hardware       EQU GameConfig + FGameConfig.Hardware                           ; флаги ограничения железа
.SpeedCursorMin EQU GameConfig + FGameConfig.SpeedCursorMin                     ; минимальная скорость курсора
.SpeedCursorMax EQU GameConfig + FGameConfig.SpeedCursorMax                     ; максимальная скорость курсора
.SpeedScroll    EQU GameConfig + FGameConfig.SpeedScroll                        ; скорость скролла тайловой карты
.LeftEdge       EQU GameConfig + FGameConfig.LeftEdge                           ; левая грань видимой части     (в пикселах)
.VisibleWidth   EQU GameConfig + FGameConfig.VisibleWidth                       ; ширина видимой части          (в знакоместах)
.TopEdge        EQU GameConfig + FGameConfig.TopEdge                            ; верхняя грань видимой части   (в пикселах)
.VisibleHeight  EQU GameConfig + FGameConfig.VisibleHeight                      ; высота видимой части          (в пикселах)

                endif ; ~_VARIABLES_GAME_CONFIG_

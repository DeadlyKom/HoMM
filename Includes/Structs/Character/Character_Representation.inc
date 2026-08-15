
                ifndef _STRUCTS_CHARACTER_REPRESENTATION_
                define _STRUCTS_CHARACTER_REPRESENTATION_

                struct FRepresentation                                          ; представление персонажа                                       [16 байт]
Name            TEXT 14, {"None", ' '}                                          ; текстовое имя                                                 [14 байт]
HeroID          DB #00                                                          ; общий индекс изображения                                      [1 байт]
AppearanceID    DB #00                                                          ; идентификатор представления персонажа в мире                  [1 байт]
                ends

                endif ; ~_STRUCTS_CHARACTER_REPRESENTATION_

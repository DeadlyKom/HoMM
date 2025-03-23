
                ifndef _STRUCTS_KEYS_
                define _STRUCTS_KEYS_

                struct FKeys
.Menu           DB #00                                                          ; клавиша "меню/пауза"
.Acceleration   DB #00                                                          ; клавиша "ускорить"
.ESC            DB #00                                                          ; клавиша "выход"
.Select         DB #00                                                          ; клавиша "выбор"
.Right          DB #00                                                          ; клавиша "вправо"
.Left           DB #00                                                          ; клавиша "влево"
.Down           DB #00                                                          ; клавиша "вниз"
.Up             DB #00                                                          ; клавиша "вверх"
                ends

                endif ; ~_STRUCTS_KEYS_


                ifndef _STRUCTS_KEYS_
                define _STRUCTS_KEYS_

                struct FKeys
.ESC            DB #00                                                          ; клавиша "выход"
.Acceleration   DB #00                                                          ; клавиша "ускорить"
.Select         DB #00                                                          ; клавиша "выбор"
.Right          DB #00                                                          ; клавиша "вправо"
.Left           DB #00                                                          ; клавиша "влево"
.Down           DB #00                                                          ; клавиша "вниз"
.Up             DB #00                                                          ; клавиша "вверх"
                ends

                endif ; ~_STRUCTS_KEYS_

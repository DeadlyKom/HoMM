
                ifndef _STRUCTS_ITEM_EVENT_
                define _STRUCTS_ITEM_EVENT_

                struct FInputEvent                                              ; структура описывающая собитие ввода
KeyID           DB #00                                                          ; номер клавиши (KEY_ID_xxxx) порядковый номер в структуры FKeys
Position        FVector8                                                        ; позиция курсора,
                                                                                ; в зависимости от типа нажатой клавиши значения могут быть разные
                ends

                endif ; ~_STRUCTS_ITEM_EVENT_

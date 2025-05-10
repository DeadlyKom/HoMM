
                ifndef _STRUCTS_SAVE_SLOT_
                define _STRUCTS_SAVE_SLOT_

                struct FSaveSlot                                                ; струтура описывающая сохраняемые данные
Name            TEXT 16, {"None", ' '}                                          ; имя слота
MapID           DB #00                                                          ; ассет ID загруженной карты
MapInfo         FMapInfo                                                        ; базовая информация о карте
CRC             DB #00                                                          ; контрольная сумма
                ends

                endif ; ~_STRUCTS_SAVE_SLOT_

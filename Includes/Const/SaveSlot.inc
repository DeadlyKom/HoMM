
                ifndef _CONST_SAVE_SLOT_
                define _CONST_SAVE_SLOT_
SAVE_SLOT_0     EQU 0x00                                                        ; слот сохранения
SAVE_SLOT_MAX   EQU 0x07                                                        ; максимальное количество слотов сохранения
SAVE_SLOT_SIZE  EQU #0400                                                       ; размер одного слота 1кб

                endif ; ~_CONST_SAVE_SLOT_


                ifndef _MODULE_INVENTORY_STATES_DESCRIPTION_
                define _MODULE_INVENTORY_STATES_DESCRIPTION_
Description:    ; состояние подготовленного описания предмета
.Num            DB #00                                                          ; количество подготовленных строк

                ; массив слотов строк описания предмета
.Lines          DS INVENTORY_DESCRIPTION_LINES_MAX * INVENTORY_DESCRIPTION_LINE_SIZE, #00

                endif ; ~_MODULE_INVENTORY_STATES_DESCRIPTION_


                ifndef _CONST_INVENTORY_SLOTS_
                define _CONST_INVENTORY_SLOTS_
INVENTORY_ACTIVE_SLOT_BIT   EQU 0x00                                            ; флаг, активности слота
INVENTORY_FADE_OUT_SLOT_BIT EQU 0x01                                            ; флаг, исчезновения слота, 0 - появление, 1 - исчезновение
INVENTORY_READY_SLOT_BIT    EQU 0x02                                            ; флаг, готовности обоих сохранённых буферов

INVENTORY_FADE_OUT_SLOT     EQU 1 << INVENTORY_FADE_OUT_SLOT_BIT

                endif ; ~_CONST_INVENTORY_SLOTS_

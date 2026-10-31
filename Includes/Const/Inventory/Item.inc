
                ifndef _CONST_INVENTORY_ITEM_
                define _CONST_INVENTORY_ITEM_
; -----------------------------------------
;   флаги запросов перерисовки инвентаря
; -----------------------------------------
INVENTORY_REDRAW_BIT        EQU 0x00                                            ; флаг, запроса перерисовки фона
INVENTORY_DESCRIPTION_BIT   EQU 0x01                                            ; флаг, запроса рисования описания предмета

INVENTORY_REDRAW            EQU 1 << INVENTORY_REDRAW_BIT
INVENTORY_DESCRIPTION       EQU 1 << INVENTORY_DESCRIPTION_BIT

                endif ; ~_CONST_INVENTORY_ITEM_

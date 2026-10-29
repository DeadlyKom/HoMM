
                ifndef _METADATA_ITEMS_RING_
                define _METADATA_ITEMS_RING_
; -----------------------------------------
;   кольца
; -----------------------------------------
                module Jewelry
; -----------------------------------------
; формирование базового описания кольца
; In:
;   Label?    - метка кольца
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала кольца
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_RING       macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Jewelry. _ NameID?,  \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_RING, Flags?
                endm

                ; "Перстень ведуна"
                ITEM_RING RING_01, NAME_RING_01, VISIAL_RING_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_POWER, 1                            ; сила заклинаний героя
                ITEM_PROPERTY ITEM_PROPERTY_MAXMANA, 5                          ; прибавка максимального запаса маны героя
                ITEM_END RING_01
                endmodule

                endif ; ~_METADATA_ITEMS_RING_


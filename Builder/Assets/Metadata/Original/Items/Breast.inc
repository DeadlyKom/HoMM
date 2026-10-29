
                ifndef _METADATA_ITEMS_BREAST_
                define _METADATA_ITEMS_BREAST_
; -----------------------------------------
;   броня
; -----------------------------------------
                module Armor
; -----------------------------------------
; формирование базового описания брони
; In:
;   Label?    - метка брони
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала брони
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_BREAST     macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Armor. _ NameID?,    \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_BREAST, Flags?
                endm

                ; "Броня"
                ITEM_BREAST BREAST_01, NAME_BREAST_01, VISIAL_BREAST_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_DEFESE, 3
                ITEM_END BREAST_01
                endmodule

                endif ; ~_METADATA_ITEMS_BREAST_


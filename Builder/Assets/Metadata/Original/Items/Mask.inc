
                ifndef _METADATA_ITEMS_MASK_
                define _METADATA_ITEMS_MASK_
; -----------------------------------------
;   маски
; -----------------------------------------
                module Armor
; -----------------------------------------
; формирование базового описания маски
; In:
;   Label?    - метка маски
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала маски
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_MASK       macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Armor. _ NameID?,    \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_HEAD, Flags?
                endm

                endmodule

                endif ; ~_METADATA_ITEMS_MASK_


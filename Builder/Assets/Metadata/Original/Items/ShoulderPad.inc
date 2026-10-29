
                ifndef _METADATA_ITEMS_SHOULDERPAD_
                define _METADATA_ITEMS_SHOULDERPAD_
; -----------------------------------------
;   наплечники
; -----------------------------------------
                module Armor
; -----------------------------------------
; формирование базового описания наплечника
; In:
;   Label?    - метка наплечника
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала наплечника
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_SHOULDER   macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Armor. _ NameID?,    \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_SHOULDER_PAD, Flags?
                endm

                ; "Наплечи дружинника"
                ITEM_SHOULDER SHOULDER_PAD_01, NAME_SHOULDER_PAD_01, VISIAL_SHOULDER_PAD_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_ARMOR_PERCENT, 5                    ; увеличение показателя защиты существ в процентах
                ITEM_END SHOULDER_PAD_01
                endmodule

                endif ; ~_METADATA_ITEMS_SHOULDERPAD_


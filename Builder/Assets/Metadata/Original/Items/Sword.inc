
                ifndef _METADATA_ITEMS_SWORD_
                define _METADATA_ITEMS_SWORD_
; -----------------------------------------
;   мечи
; -----------------------------------------
                module Weapon
; -----------------------------------------
; формирование базового описания меча
; In:
;   Label?    - метка меча
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала меча
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_SWORD      macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Weapon. _ NameID?,   \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_RIGHT_HAND, Flags?
                endm

                ; "Меч дружинника"
                ITEM_SWORD SWORD_01, NAME_SWORD_01, VISIAL_SWORD_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_ATTACK, 2                           ; навык атаки героя
                ITEM_PROPERTY ITEM_PROPERTY_TOHIT, 10                           ; прибавка рейтинга атаки существ
                ITEM_END SWORD_01
                endmodule

                endif ; ~_METADATA_ITEMS_SWORD_


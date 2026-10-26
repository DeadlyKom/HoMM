
                ifndef _METADATA_ITEMS_AMULET_
                define _METADATA_ITEMS_AMULET_
; -----------------------------------------
;   амулеты
; -----------------------------------------
                module Jewelry
; -----------------------------------------
; формирование базового описания амулета
; In:
;   Label?    - метка амулета
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала амулета
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_AMULET     macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Jewelry. _ NameID?,  \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_AMULET, Flags?
                endm
                
                ; "Волчий клык"
                ITEM_AMULET AMULET_01, NAME_AMULET_01, VISIAL_AMULET_09, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_DAMAGE_PERCENT, 5
                ITEM_END AMULET_01

                ; "Кремень духа"
                ITEM_AMULET AMULET_02, NAME_AMULET_02, VISIAL_AMULET_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_DAMAGERESIST, 5
                ITEM_END AMULET_02

                ; "Оберег странника"
                ITEM_AMULET AMULET_03, NAME_AMULET_03, VISIAL_AMULET_03, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_PATHFINDING, 1
                ITEM_END AMULET_03

                ; "Купеческая мошна"
                ITEM_AMULET AMULET_04, NAME_AMULET_04, VISIAL_AMULET_04, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_GOLDBONUS, 1
                ITEM_END AMULET_04

                ; "Оберег ратоборца"
                ITEM_AMULET AMULET_05, NAME_AMULET_05, VISIAL_AMULET_07, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_ATTACK, 3
                ITEM_PROPERTY ITEM_PROPERTY_POWER, 1
                ITEM_END AMULET_05

                endmodule

                endif ; ~_METADATA_ITEMS_AMULET_



                ifndef _METADATA_ITEMS_SHIELD_
                define _METADATA_ITEMS_SHIELD_
; -----------------------------------------
;   щиты
; -----------------------------------------
                module Armor
; -----------------------------------------
; формирование базового описания щита
; In:
;   Label?    - метка щита
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала щита
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_SHIELD     macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Armor. _ NameID?,    \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_LEFT_HAND, Flags?
                endm

                ; "Щит ратника"
                ITEM_SHIELD SHIELD_01, NAME_SHIELD_01, VISIAL_SHIELD_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_DEFESE, 2                           ; навык защиты героя
                ITEM_PROPERTY ITEM_PROPERTY_DAMAGERESIST, 3                     ; уменьшение входящего физического урона существам в процентах
                ITEM_END SHIELD_01
                endmodule

                endif ; ~_METADATA_ITEMS_SHIELD_


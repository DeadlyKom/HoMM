
                ifndef _METADATA_ITEMS_HELMET_
                define _METADATA_ITEMS_HELMET_
; -----------------------------------------
;   шлемы
; -----------------------------------------
                module Armor
; -----------------------------------------
; формирование базового описания шлема
; In:
;   Label?    - метка шлема
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала шлема
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_HELMET     macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Armor. _ NameID?,    \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_HEAD, Flags?
                endm

                ; "Шелом стража"
                ITEM_HELMET HELMET_01, NAME_HELMET_01, VISIAL_HELMET_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_DEFESE, 1                           ; навык защиты героя
                ITEM_END HELMET_01
                endmodule

                endif ; ~_METADATA_ITEMS_HELMET_


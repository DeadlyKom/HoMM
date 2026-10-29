
                ifndef _METADATA_ITEMS_AXE_
                define _METADATA_ITEMS_AXE_
; -----------------------------------------
;   секиры
; -----------------------------------------
                module Weapon
; -----------------------------------------
; формирование базового описания секиры
; In:
;   Label?    - метка секиры
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала секиры
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_AXE        macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Weapon. _ NameID?,   \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_TWO_HANDED, Flags?
                endm

                ; "Секира ратника"
                ITEM_AXE AXE_01, NAME_AXE_01, VISIAL_AXE_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_DAMAGE_PERCENT, 10                  ; увеличение обеих границ урона существ в процентах
                ITEM_PROPERTY ITEM_PROPERTY_TOHIT, 5                            ; прибавка рейтинга атаки существ
                ITEM_END AXE_01
                endmodule

                endif ; ~_METADATA_ITEMS_AXE_


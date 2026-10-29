
                ifndef _METADATA_ITEMS_BOOT_
                define _METADATA_ITEMS_BOOT_
; -----------------------------------------
;   обувь
; -----------------------------------------
                module Equipment
; -----------------------------------------
; формирование базового описания обуви
; In:
;   Label?    - метка обуви
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала обуви
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_BOOT       macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                     \
                    Text.Items.Equipment. _ NameID?,  \
                    Graphics.UI.Items. _ VisualID?,   \
                    ITEM_TYPE_BOOT, Flags?
                endm

                ; "Сапоги странника"
                ITEM_BOOT BOOT_01, NAME_BOOT_01, VISIAL_BOOT_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_PATHFINDING, 1                      ; бонус поиска пути на карте приключений
                ITEM_END BOOT_01
                endmodule

                endif ; ~_METADATA_ITEMS_BOOT_


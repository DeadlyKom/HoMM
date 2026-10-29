
                ifndef _METADATA_ITEMS_BELT_
                define _METADATA_ITEMS_BELT_
; -----------------------------------------
;   пояса
; -----------------------------------------
                module Equipment
; -----------------------------------------
; формирование базового описания пояса
; In:
;   Label?    - метка пояса
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала пояса
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_BELT       macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                     \
                    Text.Items.Equipment. _ NameID?,  \
                    Graphics.UI.Items. _ VisualID?,   \
                    ITEM_TYPE_BELT, Flags?
                endm

                ; "Кушак крепости"
                ITEM_BELT BELT_01, NAME_BELT_01, VISIAL_BELT_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_MAXHP, 2                            ; прибавка максимального здоровья каждому существу
                ITEM_END BELT_01
                endmodule

                endif ; ~_METADATA_ITEMS_BELT_


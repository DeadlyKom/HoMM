
                ifndef _METADATA_ITEMS_CLOAK_
                define _METADATA_ITEMS_CLOAK_
; -----------------------------------------
;   плащи
; -----------------------------------------
                module Equipment
; -----------------------------------------
; формирование базового описания плаща
; In:
;   Label?    - метка плаща
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала плаща
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_CLOAK      macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                     \
                    Text.Items.Equipment. _ NameID?,  \
                    Graphics.UI.Items. _ VisualID?,   \
                    ITEM_TYPE_SHOULDER_PAD, Flags?
                endm

                endmodule

                endif ; ~_METADATA_ITEMS_CLOAK_


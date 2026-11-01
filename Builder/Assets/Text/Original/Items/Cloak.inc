
                ifndef _TEXT_ITEMS_CLOAK_
                define _TEXT_ITEMS_CLOAK_
; -----------------------------------------
;   плащи
; -----------------------------------------
; -----------------------------------------
; формирование названия плаща
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
CLOAK_NAME      macro Label?, Text?
                ITEM_NAME Equipment. _ Label?, Text?
                endm

                module Equipment
                endmodule

                endif ; ~_TEXT_ITEMS_CLOAK_


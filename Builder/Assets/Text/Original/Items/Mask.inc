
                ifndef _TEXT_ITEMS_MASK_
                define _TEXT_ITEMS_MASK_
; -----------------------------------------
;   маски
; -----------------------------------------
; -----------------------------------------
; формирование названия маски
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
MASK_NAME       macro Label?, Text?
                ITEM_NAME Armor. _ Label?, Text?
                endm

                MASK_NAME NAME_MASK_01, "Маска"

                endif ; ~_TEXT_ITEMS_MASK_


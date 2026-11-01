
                ifndef _TEXT_ITEMS_RING_
                define _TEXT_ITEMS_RING_
; -----------------------------------------
;   кольца
; -----------------------------------------
; -----------------------------------------
; формирование названия кольца
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
RING_NAME       macro Label?, Text?
                ITEM_NAME Jewelry. _ Label?, Text?
                endm

                RING_NAME NAME_RING_01, "Перстень ведуна"
                RING_NAME NAME_RING_02, "Перстень прозрения"

                endif ; ~_TEXT_ITEMS_RING_


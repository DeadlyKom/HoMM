
                ifndef _TEXT_ITEMS_BELT_
                define _TEXT_ITEMS_BELT_
; -----------------------------------------
;   пояса
; -----------------------------------------
; -----------------------------------------
; формирование названия пояса
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
BELT_NAME       macro Label?, Text?
                ITEM_NAME Equipment. _ Label?, Text?
                endm

                BELT_NAME NAME_BELT_01, "Кушак крепости"

                endif ; ~_TEXT_ITEMS_BELT_


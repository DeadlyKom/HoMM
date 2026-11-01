
                ifndef _TEXT_ITEMS_BREAST_
                define _TEXT_ITEMS_BREAST_
; -----------------------------------------
;   броня
; -----------------------------------------
; -----------------------------------------
; формирование названия брони
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
BREAST_NAME     macro Label?, Text?
                ITEM_NAME Armor. _ Label?, Text?
                endm

                BREAST_NAME NAME_BREAST_01, "Броня"

                endif ; ~_TEXT_ITEMS_BREAST_


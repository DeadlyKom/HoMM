
                ifndef _TEXT_ITEMS_HELMET_
                define _TEXT_ITEMS_HELMET_
; -----------------------------------------
;   шлемы
; -----------------------------------------
; -----------------------------------------
; формирование названия шлема
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
HELMET_NAME     macro Label?, Text?
                ITEM_NAME Armor. _ Label?, Text?
                endm

                HELMET_NAME NAME_HELMET_01, "Шелом стража"

                endif ; ~_TEXT_ITEMS_HELMET_


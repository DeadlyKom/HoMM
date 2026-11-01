
                ifndef _TEXT_ITEMS_SHIELD_
                define _TEXT_ITEMS_SHIELD_
; -----------------------------------------
;   щиты
; -----------------------------------------
; -----------------------------------------
; формирование названия щита
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
SHIELD_NAME     macro Label?, Text?
                ITEM_NAME Armor. _ Label?, Text?
                endm

                SHIELD_NAME NAME_SHIELD_01, "Щит ратника"

                endif ; ~_TEXT_ITEMS_SHIELD_


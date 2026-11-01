
                ifndef _TEXT_ITEMS_SWORD_
                define _TEXT_ITEMS_SWORD_
; -----------------------------------------
;   мечи
; -----------------------------------------
; -----------------------------------------
; формирование названия меча
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
SWORD_NAME      macro Label?, Text?
                ITEM_NAME Weapon. _ Label?, Text?
                endm

                SWORD_NAME NAME_SWORD_01, "Меч дружинника"

                endif ; ~_TEXT_ITEMS_SWORD_


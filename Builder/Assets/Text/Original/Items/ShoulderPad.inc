
                ifndef _TEXT_ITEMS_SHOULDERPAD_
                define _TEXT_ITEMS_SHOULDERPAD_
; -----------------------------------------
;   наплечники
; -----------------------------------------
; -----------------------------------------
; формирование названия наплечника
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
SHOULDER_NAME   macro Label?, Text?
                ITEM_NAME Armor. _ Label?, Text?
                endm

                SHOULDER_NAME NAME_SHOULDER_PAD_01, "Наплечи дружинника"

                endif ; ~_TEXT_ITEMS_SHOULDERPAD_


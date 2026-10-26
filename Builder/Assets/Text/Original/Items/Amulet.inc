
                ifndef _TEXT_ITEMS_AMULET_
                define _TEXT_ITEMS_AMULET_
; -----------------------------------------
;   амулеты
; -----------------------------------------
; -----------------------------------------
; формирование названия амулета
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
AMULET_NAME     macro Label?, Text?
                ITEM_NAME Jewelry. _ Label?, Text?
                endm

                AMULET_NAME NAME_AMULET_01, "Волчий клык"
                AMULET_NAME NAME_AMULET_02, "Кремень духа"
                AMULET_NAME NAME_AMULET_03, "Оберег странника"
                AMULET_NAME NAME_AMULET_04, "Купеческая мошна"
                AMULET_NAME NAME_AMULET_05, "Оберег ратоборца"

                endif ; ~_TEXT_ITEMS_AMULET_


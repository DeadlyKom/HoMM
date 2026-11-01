
                ifndef _TEXT_ITEMS_AXE_
                define _TEXT_ITEMS_AXE_
; -----------------------------------------
;   секиры
; -----------------------------------------
; -----------------------------------------
; формирование названия секиры
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
AXE_NAME        macro Label?, Text?
                ITEM_NAME Weapon. _ Label?, Text?
                endm

                AXE_NAME NAME_AXE_01, "Секира ратника"

                endif ; ~_TEXT_ITEMS_AXE_


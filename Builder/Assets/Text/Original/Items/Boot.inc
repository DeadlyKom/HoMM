
                ifndef _TEXT_ITEMS_BOOT_
                define _TEXT_ITEMS_BOOT_
; -----------------------------------------
;   обувь
; -----------------------------------------
; -----------------------------------------
; формирование названия обуви
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
BOOT_NAME       macro Label?, Text?
                ITEM_NAME Equipment. _ Label?, Text?
                endm

                BOOT_NAME NAME_BOOT_01, "Сапоги странника"

                endif ; ~_TEXT_ITEMS_BOOT_


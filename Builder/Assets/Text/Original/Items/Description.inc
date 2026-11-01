
                ifndef _TEXT_ITEMS_DESCRIPTION_
                define _TEXT_ITEMS_DESCRIPTION_
; -----------------------------------------
; формирование текста описания предмета
; In:
;   Label? - метка двухбайтовой ссылки на строку
;   Text?  - текст строки
; -----------------------------------------
DESCRIPTION_TEXT macro Label?, Text?
                ITEM_NAME Description. _ Label?, Text?
                endm

                DESCRIPTION_TEXT TypeAmulet, "Амулет «"
                DESCRIPTION_TEXT TypeRing, "Кольцо «"
                DESCRIPTION_TEXT TypeOneHand, "Одноручное"
                DESCRIPTION_TEXT TypeTwoHand, "Двуручное"
                DESCRIPTION_TEXT CloseQuote, "»"
                DESCRIPTION_TEXT SignPlus, "+"
                DESCRIPTION_TEXT SignMinus, "-"

                endif                                                           ; ~_TEXT_ITEMS_DESCRIPTION_


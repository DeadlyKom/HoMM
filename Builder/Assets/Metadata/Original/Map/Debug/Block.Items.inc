
                ifndef _METADATA_MAP_DEBUG_ITEMS_
                define _METADATA_MAP_DEBUG_ITEMS_
; -----------------------------------------
;   начальные предметы карты
; -----------------------------------------

                DB Items.Num                                                    ; количество предметов в блоке

                ; "Волчий клык", индекс базового предмета 0
                FMapItem {
                    { #00, ITEM_QUALITY_NORMAL, #00, #00 },
                    { ITEM_LOCATION_EQUIPPED | ITEM_ITEM_POSITION_CUSTOM, PLAYER_CHARACTER_ID_MAIN, { #00, #00 } }
                }

                ; "Кремень духа", индекс базового предмета 1
                FMapItem {
                    { #01, ITEM_QUALITY_NORMAL, #00, #00 },
                    { #00, PLAYER_CHARACTER_ID_MAIN, { #02, #00 } }
                }

                ; "Оберег ратоборца", индекс базового предмета 4
                FMapItem {
                    { #04, ITEM_QUALITY_NORMAL, #00, #00 },
                    { #00, PLAYER_CHARACTER_ID_MAIN, { #04, #00 } }
                }

                ; "Броня", индекс базового предмета 5
                FMapItem {
                    { #05, ITEM_QUALITY_NORMAL, #00, #00 },
                    { ITEM_LOCATION_EQUIPPED | ITEM_ITEM_POSITION_CUSTOM, PLAYER_CHARACTER_ID_MAIN, { #00, #00 } }
                }

Items.Num       EQU ($-Items-1) / FMapItem

                endif ; ~_METADATA_MAP_DEBUG_ITEMS_

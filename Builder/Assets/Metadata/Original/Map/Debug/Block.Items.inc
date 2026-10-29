
                ifndef _METADATA_MAP_DEBUG_ITEMS_
                define _METADATA_MAP_DEBUG_ITEMS_
; -----------------------------------------
; формирование начального предмета в экипировке
; In:
;   BaseItem?    - индекс базового описания предмета
;   Quality?     - качество предмета ITEM_QUALITY_
;   CharacterID? - индекс персонажа
;   Slot?        - индекс слота в FCharacterEquipment
; -----------------------------------------
MAP_ITEM_EQUIP  macro BaseItem?, Quality?, CharacterID?, Slot?
                FMapItem {
                    { BaseItem?, Quality?, #00, #00 },
                    {
                        ITEM_LOCATION_EQUIPPED | ITEM_ITEM_POSITION_CUSTOM,
                        CharacterID?,
                        { Slot?, #00 }
                    }
                }
                endm
; -----------------------------------------
; формирование начального предмета в сетке
; In:
;   BaseItem?  - индекс базового описания предмета
;   Quality?   - качество предмета ITEM_QUALITY_
;   Container? - индекс контейнера
;   X?         - столбец сетки в ячейках
;   Y?         - строка сетки в ячейках
; -----------------------------------------
MAP_ITEM_GRID   macro BaseItem?, Quality?, Container?, X?, Y?
                FMapItem {
                    { BaseItem?, Quality?, #00, #00 },
                    { #00, Container?, { X?, Y? } }
                }
                endm
; -----------------------------------------
;   начальные предметы карты
; -----------------------------------------
                DB Items.Num                                                    ; количество предметов в блоке

                ; "Волчий клык", индекс базового предмета 5
                MAP_ITEM_EQUIP #05, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Amulet.ID

                ; "Кремень духа", индекс базового предмета 6
                MAP_ITEM_GRID #06, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, #02, #00

                ; "Оберег ратоборца", индекс базового предмета 9
                MAP_ITEM_GRID #09, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, #04, #00

                ; "Броня", индекс базового предмета 10
                MAP_ITEM_EQUIP #0A, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Breast.ID

                ; "Шелом стража", индекс базового предмета 11
                MAP_ITEM_EQUIP #0B, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Head.ID

                ; "Наплечи дружинника", индекс базового предмета 13
                MAP_ITEM_EQUIP #0D, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.ShoulderPad.ID

                ; "Кушак крепости", индекс базового предмета 2
                MAP_ITEM_EQUIP #02, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Belt.ID

                ; "Щит ратника", индекс базового предмета 12
                MAP_ITEM_EQUIP #0C, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.LeftHand.ID

                ; "Меч дружинника", индекс базового предмета 4
                MAP_ITEM_EQUIP #04, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.RightHand.ID

                ; "Перстень ведуна", индекс базового предмета 1
                MAP_ITEM_EQUIP #01, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.LeftRing.ID

                ; "Сапоги странника", индекс базового предмета 3
                MAP_ITEM_EQUIP #03, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, FCharacterEquipment.Boot.ID

                ; "Секира ратника", индекс базового предмета 0
                MAP_ITEM_GRID #00, ITEM_QUALITY_NORMAL, \
                    PLAYER_CHARACTER_ID_MAIN, #06, #00
Items.Num       EQU ($-Items-1) / FMapItem

                endif ; ~_METADATA_MAP_DEBUG_ITEMS_


                ifndef _MODULE_SESSION_MAP_DATA_BLOCK_ITEMS_
                define _MODULE_SESSION_MAP_DATA_BLOCK_ITEMS_
; -----------------------------------------
; обработка блока Items
; In:
;   DE - адрес блока данных, первый байт содержит количество предметов
; Out:
;   GameState.ItemsNum - количество загруженных предметов
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Items:          ; проверка наличия предметов в блоке
                LD A, (DE)                                                      ; чтение количества предметов в блоке
                OR A
                RET Z                                                           ; выход, если блок предметов пуст

                ifdef _DEBUG
                ; проверка вместимости предметов в общий массив
                CP ITEM_MAX + 1
                DEBUG_BREAK_POINT_NC                                            ; ошибка, количество предметов превышает вместимость массива
                endif

                ; сохранение количества загружаемых предметов
                LD B, A
                PUSH BC

                ; получение адреса первой записи после количества
                INC DE
                SET_REGISTER IX, DE

                ; получение адреса массива экземпляров предметов
                LD A, (GameState.Inventory.High)
                LD D, A
                LD E, #00

                ; расчёт адреса массива размещения предметов
                LD HL, ITEM_MAX * FItem
                ADD HL, DE
                SET_REGISTER IY, HL

                ; восстановление количества загружаемых предметов
                POP BC

.ItemLoop       PUSH BC

                ; ToDo: вызывать методы создания и добавления предметов
                ;       вместо копирования готовых экземпляров из блока карты
                ; копирование экземпляра предмета в общий массив
                SET_REGISTER HL, IX
                LD BC, FItem
                LD A, (GameState.Inventory.Page)
                EX AF, AF'
                LD A, (Session.SharedCode.SetPageLoadedMap.LoadedMapPage)
                CALL Memcpy.BetweenPages
                PUSH DE

                ; расчёт адреса размещения в исходной записи
                SET_REGISTER HL, IX
                LD BC, FMapItem.Location
                ADD HL, BC

                ; копирование размещения предмета в общий массив
                SET_REGISTER DE, IY
                LD BC, FItemLocation
                LD A, (GameState.Inventory.Page)
                EX AF, AF'
                LD A, (Session.SharedCode.SetPageLoadedMap.LoadedMapPage)
                CALL Memcpy.BetweenPages

                ; установка флага занятости записи предмета
                SET ITEM_LOCATION_OCCUPIED_BIT, (IY + FItemLocation.State)

                ; сохранение адреса следующей записи размещения
                SET_REGISTER IY, DE

                ; обновление количества загруженных предметов
                LD HL, GameState.ItemsNum
                INC (HL)

                ; расчёт адреса следующей исходной записи
                LD DE, FMapItem
                ADD IX, DE
                POP DE
                POP BC
                DJNZ .ItemLoop

                JP Session.SharedCode.SetPageLoadedMap                          ; восстановление страницы загруженной карты

                display " - Parsing FMapDataBlockInfo for 'items':\t\t\t", /A, Items, "\t= busy [ ", /D, $-Items, " byte(s) ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_ITEMS_


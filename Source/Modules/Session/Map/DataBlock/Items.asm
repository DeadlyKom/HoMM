
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

                ; проверка вместимости предметов в общий массив
                ifdef _DEBUG
                CP ITEM_MAX + 1
                DEBUG_BREAK_POINT_NC                                            ; ошибка, количество предметов превышает вместимость массива
                endif

                ; сохранение количества загружаемых предметов
                LD B, A

                ; получение адреса первой записи после количества
                INC DE
                SET_REGISTER IX, DE

.ItemLoop       PUSH BC

                ; копирование записи карты во временный буфер
                SET_REGISTER HL, IX
                LD DE, .BUFFER
                ifdef _OPTIMIZE
                rept ITEM_SIZE + ITEM_LOCATION_SIZE
                LDI
                endr
                else
                LD BC, ITEM_SIZE + ITEM_LOCATION_SIZE
                LDIR
                endif

                ; установка флага занятости подготовленной записи
                LD HL, .BUFFER + FMapItem.Location + FItemLocation.State
                SET ITEM_LOCATION_OCCUPIED_BIT, (HL)

                ; добавление подготовленного предмета в общий массив
                LD HL, .BUFFER
                CALL Item.Add
                DEBUG_BREAK_POINT_C                                             ; ошибка, нет места для добавления предмета

                ; включение страницы карты для чтения следующей записи
                CALL Session.SharedCode.SetPageLoadedMap

                ; расчёт адреса следующей исходной записи
                LD DE, ITEM_SIZE + ITEM_LOCATION_SIZE
                ADD IX, DE
                POP BC
                DJNZ .ItemLoop
                RET

.BUFFER         EQU Adr.ExtraBuffer                                             ; адрес временного буфера записи предмета
                display " - Parsing FMapDataBlockInfo for 'items':\t\t", /A, Items, "\t= busy [ ", /D, $-Items, " byte(s) ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_ITEMS_


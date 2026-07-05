
                ifndef _MODULE_SESSION_MAP_INITIALIZE_
                define _MODULE_SESSION_MAP_INITIALIZE_
; -----------------------------------------
; первичная инициализация карты после загрузки
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initial:        PUSH HL
                CALL Sprite.Initialize

                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                CALL ChunkArray.Initialize                                      ; первичная инициализация массива чанков

                ; тестовая стоимость перемещения по типам поверхности
                MEMSET_BYTE Adr.SurfPass, MOVEMENT_DEFAULT_COST, Size.SurfPass
                LD HL, .TestSurfaceCostTable
                LD DE, Adr.SurfPass
                LD BC, .TestSurfaceCostTable.Size
                LDIR

                                                                                ; должна быть включена страница расположения карты
                SET_PAGE_MAP                                                    ; включить страницу работы с картой
                CALL Tables.TG_MapAdr                                           ; генерация адресов карты/методанных

                ; -----------------------------------------
                ; копирование данных между страницами
                ; In:
                ;   A HL - адрес исходника  (аккумулятор страница)
                ;   A'DE - адрес назначения (аккумулятор страница)
                ;   BC   - длина блока
                ; -----------------------------------------
                LD A, Page.Hextile
                LD DE, Adr.HexShadingTable
                EX AF, AF'
                LD A, (Session.SharedCode.SetPageLoadedMap.LoadedMapPage)
                LD HL, Session.HexShadingTable
                LD BC, Session.HexShadingTable.Size
                CALL Memcpy.BetweenPages

                ; -----------------------------------------
                ; копирование данных между страницами
                ; In:
                ;   A HL - адрес исходника  (аккумулятор страница)
                ;   A'DE - адрес назначения (аккумулятор страница)
                ;   BC   - длина блока
                ; -----------------------------------------
                LD A, Page.Hextile
                LD DE, Adr.HexShading
                EX AF, AF'
                LD A, (Session.SharedCode.SetPageLoadedMap.LoadedMapPage)
                LD HL, Session.HexShading
                LD BC, Session.HexShading.Size
                CALL Memcpy.BetweenPages

                POP HL
                JP Session.SharedCode.SetPageLoadedMap                          ; установка страницы загруженной карты

.TestSurfaceCostTable:
                DB MOVEMENT_DEFAULT_COST * 1                                   ; HextileID 0: трава
                DB MOVEMENT_DEFAULT_COST * 8                                   ; HextileID 1: гора
                DB MOVEMENT_DEFAULT_COST * 6                                   ; HextileID 2: болото
                DB MOVEMENT_DEFAULT_COST * 2                                   ; HextileID 3: маленькое поселение
                DB MOVEMENT_DEFAULT_COST * 2                                   ; HextileID 4: лес в середине гекса
                DB MOVEMENT_DEFAULT_COST * 3                                   ; HextileID 5: плотный лес
                DB MOVEMENT_DEFAULT_COST * 4                                   ; HextileID 6: укрепление
                DB MOVEMENT_DEFAULT_COST * 0                                   ; HextileID 7: пустой гексагон/контур
.TestSurfaceCostTable.Size EQU $ - .TestSurfaceCostTable

                display " - Initial initialization of the map after loading:\t", /A, Initial, "\t= busy [ ", /D, $-Initial, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_INITIALIZE_OBJECTS_

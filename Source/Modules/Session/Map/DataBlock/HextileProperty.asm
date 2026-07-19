
                ifndef _MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_PROPERTY_
                define _MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_PROPERTY_
; -----------------------------------------
; обработка блока - список "точек спавна"
; In:
;   DE - указывает на адрес блока данных
;   BC - длина блока
; Out:
; Corrupt:
; Note:
; -----------------------------------------
HextileProperty:; ToDo: тестовая стоимость перемещения по типам поверхности
                ;       в дальнейшем необходимо загружать их из карты
                SET_PAGE_MAP                                                    ; включить страницу работы с картой
                MEMSET_BYTE Adr.SurfPass, MOVEMENT_DEFAULT_STEP_COST, Size.SurfPass
                LD HL, .TestSurfaceCostTable
                LD DE, Adr.SurfPass
                LD BC, .TestSurfaceCostTable.Size
                LDIR
                JP Session.SharedCode.SetPageLoadedMap                          ; установка страницы загруженной карты

.TestSurfaceCostTable:
                DB MOVEMENT_DEFAULT_STEP_COST * 1                               ; HextileID 0: трава
                DB MOVEMENT_DEFAULT_STEP_COST * 6                               ; HextileID 1: гора
                DB MOVEMENT_DEFAULT_STEP_COST * 4                               ; HextileID 2: болото
                DB MOVEMENT_DEFAULT_STEP_COST * 2                               ; HextileID 3: маленькое поселение
                DB MOVEMENT_DEFAULT_STEP_COST * 2                               ; HextileID 4: лес в середине гекса
                DB MOVEMENT_DEFAULT_STEP_COST * 3                               ; HextileID 5: плотный лес
                DB MOVEMENT_DEFAULT_STEP_COST * 2                               ; HextileID 6: укрепление
                DB MOVEMENT_DEFAULT_STEP_COST * 0                               ; HextileID 7: пустой гексагон/контур
.TestSurfaceCostTable.Size EQU $ - .TestSurfaceCostTable

                display " - Parsing FMapDataBlockInfo for 'hextile property':\t", /A, HextileProperty, "\t= busy [ ", /D, $-HextileProperty, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_PROPERTY_

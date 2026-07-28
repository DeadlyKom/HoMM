
                ifndef _MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_PROPERTY_
                define _MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_PROPERTY_
; -----------------------------------------
; обработка блока свойств гексагональных тайлов
; In:
;   DE - указывает на адрес блока данных
;   BC - длина блока
; Out:
; Corrupt:
; Note:
; -----------------------------------------
HextileProperty:; ToDo: тестовые свойства типов поверхности
                ;       в дальнейшем необходимо загружать их из карты
                SET_PAGE_MAP                                                    ; включить страницу работы с картой
                MEMSET_BYTE \
                    Adr.SurfPassability, \
                    MOVEMENT_DEFAULT_STEP_COST, \
                    Size.SurfPassability

                MEMSET_BYTE \
                    Adr.SurfProperty, \
                    #00, \
                    Size.SurfProperty

                ; ToDo: временные тестовые данные; в дальнейшем копировать из данных карты
                LD HL, .SurfaceCostTable
                LD DE, Adr.SurfPassability
                LD BC, .SurfaceCostTable.Size
                LDIR
                LD HL, .SurfacePropertyTable
                LD DE, Adr.SurfProperty
                LD BC, .SurfacePropertyTable.Size
                LDIR

                JP Session.SharedCode.SetPageLoadedMap                          ; установка страницы загруженной карты

.SurfaceCostTable:
                SURFACE_PASSABILITY SURFACE_TYPE_NORMAL, 1                      ; HextileID 0: трава
                SURFACE_PASSABILITY SURFACE_TYPE_NORMAL, 6                      ; HextileID 1: гора
                SURFACE_PASSABILITY SURFACE_TYPE_NORMAL, 4                      ; HextileID 2: болото
                SURFACE_PASSABILITY SURFACE_TYPE_SETTLEMENT, 2                  ; HextileID 3: маленькое поселение
                SURFACE_PASSABILITY SURFACE_TYPE_NORMAL, 2                      ; HextileID 4: лес в середине гекса
                SURFACE_PASSABILITY SURFACE_TYPE_NORMAL, 3                      ; HextileID 5: плотный лес
                SURFACE_PASSABILITY SURFACE_TYPE_SETTLEMENT, 2                  ; HextileID 6: укрепление
                SURFACE_PASSABILITY SURFACE_TYPE_NORMAL, 0                      ; HextileID 7: пустой гексагон/контур
.SurfaceCostTable.Size EQU $-.SurfaceCostTable

.SurfacePropertyTable:
                SURFACE_PROPERTY 0                                              ; HextileID 0: трава
                SURFACE_PROPERTY SURFACE_RECON_POS_MOD_2                        ; HextileID 1: гора                  (+2 к разведке)
                SURFACE_PROPERTY 0                                              ; HextileID 2: болото
                SURFACE_PROPERTY 0                                              ; HextileID 3: маленькое поселение
                SURFACE_PROPERTY SURFACE_RECON_NEG_MOD_1                        ; HextileID 4: лес в середине гекса  (-1 к разведке)
                SURFACE_PROPERTY SURFACE_RECON_NEG_MOD_2                        ; HextileID 5: плотный лес           (-2 к разведке)
                SURFACE_PROPERTY 0                                              ; HextileID 6: укрепление
                SURFACE_PROPERTY 0                                              ; HextileID 7: пустой гексагон/контур
.SurfacePropertyTable.Size EQU $-.SurfacePropertyTable

                display " - Parsing FMapDataBlockInfo for 'hextile property':\t", /A, HextileProperty, "\t= busy [ ", /D, $-HextileProperty, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_PROPERTY_

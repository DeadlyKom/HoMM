
                ifndef _MODULE_SESSION_LOAD_MAP_
                define _MODULE_SESSION_LOAD_MAP_
; -----------------------------------------
; загрузка карты
; In:
;   A - идентификатор загружаемого ресурса карты
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load_Map:       EX AF, AF'
                PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                CALL Sprite.Initialize

                ; -----------------------------------------
                ; загрузка ресурса карты
                ; -----------------------------------------
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                EX AF, AF'
                PUSH AF
                LOAD_ASSETS_A                                                   ; загрузка ресурса
                                                                                ;   HL - адрес загрузки/распаковки
                ; -----------------------------------------
                ; парсинг FMapHeader
                ; -----------------------------------------

                ; сохранение информации о карте
                LD DE, GameSession.MapInfo
                LD BC, FMapInfo
                LDIR

                ; загрузка ассета ID тайлового биома
                LD E, (HL)
                INC HL
                PUSH HL
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS_REG E, Page.TileSprites, Adr.TileSprites        ; принудительная установка места загрузки ресурса
                LOAD_ASSETS_REG E                                               ; загрузка ресурса

                ; восстановление страницы расположения ассета
                LD A, (Kernel.Modules.Session.Page)
                SET_PAGE_A

                POP HL
                ; чтение длины блока данных биома (тайлы)
                LD C, (HL)                                                      ; FMapHeader.BiomeSize.Low
                INC HL
                LD B, (HL)                                                      ; FMapHeader.BiomeSize.High
                INC HL

                ; расчёт адреса до данных биома (тайлы)
                LD E, (HL)                                                      ; FMapHeader.BiomeOffset.Low
                INC HL
                LD D, (HL)                                                      ; FMapHeader.BiomeOffset.High
                PUSH HL
                ADD HL, DE
                ; -----------------------------------------
                ; копирование данных между страницами
                ; In:
                ;   A HL - адрес исходника  (аккумулятор страница)
                ;   A'DE - адрес назначения (аккумулятор страница)
                ;   BC   - длина блока
                ; Out:
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                LD A, Page.MapBiome
                LD DE, Adr.MapBiome
                EX AF, AF'
                CALL GetPage                                                    ; получение текущей страницы
                CALL Memcpy.BetweenPages
                
                ; -----------------------------------------
                ; инициализация объектов карты
                ; -----------------------------------------
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                CALL ChunkArray.Initialize                                      ; первичная инициализация массива чанков
                                                                                ; должна быть включена страница расположения карты
                ; восстановление страницы расположения ассета
                LD A, (Kernel.Modules.Session.Page)
                SET_PAGE_A

                POP HL
                INC HL                                                          ; FMapHeader.DefaultSettings

                ; загрузка ассета ID дефолтных настроек объектов
                LD E, (HL)
                PUSH HL
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS_REG E, Page.ObjectDefaultSettings, Adr.ObjectDefaultSettings ; принудительная установка места загрузки ресурса
                LOAD_ASSETS_REG E                                               ; загрузка ресурса

                ; восстановление страницы расположения ассета
                LD A, (Kernel.Modules.Session.Page)
                SET_PAGE_A

                POP HL
                INC HL                                                          ; FMapHeader.GraphicPack

                ; загрузка ассета ID необходимого графического пакета для текущей карты
                LD E, (HL)
                PUSH HL
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_ASSETS_REG E                                               ; загрузка ресурса

                ; восстановление страницы расположения загруженого ассетаа карты
                LD A, (Kernel.Modules.Session.Page)
                SET_PAGE_A

                POP HL
                INC HL                                                          ; FMapHeader.ObjectNum
                CALL Init_Objects                                               ; инициализация объектов карты после загрузки

                ; -----------------------------------------
                ; освобождение ресурса карты
                ; -----------------------------------------
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                POP AF
                RELEASE_ASSET_A
                JP_POP_PAGE                                                     ; восстановление номера страницы из стека

                display " - Load map:\t\t\t\t\t\t", /A, Load_Map, "\t= busy [ ", /D, $-Load_Map, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_LOAD_MAP_

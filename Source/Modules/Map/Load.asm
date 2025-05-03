
                ifndef _MODULE_MAP_LOAD_
                define _MODULE_MAP_LOAD_
; -----------------------------------------
; загрузка карты
; In:
;   SP+0 - первый параметр
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load:           CALL Sprite.Initialize

                ; -----------------------------------------
                ; загрузка ресурса карты
                ; -----------------------------------------
                POP HL                                                          ; ID загружаемой карты
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LD A, L
                PUSH AF
                LOAD_ASSETS_A                                                   ; загрузка ресурса
                                                                                ;   HL - адрес загрузки/распаковки
                ; сохранение номера страницы расположения загруженого ассетаа карты
                CALL GetPage                                                    ; получение текущей страницы исходника
                LD (Kernel.Modules.Map.Load.Page), A

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

                ; восстановление страницы расположения загруженого ассетаа карты
                LD A, (Kernel.Modules.Map.Load.Page)
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
                LD A, Page.BiomeBuf
                LD DE, Adr.BiomeBuf
                EX AF, AF'
                CALL GetPage                                                    ; получение текущей страницы
                CALL Memcpy.BetweenPages
                
                ; -----------------------------------------
                ; инициализация объектов карты
                ; -----------------------------------------
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                CALL ChunkArray.Initialize                                      ; первичная инициализация массива чанков
                                                                                ; должна быть включена страница расположения карты
                ; восстановление страницы расположения загруженого ассетаа карты
                LD A, (Kernel.Modules.Map.Load.Page)
                SET_PAGE_A

                POP HL
                INC HL                                                          ; FMapHeader.DefaultSettings

                ; загрузка ассета ID дефолтных настроек объектов
                LD E, (HL)
                PUSH HL
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS_REG E, Page.ObjectDefaultSettings, Adr.ObjectDefaultSettings ; принудительная установка места загрузки ресурса
                LOAD_ASSETS_REG E                                               ; загрузка ресурса

                ; восстановление страницы расположения загруженого ассетаа карты
                LD A, (Kernel.Modules.Map.Load.Page)
                SET_PAGE_A

                POP HL
                INC HL                                                          ; FMapHeader.GraphicPack

                ; загрузка ассета ID текущего графического пакета
                LD E, (HL)
                PUSH HL
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LOAD_ASSETS_REG E                                               ; загрузка ресурса

                ; восстановление страницы расположения загруженого ассетаа карты
                LD A, (Kernel.Modules.Map.Load.Page)
                SET_PAGE_A

                POP HL
                INC HL                                                          ; FMapHeader.ObjectNum
                CALL Load_Objects                                               ; инициализация объектов карты после загрузки

                ; -----------------------------------------
                ; освобождение ресурса карты
                ; -----------------------------------------
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                POP AF
                JP_RELEASE_ASSET_A

                endif ; ~_MODULE_MAP_LOAD_

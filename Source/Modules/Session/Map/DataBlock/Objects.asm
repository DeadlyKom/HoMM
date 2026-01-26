
                ifndef _MODULE_SESSION_MAP_DATA_BLOCK_OBJECTS_
                define _MODULE_SESSION_MAP_DATA_BLOCK_OBJECTS_
; -----------------------------------------
; обработка блока Objects
; In:
;   DE - указывает на адрес блока данных
;   BC - длина блока
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Objects:        EX DE, HL                                                       ; меняем местами

                ; загрузка ассета ID дефолтных настроек объектов
                LD E, (HL)
                INC HL
                PUSH HL
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS_REG E, Page.ObjectDefaultSettings, Adr.ObjectDefaultSettings ; принудительная установка места загрузки ресурса
                LOAD_ASSETS_REG E                                               ; загрузка ресурса
                CALL Session.SharedCode.SetPageLoadedMap                        ; установка страницы загруженной карты
                POP HL
                JP Session.SharedCode.Initialize.Objects                        ; инициализация объектов карты после загрузки

                display " - Parsing FMapDataBlockInfo for Objects:\t", /A, Objects, "\t= busy [ ", /D, $-Objects, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_OBJECTS_

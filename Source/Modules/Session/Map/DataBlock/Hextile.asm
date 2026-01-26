
                ifndef _MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_
                define _MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_
; -----------------------------------------
; обработка блока Hextile
; In:
;   DE - указывает на адрес блока данных
;   BC - длина блока
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Hextile:        EX DE, HL                                                       ; меняем местами
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
                LD A, Page.Hextile
                LD DE, Adr.Hextile
                EX AF, AF'
                LD A, (Session.SharedCode.SetPageLoadedMap.LoadedMapPage)
                CALL Memcpy.BetweenPages
                MEMSET_BYTE Adr.HextileBorder, 0, Size.HextileBorder            ; обнуление бордюрного буфера индексов гексагонов

                ; инициализация метаданных карты значением по умолчанию
                ; ToDo: в дальнейшем эти данные должны браться из сохранения
                LD HL, Adr.MapMetadata
                LD DE, Adr.MapMetadata+1
                LD BC, Size.MapMetadata-1
                LD (HL), MAP_META_DEFAULT_VALUE
                CALL Memcpy.FastLDIR
                JP Session.SharedCode.SetPageLoadedMap                          ; установка страницы загруженной карты

                display " - Parsing FMapDataBlockInfo for Hextile:\t\t", /A, Hextile, "\t= busy [ ", /D, $-Hextile, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_

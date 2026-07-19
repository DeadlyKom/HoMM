
                ifndef _MODULE_SESSION_MAP_DATA_BLOCK_METADATA_
                define _MODULE_SESSION_MAP_DATA_BLOCK_METADATA_
; -----------------------------------------
; обработка блока - список "точек спавна"
; In:
;   DE - указывает на адрес блока данных
;   BC - длина блока
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Metadata:       SET_PAGE_MAP                                                    ; включить страницу работы с картой
                ; инициализация метаданных карты значением по умолчанию
                ; ToDo: в дальнейшем эти данные должны браться из сохранения
                LD HL, Adr.MapMetadata
                LD DE, Adr.MapMetadata+1
                LD BC, Size.MapMetadata-1
                LD (HL), MAP_META_DEFAULT_VALUE
                CALL Memcpy.FastLDIR
                CALL Minimap.GenFog                                             ; генерация тумана для миникарты

                JP Session.SharedCode.SetPageLoadedMap                          ; установка страницы загруженной карты

                display " - Parsing FMapDataBlockInfo for 'metadata':\t\t", /A, Metadata, "\t= busy [ ", /D, $-Metadata, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_METADATA_


                ifndef _MODULE_SESSION_MAP_LOAD_METADATA_
                define _MODULE_SESSION_MAP_LOAD_METADATA_
; -----------------------------------------
; загрузка ресурса карты
; In:
;   A' - идентификатор загружаемого ресурса карты
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Metadata:       SET_PAGE_ASSETS                                                 ; включить страницу расположения менеджера ресурсов
                EX AF, AF'
                LOAD_ASSETS_A                                                   ; загрузка ресурса
                                                                                ;   HL - адрес загрузки/распаковки
                SAVE_ASSETS_PAGE \
                        Session.SharedCode.SetPageLoadedMap.LoadedMapPage       ; сохранение страницы загруженного ресурса
                RET

                display " - Load metadata map:\t\t\t\t\t", /A, Metadata, "\t= busy [ ", /D, $-Metadata, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_LOAD_METADATA_

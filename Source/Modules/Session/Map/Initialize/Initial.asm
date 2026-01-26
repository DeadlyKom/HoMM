
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
                                                                                ; должна быть включена страница расположения карты
                POP HL
                JP Session.SharedCode.SetPageLoadedMap                          ; установка страницы загруженной карты

                display " - Initial initialization of the map after loading:\t", /A, Initial, "\t= busy [ ", /D, $-Initial, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_INITIALIZE_OBJECTS_

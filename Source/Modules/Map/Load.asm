
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
Load:           POP HL                                                          ; ID загружаемой карты
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LD A, L
                PUSH AF
                LOAD_ASSETS_A                                                   ; загрузка ресурса

                ; ToDo парсинг карты

                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                POP AF
                RELEASE_ASSET_A
                
                RET

                endif ; ~_MODULE_MAP_LOAD_

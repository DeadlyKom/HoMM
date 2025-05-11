
                ifndef _MODULE_MAIN_MENU_CORE_RELEASE_ASSET_
                define _MODULE_MAIN_MENU_CORE_RELEASE_ASSET_
; -----------------------------------------
; освобождение текущего ресурса
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
ReleaseAsset:   SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LD A, ASSETS_ID_MAIN_MENU                                       ; идентификатора текущего ассета
                JP_RELEASE_ASSET_A

                display " - Utils release asset:\t\t\t\t", /A, ReleaseAsset, "\t= busy [ ", /D, $-ReleaseAsset, " byte(s)  ]"

                endif ; ~_MODULE_MAIN_MENU_CORE_RELEASE_ASSET_

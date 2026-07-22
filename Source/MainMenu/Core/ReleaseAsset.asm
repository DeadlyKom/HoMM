
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
                JP_RELEASE_ASSET ASSETS_ID_MAIN_MENU                            ; освобождение ассета
                
                display " - Utilities release asset:\t\t\t\t", /A, ReleaseAsset, "\t= busy [ ", /D, $-ReleaseAsset, " byte(s)  ]"

                endif ; ~_MODULE_MAIN_MENU_CORE_RELEASE_ASSET_

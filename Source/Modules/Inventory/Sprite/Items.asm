
                ifndef _MODULE_INVENTORY_SPRITE_ITEMS_
                define _MODULE_INVENTORY_SPRITE_ITEMS_

                module Items
; -----------------------------------------
; загрузка ресурсов предметов
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   ℹ️ код расположен в "общей памяти"
;   при выходе включена страница модуля "инвентаря"
;
;   ⚠️ ВАЖНО ⚠️
;   меняет страницу памяти
; -----------------------------------------
Load:           ; -----------------------------------------
                ; загрузка графического ресурса предметов
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                LOAD_ASSETS ASSETS_ID_UI_ITEMS_PACK

                ; сохранение страницы и адреса графики предметов
                SET_MODULE_PAGE_Inventory                                       ; включение страницы модуля "инвентаря"
                SAVE_ASSETS_PAGE Inventory.SharedCode.Render.Item.Page          ; сохранение страницы загруженного ресурса
                SAVE_ASSETS_ADDRESS Inventory.SharedCode.Render.Item.Address    ; сохранение адреса загруженного ресурса

                ; -----------------------------------------
                ; загрузка ресурса метаданных предметов
                SET_PAGE_ASSETS                                                 ; включение страницы менеджера ресурсов
                LOAD_ASSETS ASSETS_ID_ITEMS_METADATA_PACK

                ; сохранение страницы и адреса метаданных предметов
                SET_MODULE_PAGE_Inventory                                       ; включение страницы модуля "инвентаря"
                SAVE_ASSETS_PAGE Inventory.SharedCode.Render.Item.Metadata.Page ; сохранение страницы загруженного ресурса
                SAVE_ASSETS_ADDRESS  Inventory.SharedCode.Render.Item.Metadata.Adr ; сохранение адреса загруженного ресурса
                RET

                display " - Load item resources:\t\t\t\t\t", /A, Load, "\t= busy [ ", /D, $-Load, " byte(s) ]"
                endmodule

                endif ; ~_MODULE_INVENTORY_SPRITE_ITEMS_

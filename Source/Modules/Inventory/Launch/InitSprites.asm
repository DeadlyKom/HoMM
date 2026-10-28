
                ifndef _MODULE_INVENTORY_INIT_SPRITES_
                define _MODULE_INVENTORY_INIT_SPRITES_
; -----------------------------------------
; загрузка и инициализация спрайтов
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
InitSprites:    ; инициализация спрайтов
                MEMCPY Inventory.Adr.Deploy.Sprite, Adr.CodeToScr, \
                        Inventory.Size.Deploy.Sprite                            ; копирование блока
                CALL Inventory.Sprite.Items.Load                                ; загрузка графики предметов
                CALL Inventory.Sprite.PaperDoll.Load                            ; загрузка и инициализация спрайтов "образа персонажа"
                JP_SET_MODULE_PAGE_Inventory                                    ; включить страницу модуля "инвентаря"

                endif ; ~_MODULE_INVENTORY_INIT_SPRITES_

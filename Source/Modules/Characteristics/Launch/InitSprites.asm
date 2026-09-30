
                ifndef _MODULE_CHARACTERISTICS_INIT_SPRITES_
                define _MODULE_CHARACTERISTICS_INIT_SPRITES_
; -----------------------------------------
; загрузка и инициализация спрайтов
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "характеристик"
; -----------------------------------------
InitSprites:    ; инициализация спрайтов
                MEMCPY Characteristics.Adr.Deploy.Sprite, Adr.CodeToScr, \
                        Characteristics.Size.Deploy.Sprite                      ; копирование блока
                CALL Characteristics.Sprite.PaperDoll.Load                      ; загрузка и инициализация спрайтов "образа персонажа"
                JP_SET_MODULE_PAGE_Characteristics                              ; включить страницу модуля "Characteristics"

                endif ; ~_MODULE_CHARACTERISTICS_INIT_SPRITES_


                ifndef _MODULE_INVENTORY_WINDOW_
                define _MODULE_INVENTORY_WINDOW_
; -----------------------------------------
; отображение окна "инвентаря"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
Window:         SHOW_SHADOW_SCREEN                                              ; отображение теневого экрана
                CALL Inventory.Display.Window                                   ; отображение содержимого окна
                HALT                                                            ; синхронизация
                SHOW_BASE_SCREEN                                                ; отображение базового экрана
                JP Func.ShadowScrcpyInPage                                      ; копирование в теневой экран (находясь в странице)

                display " - Display window:\t\t\t\t\t\t\t= busy [ ", /D, $-Window, " byte(s) ]"

                endif ; ~_MODULE_INVENTORY_WINDOW_

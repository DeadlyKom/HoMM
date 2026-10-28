
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

                ; подготовка основного экрана
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана

                ; вывод изобращения
                CALL Convert.SetBaseScreen                                      ; выбор основного экрана для вывода окна
                CALL Inventory.Display.PaperDoll                                ; отображение "образа персонажа"
                CALL Inventory.Display.Inventory                                ; отображение "инвентаря"
                CALL Inventory.Display.Items                                    ; отображение "предметов"
                
                HALT
                SHOW_BASE_SCREEN                                                ; отображение базового экрана
                JP Func.ShadowScrcpyInPage                                      ; копирование в теневой экран (находясь в странице)

                display " - Display window:\t\t\t\t\t\t\t= busy [ ", /D, $-Window, " byte(s) ]"

                endif ; ~_MODULE_INVENTORY_WINDOW_

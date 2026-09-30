
                ifndef _MODULE_CHARACTERISTICS_WINDOW_
                define _MODULE_CHARACTERISTICS_WINDOW_
; -----------------------------------------
; отображение игрового окна
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "характеристик"
; -----------------------------------------
Window:         SHOW_SHADOW_SCREEN                                              ; отображение теневого экрана
                ; ATTR_IPB SCR_ADR_BASE, BLACK, BLACK, 0                          ; скрытие атрибутами основного экрана
                
                ; подготовка основного экрана
                CLS SCR_ADR_BASE, 0xFF                                          ; очистка основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; очистка атрибутов основного экрана

                CALL Characteristics.Display.PaperDoll                          ; отображение "образа персонажа"
                
                HALT
                SHOW_BASE_SCREEN                                                ; отображение базового экрана
                JP Func.ShadowScrcpyInPage                                      ; копирование в теневой экран (находясь в странице)

                display " - Display window:\t\t\t\t\t\t\t= busy [ ", /D, $-Window, " byte(s) ]"

                endif ; ~_MODULE_CHARACTERISTICS_WINDOW_


                ifndef _MODULE_COMBAT_WINDOW_
                define _MODULE_COMBAT_WINDOW_
; -----------------------------------------
; отображение окна "сражения"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "сражения"
; -----------------------------------------
Window:         SHOW_SHADOW_SCREEN                                              ; отображение теневого экрана
                CALL Combat.Display.Window                                      ; отображение содержимого окна
                HALT                                                            ; синхронизация
                SHOW_BASE_SCREEN                                                ; отображение базового экрана
                JP Func.ShadowScrcpyInPage                                      ; копирование в теневой экран (находясь в странице)

                display " - Display window:\t\t\t\t\t\t\t= busy [ ", /D, $-Window, " byte(s) ]"

                endif ; ~_MODULE_COMBAT_WINDOW_

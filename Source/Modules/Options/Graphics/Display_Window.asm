
                ifndef _MODULE_OPTIONS_GRAPHICS_DISPLAY_WINDOW_
                define _MODULE_OPTIONS_GRAPHICS_DISPLAY_WINDOW_
; -----------------------------------------
; отображение окна "опций" на основном экране
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "опций"
; -----------------------------------------
Window:         ; подготовка основного экрана
                CLS SCR_ADR_BASE, 0xFF                                          ; заполнение пикселей основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; установка исходных атрибутов окна
                RET

                endif ; ~_MODULE_OPTIONS_GRAPHICS_DISPLAY_WINDOW_

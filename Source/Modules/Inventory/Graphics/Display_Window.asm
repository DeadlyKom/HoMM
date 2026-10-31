
                ifndef _MODULE_INVENTORY_GRAPHICS_DISPLAY_WINDOW_
                define _MODULE_INVENTORY_GRAPHICS_DISPLAY_WINDOW_
; -----------------------------------------
; перерисовка окна инвентаря с запросом обновления экрана
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
;   ресурсы окна и предметов должны быть загружены
; -----------------------------------------
Window.Redraw:  ; сброс обрабатываемого запроса перерисовки фона
                LD HL, Inventory.States.HoveredItem.Flags
                RES_FLAG INVENTORY_REDRAW_BIT
                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос показа перерисованного окна
; -----------------------------------------
; отображение окна инвентаря на основном экране
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
;   ресурсы окна и предметов должны быть загружены
;   видимые слоты восстанавливаются без тика анимации
; -----------------------------------------
Window:         ; подготовка основного экрана
                CLS SCR_ADR_BASE, 0xFF                                          ; заполнение пикселей основного экрана
                ATTR_IPB SCR_ADR_BASE, BLACK, WHITE, 0                          ; установка исходных атрибутов окна

                ; отображение содержимого окна
                CALL Convert.SetBaseScreen                                      ; выбор основного экрана для вывода окна
                CALL Inventory.Display.PaperDoll                                ; отображение образа персонажа
                CALL Inventory.Display.Inventory                                ; отображение сетки инвентаря
                CALL Inventory.Display.Items                                    ; отображение предметов в сетке инвентаря
                JP Inventory.Display.Slots.Redraw                               ; перерисовка текущего состояния слотов

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_WINDOW_

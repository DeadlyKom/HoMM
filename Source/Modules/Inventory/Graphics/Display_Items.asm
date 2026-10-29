
                ifndef _MODULE_INVENTORY_GRAPHICS_DISPLAY_ITEMS_
                define _MODULE_INVENTORY_GRAPHICS_DISPLAY_ITEMS_
; -----------------------------------------
; отображение предметов в инвентаре
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
;   основной экран должен быть выбран перед вызовом
;   ресурсы графики и базовых описаний предметов должны быть загружены
; -----------------------------------------
Items:          ; проверка наличия предметов
                LD A, (GameState.ItemsNum)
                OR A
                RET Z                                                           ; выход, если массив предметов пуст

                ; инициализация 
                LD B, A

.Loop           ; отображение текущего экземпляра предмета в сетке
                PUSH BC                                                         ; сохранение счётчика и идентификатора
                LD A, B
                DEC A
                CALL Inventory.SharedCode.Render.Item.Grid
                POP BC
                DJNZ .Loop

                RET

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_ITEMS_

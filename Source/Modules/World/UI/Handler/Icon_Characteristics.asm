
                ifndef _MODULE_WORLD_UI_HANDLER_ICON_CHARACTERISTICS_
                define _MODULE_WORLD_UI_HANDLER_ICON_CHARACTERISTICS_
; -----------------------------------------
; обработчик иконки характеристик
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
; -----------------------------------------
Characteristics:; проверка нажатия клавиши "выбор"
                LD A, (GameState.Input.Value)
                BIT SELECT_KEY_BIT, A
                RET Z                                                           ; выход, если клавиша "выбор" не нажата

                ; запрос смены UI режима на характеристики
                LD A, UI_MODE_CHARACTERISTICS
                JP UI.Runtime.Request

                endif ; ~_MODULE_WORLD_UI_HANDLER_ICON_CHARACTERISTICS_

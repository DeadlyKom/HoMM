
                ifndef _MODULE_INVENTORY_GRAPHICS_DISPLAY_DESCRIPTION_
                define _MODULE_INVENTORY_GRAPHICS_DISPLAY_DESCRIPTION_
; -----------------------------------------
; отображение описания указанного предмета
; In:
; Out:
;   флаг Z установлен
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
;   область полностью помещается на основном экране
; -----------------------------------------
Description:    ; проверка запроса рисования нового описания
                LD HL, Inventory.States.HoveredItem.Flags
                CHECK_FLAG INVENTORY_DESCRIPTION_BIT
                JR NZ, .NewDescription                                          ; переход, если запрошено новое описание

                ; проверка необходимости восстановления существующей плашки
                CHECK_MAIN_FLAG ML_UPDATE_BIT
                RET Z                                                           ; выход, если обновление экрана не запрошено

                JR .Redraw

.NewDescription ; сброс обрабатываемого запроса рисования описания
                RES_FLAG INVENTORY_DESCRIPTION_BIT

                ; проверка наличия предмета для подготовки описания
                LD A, (Inventory.States.HoveredItem.ID)
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если предмет под курсором отсутствует

                CALL .Prepare                                                   ; формирование размера и положения плашки

.Redraw         ; проверка наличия предмета для отображения описания
                LD A, (Inventory.States.HoveredItem.ID)
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если предмет под курсором отсутствует

                CALL .Underlay                                                  ; подготовка подложки по сохранённым границам
                CALL .Text                                                      ; отображение текста на подготовленной плашке
                XOR A                                                           ; установка признака завершения отображения описания
                RET

                include "Description/Include.inc"

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_DESCRIPTION_

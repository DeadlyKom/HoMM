                ifndef _MODULE_INVENTORY_UI_UTILITIES_GET_SLOT_BY_POINT_
                define _MODULE_INVENTORY_UI_UTILITIES_GET_SLOT_BY_POINT_
; -----------------------------------------
; определение слота под курсором
; In:
;   HL - координаты в пикселях (H - y, L - x)
; Out:
;   E  - индекс слота или ITEM_ID_NONE
;   флаг переполнения установлен, если слот найден
; Corrupt:
;   DE, BC, AF, IX
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
GetSlotByPoint: ; подготовка обхода областей слотов интерфейса
                LD IX, Inventory.UI.Equipment
                LD BC, Inventory.UI.Equipment.ElementNum << 8

.SlotLoop       ; проверка попадания в область слота по горизонтали
                LD A, L
                SUB (IX + FUIElement.Location + FVector8.X)
                JR C, .NextSlot                                                 ; переход, если точка находится левее слота
                CP (IX + FUIElement.Size + FSize.Width)
                JR NC, .NextSlot                                                ; переход, если точка находится правее слота

                ; проверка попадания в область слота по вертикали
                LD A, H
                SUB (IX + FUIElement.Location + FVector8.Y)
                JR C, .NextSlot                                                 ; переход, если точка находится выше слота
                CP (IX + FUIElement.Size + FSize.Height)
                JR NC, .NextSlot                                                ; переход, если точка находится ниже слота
                LD E, C
                SCF                                                             ; установка флага переполнения, слот под точкой найден
                RET

.NextSlot       ; переход к следующей области слота
                LD DE, FUIElement
                ADD IX, DE
                INC C
                DJNZ .SlotLoop

                LD E, ITEM_ID_NONE
                OR A
                RET

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_GET_SLOT_BY_POINT_

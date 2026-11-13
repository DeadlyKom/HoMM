                ifndef _MODULE_INVENTORY_UI_UTILITIES_REFRESH_HOVER_
                define _MODULE_INVENTORY_UI_UTILITIES_REFRESH_HOVER_
; -----------------------------------------
; обновление предмета под курсором после размещения
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
RefreshHover:   ; определение слота под текущей позицией курсора
                LD HL, (Mouse.Position)
                ; -----------------------------------------
                ; In:
                ;   HL - координаты в пикселях (H - y, L - x)
                ; Out:
                ;   E  - индекс слота или ITEM_ID_NONE
                ;   флаг переполнения установлен, если слот найден
                ; Corrupt:
                ;   DE, BC, AF, IX
                ; -----------------------------------------
                CALL GetSlotByPoint
                JR NC, .GridHover                                               ; переход, если курсор находится вне слотов экипировки

                ; определение предмета в найденном слоте
                LD A, E
                ADD A, FCharacter.Equipment
                LD E, A
                ; -----------------------------------------
                ; In:
                ;   E  - смещение поля слота относительно начала FCharacter
                ; Out:
                ;   HL - адрес идентификатора предмета в слоте экипировки
                ;   E  - идентификатор предмета или ITEM_ID_NONE
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL_IN_PAGE Page.Object, Inventory.SharedCode.Utilities.GetItemBySlot; определение предмета в слоте экипировки
                JP SetHoverItem

.GridHover      ; определение предмета под курсором в сетке
                LD A, (GameState.Inventory.Page)
                ; -----------------------------------------
                ; In:
                ; Out:
                ;   E  - идентификатор экземпляра предмета или ITEM_ID_NONE
                ;   флаг переполнения установлен, если предмет найден
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IX, IY
                ; -----------------------------------------
                CALL_IN_PAGE_A Inventory.SharedCode.Utilities.GetItemByCursor.Wrap; определение предмета под курсором в сетке "инвентаря"
                JP SetHoverItem

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_REFRESH_HOVER_

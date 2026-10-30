
                ifndef _INVENTORY_UTILITIES_GET_ITEM_BY_SLOT_
                define _INVENTORY_UTILITIES_GET_ITEM_BY_SLOT_
; -----------------------------------------
; определение предмета в слоте экипировки
; In:
;   E  - смещение поля слота относительно начала FCharacter
; Out:
;   E  - идентификатор предмета или ITEM_ID_NONE
; Corrupt:
;   HL, DE, AF
; Note:
;   ℹ️ код расположен в "общей памяти"
;   необходимо включить страницу объектов
; -----------------------------------------
GetItemBySlot:  ; получение адреса выбранного персонажа
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CALL Character.Utilities.GetAdr.HL

                ; расчёт адреса поля слота экипировки
                LD D, #00
                ADD HL, DE

                ; чтение идентификатора предмета из слота экипировки
                LD E, (HL)
                RET

                endif ; ~_INVENTORY_UTILITIES_GET_ITEM_BY_SLOT_

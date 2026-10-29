
                ifndef _INVENTORY_RENDER_EQUIPMENT_
                define _INVENTORY_RENDER_EQUIPMENT_
; -----------------------------------------
; отображение предмета в слоте экипировки
; In:
;   A  - индекс слота в FCharacterEquipment
;   DE - экранная позиция слота в знакоместах
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Equipment:      ; сохранение индекса слота
                LD C, A

                ; подготовка восстановления страницы при выходе
                PUSH_PAGE
                LD HL, Func.PopPage
                PUSH HL

                ; сохранение экранной позиции и индекса слота
                PUSH DE
                PUSH BC
                SET_PAGE_OBJECT
                POP BC

                ; получение адреса выбранного персонажа
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CALL Character.Utilities.GetAdr.HL

                ; расчёт адреса идентификатора предмета в экипировке
                LD A, C
                ADD A, FCharacter.Equipment
                ADD A, L
                LD L, A

                ; чтение идентификатора и восстановление экранной позиции
                LD A, (HL)
                POP DE

                ; проверка наличия предмета в слоте
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если слот экипировки пуст
                JP Inventory.SharedCode.Render.Item                             ; отображение предмета по позиции слота

                endif                                                           ; ~_INVENTORY_RENDER_EQUIPMENT_

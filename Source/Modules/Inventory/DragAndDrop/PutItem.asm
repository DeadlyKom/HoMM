                ifndef _MODULE_INVENTORY_DRAG_AND_DROP_PUT_ITEM_
                define _MODULE_INVENTORY_DRAG_AND_DROP_PUT_ITEM_
; -----------------------------------------
; размещение взятого предмета в сетке или слоте экипировки
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   при невозможности размещения предмет остаётся в руках
; -----------------------------------------
PutItem:        ; проверка запроса размещения предмета
.Request        FLAG_MODIFY 0                                                   ; флаг, запроса размещения предмета
                RET NC                                                          ; выход, если размещение не запрошено

                RES_FLAG_MODIFY .Request                                        ; сброс обрабатываемого запроса размещения

                ; проверка активности перетаскивания
                CHECK_INPUT_FLAG INPUT_DRAG_DROP_BIT
                RET Z                                                           ; выход, если перетаскивание неактивно

                ; проверка наличия взятого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если взятый предмет отсутствует

                ; чтение позиции курсора и локальной точки захвата
.Cursor         EQU $+1                                                         ; позиция курсора в пикселях
                LD HL, #0000
                ; -----------------------------------------
                ; In:
                ;   HL - позиция курсора в пикселях (H - y, L - x)
                ; Out:
                ;   флаг переполнения установлен, если курсор находится в области слота
                ; Corrupt:
                ;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
                ; -----------------------------------------
                CALL EquipItem                                                  ; обработка размещения взятого предмета в слоте под курсором
                RET C                                                           ; выход, если курсор находится в области слота экипировки

                ; определение позиции размещения с учётом частичного пересечения
                LD HL, (.Cursor)
                ; -----------------------------------------
                ; In:
                ;   HL - позиция курсора в пикселях (H - y, L - x)
                ; Out:
                ;   DE - позиция в ячейках сетки (D - y, E - x)
                ;   флаг переполнения установлен, если предмет пересекает сетку
                ; Corrupt:
                ;   HL, DE, BC, AF
                ; -----------------------------------------
                CALL Inventory.Utilities.Grid.GetPosition
                RET NC                                                          ; выход, если предмет не пересекает сетку
                LD (.Position), DE

                ; проверка размещения в сетке или обмена с одним предметом
                LD BC, (Inventory.States.DraggedItem.Size)
                LD DE, (.Position)
                ; -----------------------------------------
                ; In:
                ;   DE - позиция области в ячейках сетки (D - y, E - x)
                ;   BC - размер области в знакоместах (B - y, C - x)
                ; Out:
                ;   E  - идентификатор заменяемого предмета или ITEM_ID_NONE
                ;   флаг переполнения установлен, если размещение или обмен разрешены
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IY
                ; -----------------------------------------
                CALL Inventory.Utilities.Grid.CheckFree.Swap
                RET NC                                                          ; выход, если область пересекает несколько предметов
                LD IXL, E

                ; проверка наличия предмета для обмена
                LD A, IXL
                CP ITEM_ID_NONE
                JR Z, .Place                                                    ; переход, если область сетки свободна

                ; подготовка размера предмета, который останется в руках
                
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор экземпляра предмета
                ; Out:
                ;   BC - размер в знакоместах (B - y, C - x)
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Item.ReadSize
                ; -----------------------------------------
                ; In:
                ;   BC - размер в знакоместах (B - y, C - x)
                ; Out:
                ;   флаг переполнения установлен, если размер сохранён
                ; Corrupt:
                ;   AF
                ; -----------------------------------------
                CALL Inventory.Utilities.DraggedItem.SetSize
                RET NC                                                          ; выход, если заменяемый предмет не поддерживается переносом

.Place          ; удаление переносимого изображения перед размещением в сетке
                CALL Inventory.Display.DraggedItem.Restore

                ; формирование обычного размещения в сетке выбранного персонажа
                XOR A
                LD (Inventory.Utilities.Buffer + FItemLocation.State), A
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD (Inventory.Utilities.Buffer + FItemLocation.Container), A
.Position       EQU $+1                                                         ; позиция размещения в ячейках сетки
                LD HL, #0000
                LD (Inventory.Utilities.Buffer + FItemLocation.Position), HL

                ; запись нового размещения предмета
                LD A, (Inventory.States.DraggedItem.ID)
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор экземпляра предмета
                ;   Inventory.Utilities.Buffer - подготовленная запись FItemLocation
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Item.WritePlacement

                ; вызов звукового события размещённого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL .Sound

                ; проверка завершения перетаскивания без обмена
                LD A, IXL
                CP ITEM_ID_NONE
                JP Z, Complete                                                  ; переход, если область сетки была свободна

                ; формирование размещения заменяемого предмета в руках
                LD HL, ITEM_LOCATION_DRAGGED
                LD (Inventory.Utilities.Buffer + FItemLocation.State), HL
                LD HL, #0000
                LD (Inventory.Utilities.Buffer + FItemLocation.Position), HL
                LD A, IXL
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор экземпляра предмета
                ;   Inventory.Utilities.Buffer - подготовленная запись FItemLocation
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Item.WritePlacement

                ; продолжение перетаскивания заменённого предмета с прежней точкой захвата
                LD A, IXL
                LD (Inventory.States.DraggedItem.ID), A
                LD HL, Inventory.States.HoveredItem.Flags
                SET INVENTORY_REDRAW_BIT, (HL)
                RET
; -----------------------------------------
; звуковое событие размещения предмета
; In:
;   A  - идентификатор размещённого предмета
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   звук выбирается по предмету, пока без воспроизведения
; -----------------------------------------
.Sound          RET

                endif ; ~_MODULE_INVENTORY_DRAG_AND_DROP_PUT_ITEM_

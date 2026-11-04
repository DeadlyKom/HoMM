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

                ; -----------------------------------------
                ; определение позиции размещения в сетке
                ; -----------------------------------------
                ; определение горизонтальной позиции с учётом частичного пересечения
                LD A, (Inventory.States.DraggedItem.GrabOffset)
                LD E, A
                LD A, (Inventory.States.DraggedItem.Size)
                LD B, A
                LD C, SCR_INVENTORY_POS_X
                LD D, SCR_INVENTORY_SIZE_X
                LD H, SCREEN_CURSOR_X >> 3
                LD A, (.Cursor)
                ; -----------------------------------------
                ; In:
                ;   H - размер экрана в знакоместах
                ;   D - размер сетки в ячейках
                ;   E - смещение точки захвата в пикселях
                ;   B - размер предмета в знакоместах
                ;   C - начало сетки в знакоместах
                ;   A - позиция курсора в пикселях
                ; Out:
                ;   E - позиция размещения в ячейках
                ;   флаг переполнения установлен, если пересечения с сеткой нет
                ; Corrupt:
                ;   HL, DE, BC, AF
                ; -----------------------------------------
                CALL Inventory.Utilities.Grid.Axis
                RET C                                                           ; выход, если предмет не пересекает сетку по горизонтали
                LD A, E
                LD (.Position), A

                ; определение вертикальной позиции с учётом частичного пересечения
                LD A, (Inventory.States.DraggedItem.GrabOffset + FVector8.Y)
                LD E, A
                LD A, (Inventory.States.DraggedItem.Size + FSize.Height)
                LD B, A
                LD C, SCR_INVENTORY_POS_Y
                LD D, SCR_INVENTORY_SIZE_Y
                LD H, SCREEN_CURSOR_Y >> 3
                LD A, (.Cursor + FVector8.Y)
                ; -----------------------------------------
                ; In:
                ;   H - размер экрана в знакоместах
                ;   D - размер сетки в ячейках
                ;   E - смещение точки захвата в пикселях
                ;   B - размер предмета в знакоместах
                ;   C - начало сетки в знакоместах
                ;   A - позиция курсора в пикселях
                ; Out:
                ;   E - позиция размещения в ячейках
                ;   флаг переполнения установлен, если пересечения с сеткой нет
                ; Corrupt:
                ;   HL, DE, BC, AF
                ; -----------------------------------------
                CALL Inventory.Utilities.Grid.Axis
                RET C                                                           ; выход, если предмет не пересекает сетку по вертикали
                LD A, E
                LD (.Position + FVector8.Y), A
                ; -----------------------------------------

                ; проверка занятости области по размерам переносимого предмета
                LD BC, (Inventory.States.DraggedItem.Size)
                LD DE, (.Position)
                ; -----------------------------------------
                ; In:
                ;   DE - позиция области в ячейках сетки (D - y, E - x)
                ;   BC - размер области в знакоместах (B - y, C - x)
                ; Out:
                ;   флаг переполнения установлен, если область свободна
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IY
                ; -----------------------------------------
                CALL Inventory.Utilities.Grid.CheckFree
                RET NC                                                          ; выход, если область занята другим предметом

                ; удаление переносимого изображения перед завершением перетаскивания
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

                JP Complete
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

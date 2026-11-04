                ifndef _MODULE_INVENTORY_DRAG_AND_DROP_EQUIP_ITEM_
                define _MODULE_INVENTORY_DRAG_AND_DROP_EQUIP_ITEM_
; -----------------------------------------
; обработка размещения взятого предмета в слоте под курсором
; In:
;   HL - позиция курсора в пикселях (H - y, L - x)
; Out:
;   флаг переполнения установлен, если курсор находится в области слота
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   неподходящий слот не изменяет размещение предметов
; -----------------------------------------
EquipItem:      ; определение слота экипировки, в области которого находится курсор
                ; -----------------------------------------
                ; In:
                ;   HL - координаты в пикселях (H - y, L - x)
                ; Out:
                ;   E  - индекс слота или ITEM_ID_NONE
                ;   флаг переполнения установлен, если слот найден
                ; Corrupt:
                ;   DE, BC, AF, IX
                ; -----------------------------------------
                CALL Inventory.UI.Utilities.GetSlotByPoint
                RET NC                                                          ; выход, если курсор находится вне слотов
                LD IXL, E

                ; проверка соответствия типа предмета выбранному слоту
                ; -----------------------------------------
                ; In:
                ;   IXL - индекс слота
                ; Out:
                ;   IXH - тип переносимого предмета
                ;   флаг переполнения установлен, если предмет подходит слоту
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IX
                ; -----------------------------------------
                CALL Inventory.Utilities.Equipment.CheckType
                JP NC, .Failure                                                 ; переход, если предмет не подходит выбранному слоту

                ; определение уникальных предметов, вытесняемых из экипировки
                ; -----------------------------------------
                ; In:
                ;   IXL - выбранный слот
                ;   IXH - тип устанавливаемого предмета
                ; Out:
                ;   B', C' - идентификаторы вытесняемых предметов или ITEM_ID_NONE
                ; Corrupt:
                ;   HL, DE, BC, AF, BC', AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Equipment.ReadOld

                ; проверка необходимости размещения предметов из обеих рук
                LD A, IXH
                CP ITEM_TYPE_TWO_HANDED
                JR Z, .PlanHands                                                ; переход, если устанавливается двуручное оружие

.PrepareSwap    ; проверка наличия предмета, который останется в руках
                EXX
                LD A, B
                EXX
                CP ITEM_ID_NONE
                JR Z, .Commit                                                   ; переход, если вытесняемого предмета нет

                ; подготовка размера предмета, который останется в руках
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор экземпляра предмета
                ; Out:
                ;   BC - размер в знакоместах (B - y, C - x)
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Item.ReadSize                          ; чтение размера изображения экземпляра предмета
                ; -----------------------------------------
                ; In:
                ;   BC - размер в знакоместах (B - y, C - x)
                ; Out:
                ;   флаг переполнения установлен, если размер сохранён
                ; Corrupt:
                ;   AF
                ; -----------------------------------------
                CALL Inventory.Utilities.DraggedItem.SetSize                    ; проверка и сохранение размера перетаскиваемого предмета
                JP NC, .Failure                                                 ; переход, если заменяемый предмет не поддерживается переносом
                JR .Commit

.PlanHands      ; -----------------------------------------
                ; предварительная проверка размещения второго предмета в сетке
                ; -----------------------------------------

                ; поиск места для предмета из правой руки, первый предмет останется в руках
                ; -----------------------------------------
                ; In:
                ;   C' - идентификатор второго предмета или ITEM_ID_NONE
                ; Out:
                ;   HL' - найденная позиция в ячейках сетки (H' - y, L' - x), если второй предмет существует
                ;   флаг переполнения установлен, если второй предмет отсутствует или место найдено
                ; Corrupt:
                ;   HL, DE, BC, AF, HL', AF', IY
                ; -----------------------------------------
                CALL Inventory.Utilities.Grid.PlanDisplaced
                JP NC, .Failure                                                 ; переход, если для второго вытесняемого предмета нет места
                JR .PrepareSwap

.Commit         ; -----------------------------------------
                ; изменение экипировки после успешной проверки размещения
                ; -----------------------------------------

                ; удаление переносимого изображения перед изменением экипировки
                CALL Inventory.Display.DraggedItem.Restore

                ; освобождение всех ссылок на вытесняемые предметы
                EXX
                LD A, B
                EXX
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор предмета или ITEM_ID_NONE
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IY
                ; -----------------------------------------
                CALL Inventory.Utilities.Equipment.UnequipItem                  ; первый вытесняемый предмет, 
                                                                                ; для двуручного оружия - левая или единственная правая рука
                EXX
                LD A, C
                EXX
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор предмета или ITEM_ID_NONE
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IY
                ; -----------------------------------------
                CALL Inventory.Utilities.Equipment.UnequipItem                  ; второй вытесняемый предмет, правая рука

                ; проверка наличия предмета для продолжения перетаскивания
                EXX
                LD A, B
                EXX
                CP ITEM_ID_NONE
                JR Z, .NewItem                                                  ; переход, если заменяемого предмета нет

                ; формирование размещения заменяемого предмета в руках
                LD HL, ITEM_LOCATION_DRAGGED
                LD (Inventory.Utilities.Buffer + FItemLocation.State), HL
                LD HL, #0000
                LD (Inventory.Utilities.Buffer + FItemLocation.Position), HL
                EXX
                LD A, B
                EXX
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор экземпляра предмета
                ;   Inventory.Utilities.Buffer - подготовленная запись FItemLocation
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Item.WritePlacement                    ; запись размещения из общего буфера в страницу предметов

.OldToGrid      ; проверка наличия второго вытесняемого предмета для размещения в сетке
                EXX
                LD A, C
                EXX
                CP ITEM_ID_NONE
                JR Z, .NewItem                                                  ; переход, если второго вытесняемого предмета нет

                ; запись размещения предмета из правой руки в найденное место
                CALL Inventory.Utilities.Grid.PrepareRecord
                EXX
                PUSH HL
                EXX
                POP HL
                LD (Inventory.Utilities.Buffer + FItemLocation.Position), HL
                EXX
                LD A, C
                EXX
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор экземпляра предмета
                ;   Inventory.Utilities.Buffer - подготовленная запись FItemLocation
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Item.WritePlacement

.NewItem        ; формирование размещения устанавливаемого предмета
                LD A, ITEM_LOCATION_EQUIPPED | ITEM_ITEM_POSITION_CUSTOM
                LD (Inventory.Utilities.Buffer + FItemLocation.State), A
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD (Inventory.Utilities.Buffer + FItemLocation.Container), A
                LD HL, #FFFF                                                    ; отсутствие позиции в сетке, X и Y равны #FF
                LD (Inventory.Utilities.Buffer + FItemLocation.Position), HL
                LD A, (Inventory.States.DraggedItem.ID)
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор экземпляра предмета
                ;   Inventory.Utilities.Buffer - подготовленная запись FItemLocation
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Item.WritePlacement                    ; запись размещения из общего буфера в страницу предметов

                ; проверка установки предмета в обе руки
                LD A, IXH
                CP ITEM_TYPE_TWO_HANDED
                JR Z, .BothSlots                                                ; переход, если предмет занимает обе руки

                ; установка переносимого предмета в указанный слот
                LD A, IXL
                LD IYL, A
                ; -----------------------------------------
                ; In:
                ;   IYL - индекс слота
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Equipment.EquipSlot
                JR .Equipped

.BothSlots      ; установка переносимого предмета в оба слота рук
                LD IYL, FCharacterEquipment.LeftHand.ID
                ; -----------------------------------------
                ; In:
                ;   IYL - индекс слота
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Equipment.EquipSlot                    ; слот левой руки
                LD IYL, FCharacterEquipment.RightHand.ID
                ; -----------------------------------------
                ; In:
                ;   IYL - индекс слота
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.Equipment.EquipSlot                    ; слот правой руки

.Equipped       ; сброс готовности буферов после изменения содержимого слотов
                CALL Inventory.Display.Slots.ResetBuffers

                ; вызов звукового события экипированного предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL .Sound

                ; проверка продолжения перетаскивания заменённого предмета
                EXX
                LD A, B
                EXX
                CP ITEM_ID_NONE
                JR Z, .Finish                                                   ; переход, если вытесняемых предметов не было

                ; передача заменённого предмета в руки с сохранением точки захвата
                LD (Inventory.States.DraggedItem.ID), A
                LD HL, Inventory.States.HoveredItem.Flags
                SET INVENTORY_REDRAW_BIT, (HL)
                SCF                                                             ; установка флага переполнения, курсор находится в области слота
                RET

.Finish         ; завершение перетаскивания после успешной установки
                CALL Complete
                SCF                                                             ; установка флага переполнения, курсор находится в области слота
                RET

.Failure        ; вызов звукового события неудачной установки
                CALL .FailureSound
                SCF                                                             ; установка флага переполнения, курсор находится в области слота
                RET
                ; -----------------------------------------
; -----------------------------------------
; звуковое событие установки предмета в экипировку
; In:
;   A  - идентификатор установленного предмета
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.Sound          RET
; -----------------------------------------
; звуковое событие неудачной установки предмета
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.FailureSound   RET

                endif ; ~_MODULE_INVENTORY_DRAG_AND_DROP_EQUIP_ITEM_

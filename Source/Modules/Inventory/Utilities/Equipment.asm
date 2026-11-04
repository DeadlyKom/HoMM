                ifndef _MODULE_INVENTORY_UTILITIES_EQUIPMENT_
                define _MODULE_INVENTORY_UTILITIES_EQUIPMENT_
                module Equipment
; -----------------------------------------
; проверка соответствия типа предмета выбранному слоту
; In:
;   IXL - индекс слота
; Out:
;   IXH - тип переносимого предмета
;   флаг переполнения установлен, если предмет подходит слоту
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
CheckType:      ; чтение базового описания переносимого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                LD DE, Inventory.Utilities.Buffer
                ; -----------------------------------------
                ; In:
                ;   DE - адрес временного буфера в общей памяти
                ;   A  - идентификатор экземпляра предмета
                ; Out:
                ;   HL - адрес копии FItem
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.SharedCode.Utilities.GetItem                     ; получение копии экземпляра предмета
                LD A, (HL)
                LD DE, Inventory.Utilities.Buffer
                ; -----------------------------------------
                ; In:
                ;   DE - адрес временного буфера в общей памяти
                ;   A  - индекс базового предмета
                ; Out:
                ;   HL - адрес копии FBaseItem с массивом FItemProperty
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.SharedCode.Utilities.GetBaseItem                 ; получение копии базового описания предмета со свойствами
                LD DE, FBaseItem.Type
                ADD HL, DE
                LD A, (HL)
                LD IXH, A

                ; расчёт адреса обработчика по типу предмета
                ADD A, A    ; x2
                LD E, A
                LD D, #00
                LD HL, .TypeTable
                ADD HL, DE

                ; чтение адреса обработчика выбранного типа предмета
                LD E, (HL)
                INC HL                                                          ; переход к старшему байту адреса обработчика
                LD D, (HL)
                EX DE, HL
                JP (HL)

.Head           LD A, FCharacterEquipment.Head.ID
                JR .Slot

.Breast         LD A, FCharacterEquipment.Breast.ID
                JR .Slot

.Amulet         LD A, FCharacterEquipment.Amulet.ID
                JR .Slot

.LeftHand       LD A, FCharacterEquipment.LeftHand.ID
                JR .Slot

.Belt           LD A, FCharacterEquipment.Belt.ID
                JR .Slot

.ShoulderPad    LD A, FCharacterEquipment.ShoulderPad.ID
                JR .Slot

.Boot           LD A, FCharacterEquipment.Boot.ID

.Slot           ; проверка соответствия выбранного слота типу предмета
                CP IXL
                JR NZ, .Rejected                                                ; переход, если предмет не подходит выбранному слоту

                SCF                                                             ; установка флага переполнения, предмет подходит слоту
                RET

.Ring           ; подготовка допустимых слотов колец
                LD BC, (FCharacterEquipment.LeftRing.ID << 8) | FCharacterEquipment.RightRing.ID
                JR .Pair

.Hands          ; подготовка допустимых слотов для одноручного и двуручного оружия
                LD BC, (FCharacterEquipment.LeftHand.ID << 8) | FCharacterEquipment.RightHand.ID

.Pair           ; проверка первого допустимого слота
                LD A, IXL
                CP B
                SCF                                                             ; установка флага переполнения, предмет подходит слоту
                RET Z                                                           ; выход, если выбран первый допустимый слот

                ; проверка второго допустимого слота
                CP C
                SCF                                                             ; установка флага переполнения, предмет подходит слоту
                RET Z                                                           ; выход, если выбран второй допустимый слот

.Rejected       OR A                                                            ; сброс флага переполнения, предмет не подходит слоту
                RET

.TypeTable      ; таблица обработчиков типов предметов
                DW .Head                                                        ; ITEM_TYPE_HEAD
                DW .Breast                                                      ; ITEM_TYPE_BREAST
                DW .Amulet                                                      ; ITEM_TYPE_AMULET
                DW .Ring                                                        ; ITEM_TYPE_RING
                DW .LeftHand                                                    ; ITEM_TYPE_LEFT_HAND
                DW .Hands                                                       ; ITEM_TYPE_RIGHT_HAND
                DW .Hands                                                       ; ITEM_TYPE_TWO_HANDED
                DW .Belt                                                        ; ITEM_TYPE_BELT
                DW .ShoulderPad                                                 ; ITEM_TYPE_SHOULDER_PAD
                DW .Boot                                                        ; ITEM_TYPE_BOOT
; -----------------------------------------
; определение уникальных предметов, вытесняемых из экипировки
; In:
;   IXL - выбранный слот
;   IXH - тип устанавливаемого предмета
; Out:
;   B', C' - идентификаторы вытесняемых предметов или ITEM_ID_NONE
; Corrupt:
;   HL, DE, BC, AF, BC', AF'
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
ReadOld:        ; сброс списка вытесняемых предметов
                EXX
                LD BC, (ITEM_ID_NONE << 8) | ITEM_ID_NONE
                EXX

                ; проверка чтения обеих рук для двуручного оружия
                LD A, IXH
                CP ITEM_TYPE_TWO_HANDED
                JR Z, .ReadHands                                                ; переход, если проверяются обе руки

                ; чтение предмета из выбранного слота
                LD A, IXL
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
                LD A, E
                EXX
                LD B, A
                EXX
                RET

.ReadHands      ; чтение предметов из обеих рук
                LD E, FCharacter.Equipment.LeftHand.ID
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
                LD A, E
                EXX
                LD B, A
                EXX
                LD E, FCharacter.Equipment.RightHand.ID
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
                LD A, E
                EXX
                LD C, A
                EXX

                ; перенос единственного предмета в первую запись
                EXX
                LD A, B
                CP ITEM_ID_NONE
                JR NZ, .UniqueOld                                               ; переход, если первая запись уже содержит предмет
                LD B, C
                LD C, ITEM_ID_NONE

.UniqueOld      ; исключение повторной ссылки на тот же двуручный предмет
                LD A, B
                CP C
                JR NZ, .OldReady                                                ; переход, если ссылки относятся к разным предметам
                LD C, ITEM_ID_NONE

.OldReady       EXX
                RET
; -----------------------------------------
; освобождение всех слотов, ссылающихся на предмет
; In:
;   A  - идентификатор предмета или ITEM_ID_NONE
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
UnequipItem:    ; проверка наличия вытесняемого предмета
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если вытесняемого предмета нет
                LD IYH, A

.RemoveLoop     ; определение очередного слота с указанным предметом
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD D, A
                LD E, IYH
                ; -----------------------------------------
                ; In:
                ;   D  - индекс персонажа
                ;   E  - идентификатор предмета
                ; Out:
                ;   HL - адрес идентификатора в найденном слоте
                ;   E  - индекс найденного слота или ITEM_ID_NONE
                ;   флаг переполнения установлен, если слот найден
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL_IN_PAGE Page.Object, Character.Utilities.Equipment.FindSlot; определение слота экипировки по идентификатору предмета
                LD A, E
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если все ссылки на предмет удалены
                EX DE, HL
                ; -----------------------------------------
                ; In:
                ;   DE - адрес идентификатора в слоте экипировки
                ; Out:
                ;   HL - адрес идентификатора в слоте экипировки
                ;   E  - идентификатор снятого предмета
                ;   A  - идентификатор снятого предмета
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL_IN_PAGE Page.Object, Character.Utilities.Equipment.Unequip ; снятие предмета из указанного слота экипировки
                JR .RemoveLoop
; -----------------------------------------
; установка переносимого предмета в указанный слот
; In:
;   IYL - индекс слота
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
EquipSlot:      ; подготовка параметров установки в выбранный слот
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD D, A
                LD A, (Inventory.States.DraggedItem.ID)
                LD E, A
                ; -----------------------------------------
                ; In:
                ;   D   - индекс персонажа
                ;   E   - идентификатор устанавливаемого предмета
                ;   IYL - индекс слота в FCharacterEquipment
                ; Out:
                ;   HL - адрес идентификатора в слоте экипировки
                ;   E  - прежний идентификатор предмета в слоте
                ;   A  - прежний идентификатор предмета в слоте
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL_IN_PAGE Page.Object, Character.Utilities.Equipment.Equip   ; установка предмета в слот экипировки
                RET
                endmodule

                endif ; ~_MODULE_INVENTORY_UTILITIES_EQUIPMENT_

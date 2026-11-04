                ifndef _MODULE_INVENTORY_UI_UTILITIES_EQUIP_ITEM_
                define _MODULE_INVENTORY_UI_UTILITIES_EQUIP_ITEM_
; -----------------------------------------
; обработка размещения взятого предмета в слоте под точкой нажатия
; In:
;   HL - позиция нажатия в пикселях, H - y, L - x
; Out:
;   флаг переполнения установлен, если нажатие относится к слоту, иначе сброшен
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
;   неподходящий слот не изменяет размещение предметов
;   до завершения проверки экипировка и размещение не изменяются
;   B' и C' хранят идентификаторы вытесняемых предметов
;   DE' и HL' хранят найденные для них позиции в ячейках сетки
; -----------------------------------------
EquipItem:      ; определение слота по всей области под точкой нажатия
                CALL .FindSlot
                RET NC                                                          ; выход, если нажатие находится вне слотов
                LD IXL, E

                ; проверка соответствия типа предмета выбранному слоту
                CALL .CheckType
                JP NZ, .Failure                                                 ; переход, если предмет не подходит выбранному слоту

                ; определение уникальных вытесняемых предметов
                CALL .ReadOld
                RES_FLAG_MODIFY .Reserve

                ; проверка необходимости размещения предметов из обеих рук
                LD A, IXH
                CP ITEM_TYPE_TWO_HANDED
                JR Z, .PlanHands                                                ; переход, если устанавливается двуручное оружие

                ; проверка наличия предмета для обычного обмена
                EXX
                LD A, B
                EXX
                CP ITEM_ID_NONE
                JR Z, .Commit                                                   ; переход, если выбранный слот свободен

                ; подготовка размера предмета, который останется в руках
                CALL TakeItem.ReadSize
                CALL TakeItem.SetSize
                JP NC, .Failure                                                 ; переход, если заменяемый предмет не поддерживается переносом
                JR .Commit

                ; -----------------------------------------
                ; предварительная проверка размещения предметов из обеих рук
                ; -----------------------------------------
.PlanHands      ; проверка наличия вытесняемых предметов
                EXX
                LD A, B
                EXX
                CP ITEM_ID_NONE
                JR Z, .Commit                                                   ; переход, если обе руки свободны
                LD DE, #0000

.FirstPlace     ; определение очередного места для первого предмета
                PUSH IX
                EXX
                LD A, B
                EXX
                CALL .FindFree
                POP IX
                JP NC, .Failure                                                 ; переход, если места для всех вытесняемых предметов нет

                ; сохранение позиции первого предмета
                PUSH DE
                EXX
                POP DE
                EXX

                ; проверка наличия второго уникального предмета
                EXX
                LD A, C
                EXX
                CP ITEM_ID_NONE
                JR Z, .Commit                                                   ; переход, если вытесняется только один предмет

                ; резервирование первого места только на время проверки второго
                SET_FLAG_MODIFY .Reserve
                LD DE, #0000
                PUSH IX
                EXX
                LD A, C
                EXX
                CALL .FindFree
                POP IX
                JR C, .SecondPlace                                              ; переход, если места для обоих предметов найдены

                ; продолжение проверки с другой позицией первого предмета
                RES_FLAG_MODIFY .Reserve
                EXX
                PUSH DE
                EXX
                POP DE
                INC E
                JR .FirstPlace

.SecondPlace    ; сохранение позиции второго предмета
                PUSH DE
                EXX
                POP HL
                EXX
                ; -----------------------------------------

                ; -----------------------------------------
                ; изменение экипировки после успешной проверки размещения
                ; -----------------------------------------
.Commit         ; удаление переносимого изображения перед изменением экипировки
                CALL Inventory.Display.DraggedItem.Restore

                ; освобождение всех ссылок на вытесняемые предметы
                EXX
                LD A, B
                EXX
                CALL .UnequipAll
                EXX
                LD A, C
                EXX
                CALL .UnequipAll

                ; выбор размещения вытесняемых предметов
                LD A, IXH
                CP ITEM_TYPE_TWO_HANDED
                JR Z, .OldToGrid                                                ; переход, если предметы из рук размещаются в сетке

                ; проверка наличия предмета для продолжения перетаскивания
                EXX
                LD A, B
                EXX
                CP ITEM_ID_NONE
                JR Z, .NewItem                                                  ; переход, если заменяемого предмета нет

                ; формирование размещения заменяемого предмета в руках
                LD HL, ITEM_LOCATION_DRAGGED
                LD (.Buffer + FItemLocation.State), HL
                LD HL, #0000
                LD (.Buffer + FItemLocation.Position), HL
                EXX
                LD A, B
                EXX
                CALL PutItem.WritePlacement
                JR .NewItem

.OldToGrid      ; проверка наличия первого предмета для размещения в сетке
                EXX
                LD A, B
                EXX
                CP ITEM_ID_NONE
                JR Z, .NewItem                                                  ; переход, если предметы из рук отсутствуют

                ; запись размещения первого предмета в найденное место
                CALL .GridRecord
                EXX
                PUSH DE
                EXX
                POP HL
                LD (.Buffer + FItemLocation.Position), HL
                EXX
                LD A, B
                EXX
                CALL PutItem.WritePlacement

                ; проверка наличия второго предмета для размещения в сетке
                EXX
                LD A, C
                EXX
                CP ITEM_ID_NONE
                JR Z, .NewItem                                                  ; переход, если второй предмет отсутствует

                ; запись размещения второго предмета в найденное место
                CALL .GridRecord
                EXX
                PUSH HL
                EXX
                POP HL
                LD (.Buffer + FItemLocation.Position), HL
                EXX
                LD A, C
                EXX
                CALL PutItem.WritePlacement

.NewItem        ; формирование размещения устанавливаемого предмета
                LD A, ITEM_LOCATION_EQUIPPED | ITEM_ITEM_POSITION_CUSTOM
                LD (.Buffer + FItemLocation.State), A
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD (.Buffer + FItemLocation.Container), A
                LD HL, #FFFF
                LD (.Buffer + FItemLocation.Position), HL
                LD A, (Inventory.States.DraggedItem.ID)
                CALL PutItem.WritePlacement

                ; проверка установки предмета в обе руки
                LD A, IXH
                CP ITEM_TYPE_TWO_HANDED
                JR Z, .BothSlots                                                ; переход, если предмет занимает обе руки

                ; установка предмета в выбранный слот
                LD A, IXL
                LD IYL, A
                CALL .EquipSlot
                JR .Equipped

.BothSlots      ; установка одного идентификатора в обе руки
                LD IYL, FCharacterEquipment.LeftHand.ID
                CALL .EquipSlot
                LD IYL, FCharacterEquipment.RightHand.ID
                CALL .EquipSlot

.Equipped       ; сброс готовности буферов после изменения содержимого слотов
                CALL .ResetSlots

                ; вызов звукового события экипированного предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL .Sound

                ; проверка завершения установки двуручного оружия
                LD A, IXH
                CP ITEM_TYPE_TWO_HANDED
                JR Z, .Finish                                                   ; переход, если предметы из рук уже размещены в сетке

                ; проверка продолжения обычного обмена
                EXX
                LD A, B
                EXX
                CP ITEM_ID_NONE
                JR Z, .Finish                                                   ; переход, если выбранный слот был свободен

                ; передача заменённого предмета в руки
                LD (Inventory.States.DraggedItem.ID), A
                CALL .Grab
                LD HL, Inventory.States.HoveredItem.Flags
                SET INVENTORY_REDRAW_BIT, (HL)
                SCF                                                             ; установка флага переполнения, нажатие обработано слотом
                RET

.Finish         ; завершение перетаскивания после успешной установки
                CALL PutItem.Finish
                SCF                                                             ; установка флага переполнения, нажатие обработано слотом
                RET

.Failure        ; вызов звукового события неудачной установки
                CALL .FailureSound
                SCF                                                             ; установка флага переполнения, нажатие обработано слотом
                RET
                ; -----------------------------------------
; -----------------------------------------
; определение слота по координатам нажатия или курсора
; In:
;   HL - координаты в пикселях, H - y, L - x
; Out:
;   E  - индекс слота или ITEM_ID_NONE
;   флаг переполнения установлен, если слот найден, иначе сброшен
; Corrupt:
;   DE, BC, AF, IX
; -----------------------------------------
.FindSlot       ; подготовка обхода областей слотов интерфейса
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
; -----------------------------------------
; проверка соответствия типа предмета выбранному слоту
; In:
;   IXL - индекс слота
; Out:
;   IXH - тип переносимого предмета
;   флаг Z установлен, если предмет подходит слоту
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; -----------------------------------------
.CheckType      ; чтение базового описания переносимого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                LD DE, .Buffer
                CALL Inventory.SharedCode.Utilities.GetItem
                LD A, (HL)
                LD DE, .Buffer
                CALL Inventory.SharedCode.Utilities.GetBaseItem
                LD DE, FBaseItem.Type
                ADD HL, DE
                LD A, (HL)
                LD IXH, A

                ; проверка слотов колец
                LD A, IXL
                CP FCharacterEquipment.LeftRing.ID
                JR C, .SingleType                                               ; переход, если выбран слот перед кольцами
                CP FCharacterEquipment.RightRing.ID + 1
                JR NC, .SingleType                                              ; переход, если выбран слот после колец
                LD A, ITEM_TYPE_RING
                JR .CompareType

.SingleType     ; проверка слотов оружия и щита
                LD A, IXL
                CP FCharacterEquipment.LeftHand.ID
                JR Z, .HandType                                                 ; переход, если выбрана левая рука
                CP FCharacterEquipment.RightHand.ID
                JR Z, .HandType                                                 ; переход, если выбрана правая рука

                ; определение типа остальных слотов экипировки
                CP FCharacterEquipment.ShoulderPad.ID
                LD A, ITEM_TYPE_SHOULDER_PAD
                JR Z, .CompareType                                              ; переход, если выбран слот наплечника
                LD A, IXL
                CP FCharacterEquipment.Belt.ID
                LD A, ITEM_TYPE_BELT
                JR Z, .CompareType                                              ; переход, если выбран слот пояса
                LD A, IXL
                CP FCharacterEquipment.Boot.ID
                LD A, ITEM_TYPE_BOOT
                JR Z, .CompareType                                              ; переход, если выбран слот обуви
                LD A, IXL

.CompareType    ; сравнение ожидаемого типа с типом предмета
                LD B, A
                LD A, IXH
                CP B
                RET

.HandType       ; проверка оружия, допустимого в обеих руках
                LD A, IXH
                CP ITEM_TYPE_TWO_HANDED
                RET Z                                                           ; выход, если предмет двуручный
                CP ITEM_TYPE_RIGHT_HAND
                RET Z                                                           ; выход, если предмет одноручный

                ; проверка предмета, допустимого только в левой руке
                LD A, IXL
                CP FCharacterEquipment.LeftHand.ID
                RET NZ                                                          ; выход, если предмет нельзя установить в правую руку
                LD A, IXH
                CP ITEM_TYPE_LEFT_HAND
                RET
; -----------------------------------------
; определение уникальных предметов, вытесняемых из экипировки
; In:
;   IXL - выбранный слот
;   IXH - тип устанавливаемого предмета
; Out:
;   B', C' - идентификаторы вытесняемых предметов или ITEM_ID_NONE
; Corrupt:
;   HL, DE, BC, AF, BC', AF'
; -----------------------------------------
.ReadOld        ; сброс списка вытесняемых предметов
                EXX
                LD B, ITEM_ID_NONE
                LD C, ITEM_ID_NONE
                EXX

                ; проверка чтения обеих рук для двуручного оружия
                LD A, IXH
                CP ITEM_TYPE_TWO_HANDED
                JR Z, .ReadHands                                                ; переход, если проверяются обе руки

                ; чтение предмета из выбранного слота
                LD A, IXL
                ADD A, FCharacter.Equipment
                LD E, A
                CALL_IN_PAGE Page.Object, Inventory.SharedCode.Utilities.GetItemBySlot
                LD A, E
                EXX
                LD B, A
                EXX
                RET

.ReadHands      ; чтение предметов из обеих рук
                LD E, FCharacter.Equipment.LeftHand.ID
                CALL_IN_PAGE Page.Object, Inventory.SharedCode.Utilities.GetItemBySlot
                LD A, E
                EXX
                LD B, A
                EXX
                LD E, FCharacter.Equipment.RightHand.ID
                CALL_IN_PAGE Page.Object, Inventory.SharedCode.Utilities.GetItemBySlot
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
; определение свободного места с учётом предварительно выбранной области
; In:
;   DE - первая проверяемая позиция в ячейках сетки
;   A  - идентификатор размещаемого предмета
; Out:
;   DE - найденная позиция
;   флаг переполнения установлен, если место найдено, иначе сброшен
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   при включённом Reserve область первого предмета считается занятой
;   IYH хранит последнюю допустимую строку в битах 7..4 и столбец в битах 3..0
; -----------------------------------------
.FindFree       ; чтение размеров с сохранением начальной позиции проверки
                PUSH DE
                CALL TakeItem.ReadSize
                POP DE

                ; проверка необходимости учитывать первый выбранный предмет
.Reserve        FLAG_MODIFY 0                                                   ; флаг, предварительного резервирования первой области
                JR NC, .Limits                                                  ; переход, если предварительно выбранной области нет

                ; чтение размеров первого предмета для проверки второй области
                PUSH BC
                PUSH DE
                EXX
                LD A, B
                EXX
                CALL TakeItem.ReadSize
                PUSH BC
                POP IX
                POP DE
                POP BC

.Limits         ; перевод ширины предмета в ячейки с округлением вверх
                LD A, C
                INC A
                SRL A

                ; расчёт последнего допустимого столбца для размещения предмета
                NEG
                ADD A, SCR_INVENTORY_SIZE_X
                LD L, A

                ; перевод высоты предмета в ячейки с округлением вверх
                LD A, B
                INC A
                SRL A

                ; расчёт последней допустимой строки для размещения предмета
                NEG
                ADD A, SCR_INVENTORY_SIZE_Y

                ; упаковка пределов в IYH, старшая тетрада - строка, младшая - столбец
                RLCA    ; x2
                RLCA    ; x4
                RLCA    ; x8
                RLCA    ; x16
                OR L
                LD IYH, A

.CheckPosition  ; проверка правой границы очередной позиции
                LD A, IYH
                AND #0F
                CP E
                JR C, .NextRow                                                  ; переход, если текущая строка проверена до правого края

                ; проверка нижней границы очередной позиции
                LD A, IYH

                ; перенос предела строки из старшей тетрады в младшую
                RRCA
                RRCA
                RRCA
                RRCA
                AND #0F
                CP D
                CCF
                RET NC                                                          ; выход, если все допустимые позиции проверены

                ; проверка пересечений с размещёнными в сетке предметами
                LD (PutItem.Position), DE
                PUSH BC
                PUSH DE
                CALL PutItem.CheckFree
                POP DE
                POP BC
                JR NC, .NextPosition                                            ; переход, если место занято предметом в сетке

                ; проверка пересечения с предварительно выбранной областью
                CHECK_FLAG_MODIFY .Reserve
                SCF                                                             ; установка флага переполнения, место свободно без дополнительного ограничения
                RET Z                                                           ; выход, если предварительно выбранной области нет
                CALL .CheckReserve
                RET C                                                           ; выход, если место свободно и не пересекает первую выбранную область

.NextPosition   ; переход к следующему столбцу сетки
                INC E
                JR .CheckPosition

.NextRow        ; переход к следующей строке сетки
                LD E, #00
                INC D
                JR .CheckPosition
; -----------------------------------------
; проверка пересечения с предварительно выбранной областью
; In:
;   DE  - проверяемая позиция в ячейках
;   BC  - размер проверяемого предмета в знакоместах
;   DE' - позиция первого предмета в ячейках
;   IX  - размер первого предмета, IXH - высота, IXL - ширина
; Out:
;   флаг переполнения установлен, если области не пересекаются
; Corrupt:
;   HL, AF
; -----------------------------------------
.CheckReserve   ; чтение позиции первой области без изменения альтернативных регистров
                EXX
                PUSH DE
                EXX
                POP HL

                ; проверка расстояния по горизонтали
                LD A, E
                SUB L
                JR C, .BeforeFirst                                              ; переход, если вторая область начинается левее первой
                ADD A, A    ; x2
                CP IXL
                CCF
                RET C                                                           ; выход, если области разнесены по горизонтали
                JR .ReserveY

.BeforeFirst    ; расчёт положительного расстояния до первой области по горизонтали
                NEG
                ADD A, A    ; x2
                CP C
                CCF
                RET C                                                           ; выход, если области разнесены по горизонтали

.ReserveY       ; проверка расстояния по вертикали
                LD A, D
                SUB H
                JR C, .AboveFirst                                               ; переход, если вторая область начинается выше первой
                ADD A, A    ; x2
                CP IXH
                CCF
                RET

.AboveFirst     ; расчёт положительного расстояния до первой области по вертикали
                NEG
                ADD A, A    ; x2
                CP B
                CCF
                RET
; -----------------------------------------
; освобождение всех слотов, ссылающихся на предмет
; In:
;   A  - идентификатор предмета или ITEM_ID_NONE
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IY
; -----------------------------------------
.UnequipAll     ; проверка наличия вытесняемого предмета
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если вытесняемого предмета нет
                LD IYH, A

.RemoveLoop     ; определение очередного слота с указанным предметом
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD D, A
                LD E, IYH
                CALL_IN_PAGE Page.Object, Character.Utilities.Equipment.FindSlot
                LD A, E
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если все ссылки на предмет удалены
                EX DE, HL
                CALL_IN_PAGE Page.Object, Character.Utilities.Equipment.Unequip
                JR .RemoveLoop
; -----------------------------------------
; установка переносимого предмета в указанный слот
; In:
;   IYL - индекс слота
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; -----------------------------------------
.EquipSlot      ; подготовка параметров установки в выбранный слот
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD D, A
                LD A, (Inventory.States.DraggedItem.ID)
                LD E, A
                CALL_IN_PAGE Page.Object, Character.Utilities.Equipment.Equip
                RET
; -----------------------------------------
; сброс готовности буферов слотов после изменения экипировки
; In:
; Out:
; Corrupt:
;   HL, DE, BC
; -----------------------------------------
.ResetSlots     ; подготовка обхода состояний слотов
                LD HL, Inventory.States.Slots.Head
                LD DE, FInventorySlotStates
                LD B, Inventory.States.Slots.Num

.ResetSlotLoop  ; сброс готовности фона и конечных атрибутов слота
                RES INVENTORY_READY_SLOT_BIT, (HL)
                ADD HL, DE
                DJNZ .ResetSlotLoop
                RET
; -----------------------------------------
; формирование общей части размещения предмета в сетке
; In:
; Out:
; Corrupt:
;   AF
; -----------------------------------------
.GridRecord     ; установка контейнера персонажа без признаков экипировки
                XOR A
                LD (.Buffer + FItemLocation.State), A
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD (.Buffer + FItemLocation.Container), A
                RET
; -----------------------------------------
; подготовка точки захвата предмета после обмена
; In:
;   IXL - индекс слота
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
.Grab           ; расчёт адреса положения выбранного слота
                LD HL, Inventory.UI.Equipment + FUIElement.Location
                LD DE, FUIElement
                LD A, IXL
                OR A
                JR Z, .ReadOrigin                                               ; переход, если выбран первый слот

.OriginLoop     ADD HL, DE
                DEC A
                JR NZ, .OriginLoop                                              ; переход, если адрес положения слота ещё не рассчитан

.ReadOrigin     ; чтение положения слота в пикселях
                LD E, (HL)
                INC HL                                                          ; переход к вертикальной координате слота
                LD D, (HL)
                LD HL, (PutItem.Cursor)

                ; расчёт точки захвата относительно положения слота
                LD A, L
                SUB E
                LD E, A
                LD A, H
                SUB D
                LD D, A
                LD BC, (Inventory.States.DraggedItem.Size)

                ; ограничение горизонтальной точки захвата размером заменённого предмета
                LD A, C
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                DEC A
                CP E
                JR NC, .GrabY                                                   ; переход, если горизонтальная точка захвата находится внутри предмета
                LD E, A

.GrabY          ; ограничение вертикальной точки захвата размером заменённого предмета
                LD A, B
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                DEC A
                CP D
                JR NC, .SaveGrab                                                ; переход, если вертикальная точка захвата находится внутри предмета
                LD D, A

.SaveGrab       LD (Inventory.States.DraggedItem.GrabOffset), DE
                RET
; -----------------------------------------
; звуковое событие установки предмета в экипировку
; In:
;   A  - идентификатор установленного предмета
; Out:
; Corrupt:
; -----------------------------------------
.Sound          RET
; -----------------------------------------
; звуковое событие неудачной установки предмета
; In:
; Out:
; Corrupt:
; -----------------------------------------
.FailureSound   RET

.Buffer         EQU Adr.RenderBuffer                                            ; существующий временный буфер данных описания

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_EQUIP_ITEM_

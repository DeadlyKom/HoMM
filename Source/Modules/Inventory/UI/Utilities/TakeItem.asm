                ifndef _MODULE_INVENTORY_UI_UTILITIES_TAKE_ITEM_
                define _MODULE_INVENTORY_UI_UTILITIES_TAKE_ITEM_
; -----------------------------------------
; взятие предмета по сохранённому запросу нажатия
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
TakeItem:       ; проверка запроса взятия предмета
.Request        FLAG_MODIFY 0                                                   ; флаг, запроса взятия предмета
                RET NC                                                          ; выход, если взятие предмета не запрошено

                ; сброс обрабатываемого запроса взятия
                RES_FLAG_MODIFY .Request

                ; проверка допустимого идентификатора экземпляра
                LD A, (GameState.ItemsNum)
                LD B, A
                LD A, (Inventory.States.DraggedItem.ID)
                CP B
                JP NC, .Cancel                                                  ; переход, если экземпляр отсутствует в массиве предметов

                ; получение размеров изображения предмета
                CALL .GetSize
                JP NC, .Cancel                                                  ; переход, если размер предмета не поддерживается буфером

                ; получение адреса прежнего размещения предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL Item.Utilities.GetLocAdr.HL                                ; получить адрес размещения предмета

                ; копирование размещения предмета из страницы в общий буфер
                LD DE, .Buffer
                LD BC, FItemLocation
                CALL Func.CopyFromPage

                ; сохранение копии размещения в состоянии перетаскиваемого предмета
                LD HL, .Buffer
                LD DE, Inventory.States.DraggedItem.Placement
                LD BC, FItemLocation
                LDIR
                LD DE, (Inventory.States.DraggedItem.Placement.State)           ; чтение состояния размещения и контейнера предмета
                LD HL, (Inventory.States.DraggedItem.Placement.Position)        ; чтение позиции предмета в ячейках сетки

                ; проверка уже взятого предмета
                BIT ITEM_LOCATION_DRAGGED_BIT, E
                JP NZ, .Cancel                                                  ; переход, если предмет уже перетаскивается

                ; проверка принадлежности выбранному персонажу
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CP D
                JP NZ, .Cancel                                                  ; переход, если предмет принадлежит другому контейнеру

                ; сохранение исходного состояния размещения
                LD IXL, E

                ; проверка взятия из экипировки
                BIT ITEM_LOCATION_EQUIPPED_BIT, E
                JR NZ, .Equipment                                               ; переход, если предмет находится в экипировке

                ; проверка обычной позиции предмета в сетке
                BIT ITEM_ITEM_POSITION_CUSTOM_BIT, E
                JP NZ, .Cancel                                                  ; переход, если предмет использует пользовательскую позицию вне экипировки

                ; расчёт левого края предмета в пикселях
                LD A, L
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                ADD A, SCR_INVENTORY_POS_X << 3
                LD L, A

                ; расчёт верхнего края предмета в пикселях
                LD A, H
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                ADD A, SCR_INVENTORY_POS_Y << 3
                LD H, A
                JR .CheckGrab

                ; -----------------------------------------
                ; определение исходного положения предмета в экипировке
                ; -----------------------------------------
.Equipment      ; определение слота, содержащего взятый предмет
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD D, A
                LD A, (Inventory.States.DraggedItem.ID)
                LD E, A
                CALL_IN_PAGE Page.Object, Character.Utilities.Equipment.FindSlot

                ; проверка наличия предмета в экипировке
                LD A, E
                CP ITEM_ID_NONE
                JP Z, .Cancel                                                   ; переход, если предмет отсутствует в экипировке

.SlotLocation   ; расчёт адреса положения первого слота предмета
                LD HL, Inventory.States.Slots.Head + FInventorySlotStates.Location
                LD DE, FInventorySlotStates
                OR A
                JR Z, .ReadSlot                                                 ; переход, если предмет находится в первом слоте

.SlotOffset     ADD HL, DE
                DEC A
                JR NZ, .SlotOffset                                              ; переход, если адрес нужного слота ещё не рассчитан

.ReadSlot       ; чтение положения предмета в знакоместах
                LD E, (HL)
                INC HL                                                          ; переход к вертикальной координате слота
                LD D, (HL)

                ; расчёт левого края предмета в пикселях
                LD A, E
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD L, A

                ; расчёт верхнего края предмета в пикселях
                LD A, D
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD H, A
                ; -----------------------------------------

.CheckGrab      ; проверка горизонтальной позиции нажатия внутри предмета
                LD A, (Inventory.States.DraggedItem.Size)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD C, A
                LD DE, (Inventory.States.DraggedItem.GrabOffset)
                LD A, E
                SUB L
                JR C, .Cancel                                                   ; переход, если нажатие находится левее предмета
                CP C
                JR NC, .Cancel                                                  ; переход, если нажатие находится правее предмета
                LD E, A

                ; проверка вертикальной позиции нажатия внутри предмета
                LD A, (Inventory.States.DraggedItem.Size + FSize.Height)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD C, A
                LD A, D
                SUB H
                JR C, .Cancel                                                   ; переход, если нажатие находится выше предмета
                CP C
                JR NC, .Cancel                                                  ; переход, если нажатие находится ниже предмета
                LD D, A
                LD (Inventory.States.DraggedItem.GrabOffset), DE                ; сохранение локальной точки захвата

                ; проверка освобождения экипировки
                LD A, IXL
                BIT ITEM_LOCATION_EQUIPPED_BIT, A
                JR Z, .Detach                                                   ; переход, если предмет взят из сетки

.Unequip        ; определение следующей ссылки на взятый предмет
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD D, A
                LD A, (Inventory.States.DraggedItem.ID)
                LD E, A
                CALL_IN_PAGE Page.Object, Character.Utilities.Equipment.FindSlot

                ; проверка оставшихся ссылок на предмет
                LD A, E
                CP ITEM_ID_NONE
                JR Z, .Detach                                                   ; переход, если ссылок на предмет больше нет

                ; освобождение найденного слота экипировки
                EX DE, HL
                CALL_IN_PAGE Page.Object, Character.Utilities.Equipment.Unequip
                JR .Unequip

.Detach         ; получение адреса размещения взятого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL Item.Utilities.GetLocAdr.HL                                ; получить адрес размещения предмета
                EX DE, HL

                ; формирование состояния перетаскивания без контейнера и позиции
                LD HL, ITEM_LOCATION_DRAGGED
                LD (.Buffer + FItemLocation.State), HL
                LD HL, #0000
                LD (.Buffer + FItemLocation.Position), HL

                ; запись нового размещения из общего буфера в страницу предметов
                LD HL, .Buffer
                LD BC, FItemLocation
                EX AF, AF'
                CALL GetPage
                CALL Memcpy.FromPage

                ; инициализация флагов
                SET_RENDER_FLAG CURSOR_HIDDEN_BIT                               ; скрытие курсора после взятия предмета
                RES_FLAG_MODIFY Inventory.Display.DraggedItem.Ready             ; сброс готовности фона перед первым отображением предмета
                CALL .Sound
                RET

.Cancel         ; сброс неудавшегося взятия предмета
                RES_INPUT_FLAG INPUT_DRAG_DROP_BIT
                LD A, ITEM_ID_NONE
                LD (Inventory.States.DraggedItem.ID), A

                ; запрос восстановления описания после использования временного буфера
                LD HL, Inventory.States.HoveredItem.Flags
                SET_OR_FLAGS INVENTORY_REDRAW | INVENTORY_DESCRIPTION
                RET
; -----------------------------------------
; получение размера изображения взятого предмета
; In:
; Out:
;   флаг переполнения установлен, если размер получен и поддерживается, иначе сброшен
; Corrupt:
;   HL, DE, BC, AF, AF'
; -----------------------------------------
.GetSize        ; чтение размера взятого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL .ReadSize

; -----------------------------------------
; проверка и сохранение размера перетаскиваемого предмета
; In:
;   BC - размер в знакоместах, B - высота, C - ширина
; Out:
;   флаг переполнения установлен, если размер сохранён, иначе сброшен
; Corrupt:
;   AF
; -----------------------------------------
.SetSize        ; проверка допустимой высоты предмета
                LD A, B
                OR A
                RET Z                                                           ; выход, если высота предмета не задана
                CP SCR_ITEM_MAX_SIZE_Y + 1
                RET NC                                                          ; выход, если высота превышает вместимость буфера

                ; проверка допустимой ширины предмета
                LD A, C
                OR A
                RET Z                                                           ; выход, если ширина предмета не задана
                CP SCR_ITEM_MAX_SIZE_X + 1
                RET NC                                                          ; выход, если ширина превышает вместимость буфера
                AND #01
                RET NZ                                                          ; выход, если ширина не поддерживается сохранением фона

                ; сохранение размера перетаскиваемого предмета
                LD (Inventory.States.DraggedItem.Size), BC
                SCF                                                             ; установка флага переполнения, размер предмета получен и поддерживается
                RET
; -----------------------------------------
; чтение размера изображения экземпляра предмета
; In:
;   A  - идентификатор экземпляра предмета
; Out:
;   BC - размер в знакоместах, B - высота, C - ширина
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
.ReadSize       ; копирование экземпляра во временный буфер
                LD DE, .Buffer
                CALL Inventory.SharedCode.Utilities.GetItem

                ; получение базового описания экземпляра
                LD A, (HL)                                                      ; чтение индекса базового описания из FItem.BaseItem
                LD DE, .Buffer
                CALL Inventory.SharedCode.Utilities.GetBaseItem

                ; расчёт адреса заголовка изображения предмета
                INC HL                                                          ; переход к полю FBaseItem.ListName
                INC HL                                                          ; переход к полю FBaseItem.Visual
                LD L, (HL)                                                      ; чтение индекса визуала из FBaseItem.Visual
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                LD BC, (Inventory.SharedCode.Render.Item.Address)
                ADD HL, BC

                ; копирование размеров из страницы графики предметов
                LD A, (Inventory.SharedCode.Render.Item.Page)
                LD DE, .Buffer
                LD BC, FSize
                CALL Func.CopyFromPage
                LD BC, (.Buffer)

                RET
; -----------------------------------------
; звуковое событие взятия предмета
; In:
; Out:
; Corrupt:
; Note:
;   общий звук для всех предметов, пока без воспроизведения
; -----------------------------------------
.Sound          RET

.Buffer         EQU Adr.RenderBuffer                                            ; существующий временный буфер данных описания

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_TAKE_ITEM_


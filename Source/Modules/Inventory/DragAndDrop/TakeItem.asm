                ifndef _MODULE_INVENTORY_DRAG_AND_DROP_TAKE_ITEM_
                define _MODULE_INVENTORY_DRAG_AND_DROP_TAKE_ITEM_
; -----------------------------------------
; обработка запроса взятия предмета
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
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
                JR NC, .Cancel                                                  ; переход, если экземпляр отсутствует в массиве предметов

                ; получение размеров изображения предмета
                ; -----------------------------------------
                ; In:
                ; Out:
                ;   флаг переполнения установлен, если размер получен и поддерживается
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.Utilities.DraggedItem.GetSize
                JR NC, .Cancel                                                  ; переход, если размер предмета не поддерживается буфером

                ; получение адреса прежнего размещения предмета
                LD A, (Inventory.States.DraggedItem.ID)
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор предмета
                ; Out:
                ;   HL - адрес FItemLocation
                ;   A  - страница массива предметов
                ; Corrupt:
                ;   HL, BC, AF
                ; -----------------------------------------
                CALL Item.Utilities.GetLocAdr.HL                                ; получить адрес размещения предмета

                ; копирование размещения предмета из страницы в общий буфер
                LD DE, Inventory.Utilities.Buffer
                LD BC, FItemLocation
                CALL Func.CopyFromPage

                ; сохранение состояния размещения и контейнера предмета
                LD DE, (Inventory.Utilities.Buffer + FItemLocation.State)
                LD (Inventory.States.DraggedItem.Placement.State), DE

                ; сохранение позиции предмета в ячейках сетки
                LD HL, (Inventory.Utilities.Buffer + FItemLocation.Position)
                LD (Inventory.States.DraggedItem.Placement.Position), HL

                ; проверка уже взятого предмета
                BIT ITEM_LOCATION_DRAGGED_BIT, E
                JR NZ, .Cancel                                                  ; переход, если предмет уже перетаскивается

                ; проверка принадлежности выбранному персонажу
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CP D
                JR NZ, .Cancel                                                  ; переход, если предмет принадлежит другому контейнеру

                ; подготовка точки захвата по прежнему размещению предмета
                ; -----------------------------------------
                ; In:
                ;   HL - прежняя позиция предмета в ячейках сетки (H - y, L - x)
                ;   DE - состояние размещения и контейнер предмета
                ; Out:
                ;   IXL - прежнее состояние размещения предмета
                ;   флаг переполнения установлен, если точка захвата подготовлена
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IX
                ; -----------------------------------------
                CALL Inventory.Utilities.DraggedItem.PrepareGrab
                JR NC, .Cancel                                                  ; переход, если курсор находится вне изображения предмета

                ; проверка освобождения экипировки
                LD A, IXL
                BIT ITEM_LOCATION_EQUIPPED_BIT, A
                JR Z, .Detach                                                   ; переход, если предмет взят из сетки

                ; освобождение всех ссылок на взятый предмет в экипировке
                LD A, (Inventory.States.DraggedItem.ID)
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор предмета или ITEM_ID_NONE
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IY
                ; -----------------------------------------
                CALL Inventory.Utilities.Equipment.UnequipItem

.Detach         ; формирование состояния перетаскивания без контейнера и позиции
                LD HL, ITEM_LOCATION_DRAGGED
                LD (Inventory.Utilities.Buffer + FItemLocation.State), HL
                LD HL, #0000
                LD (Inventory.Utilities.Buffer + FItemLocation.Position), HL

                ; запись нового размещения взятого предмета
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
; звуковое событие взятия предмета
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   общий звук для всех предметов, пока без воспроизведения
; -----------------------------------------
.Sound          RET

                endif ; ~_MODULE_INVENTORY_DRAG_AND_DROP_TAKE_ITEM_

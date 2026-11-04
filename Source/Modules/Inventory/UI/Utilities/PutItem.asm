                ifndef _MODULE_INVENTORY_UI_UTILITIES_PUT_ITEM_
                define _MODULE_INVENTORY_UI_UTILITIES_PUT_ITEM_
; -----------------------------------------
; размещение взятого предмета в свободной области сетки
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
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

                ; чтение позиции нажатия и локальной точки захвата
.Cursor         EQU $+1                                                         ; позиция нажатия в пикселях
                LD HL, #0000
                LD DE, (Inventory.States.DraggedItem.GrabOffset)

                ; расчёт горизонтальной позиции предмета относительно сетки
                LD A, L
                SUB E
                RET C                                                           ; выход, если левый край предмета выходит за экран
                SUB SCR_INVENTORY_POS_X << 3
                RET C                                                           ; выход, если левый край предмета находится левее сетки
                CP SCR_INVENTORY_SIZE_X << 4
                RET NC                                                          ; выход, если левый край предмета находится правее сетки
                SRL A
                SRL A
                SRL A
                SRL A
                LD E, A

                ; расчёт вертикальной позиции предмета относительно сетки
                LD A, H
                SUB D
                RET C                                                           ; выход, если верхний край предмета выходит за экран
                SUB SCR_INVENTORY_POS_Y << 3
                RET C                                                           ; выход, если верхний край предмета находится выше сетки
                CP SCR_INVENTORY_SIZE_Y << 4
                RET NC                                                          ; выход, если верхний край предмета находится ниже сетки
                SRL A
                SRL A
                SRL A
                SRL A
                LD D, A

                ; проверка размещения всей ширины предмета в ячейках сетки
                LD BC, (Inventory.States.DraggedItem.Size)
                LD A, C
                INC A
                SRL A
                ADD A, E
                CP SCR_INVENTORY_SIZE_X + 1
                RET NC                                                          ; выход, если предмет выходит за правую границу сетки

                ; проверка размещения всей высоты предмета в ячейках сетки
                LD A, B
                INC A
                SRL A
                ADD A, D
                CP SCR_INVENTORY_SIZE_Y + 1
                RET NC                                                          ; выход, если предмет выходит за нижнюю границу сетки

                ; сохранение проверяемой позиции в ячейках сетки
                LD (.Position), DE
                CALL .CheckFree
                RET NC                                                          ; выход, если область занята другим предметом

                ; удаление переносимого изображения перед завершением перетаскивания
                CALL Inventory.Display.DraggedItem.Restore

                ; формирование обычного размещения в сетке выбранного персонажа
                XOR A
                LD (.Buffer + FItemLocation.State), A
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD (.Buffer + FItemLocation.Container), A
.Position       EQU $+1                                                         ; позиция размещения в ячейках сетки
                LD HL, #0000
                LD (.Buffer + FItemLocation.Position), HL

                ; получение адреса размещения взятого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL Item.Utilities.GetLocAdr.HL                                ; получить адрес размещения предмета
                EX DE, HL

                ; запись размещения из общего буфера в страницу предметов
                EX AF, AF'
                CALL GetPage
                LD HL, .Buffer
                LD BC, FItemLocation
                CALL Memcpy.FromPage

                ; вызов звукового события размещённого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL .Sound

                ; завершение перетаскивания и показ обычного курсора
                RES_INPUT_FLAG INPUT_DRAG_DROP_BIT
                RES_RENDER_FLAG CURSOR_HIDDEN_BIT
                LD A, ITEM_ID_NONE
                LD (Inventory.States.DraggedItem.ID), A

                ; определение предмета под курсором после размещения
                LD A, (GameState.Inventory.Page)
                CALL_IN_PAGE_A Inventory.SharedCode.Utilities.GetItemByCursor.Wrap
                CALL SetHoverItem

                ; запрос перерисовки окна и актуального описания
                LD HL, Inventory.States.HoveredItem.Flags
                SET_OR_FLAGS INVENTORY_REDRAW | INVENTORY_DESCRIPTION
                RET
; -----------------------------------------
; проверка отсутствия пересечений с предметами в сетке
; In:
; Out:
;   флаг переполнения установлен, если область свободна, иначе сброшен
; Corrupt:
;   HL, DE, BC, AF, AF', IY
; Note:
;   позиция проверяемой области хранится в Position
;   размер области читается из состояния перетаскиваемого предмета
; -----------------------------------------
.CheckFree      ; подготовка обхода экземпляров предметов
                LD A, (GameState.ItemsNum)
                LD IYL, A

.Loop           ; проверка оставшихся экземпляров
                LD A, IYL
                OR A
                SCF                                                             ; установка флага переполнения, пересечений с проверенными предметами нет
                RET Z                                                           ; выход, если все экземпляры проверены и область свободна

                ; копирование размещения очередного экземпляра в общий буфер
                DEC IYL
                LD A, IYL
                CALL Item.Utilities.GetLocAdr.HL                                ; получить адрес размещения предмета
                LD DE, .Buffer
                LD BC, FItemLocation
                CALL Func.CopyFromPage
                LD HL, .Buffer

                ; проверка размещения экземпляра в сетке
                LD A, (HL)
                AND ITEM_LOCATION_EQUIPPED | ITEM_ITEM_POSITION_CUSTOM | ITEM_LOCATION_DRAGGED
                JR NZ, .Loop                                                    ; переход, если предмет не размещён в сетке

                ; проверка принадлежности выбранному персонажу
                INC HL                                                          ; переход к полю FItemLocation.Container
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CP (HL)
                JR NZ, .Loop                                                    ; переход, если предмет принадлежит другому контейнеру

                ; чтение позиции очередного предмета в ячейках сетки
                INC HL                                                          ; переход к полю FItemLocation.Position.X
                LD E, (HL)
                INC HL                                                          ; переход к полю FItemLocation.Position.Y
                LD D, (HL)

                ; расчёт правой границы проверяемой области в знакоместах
                LD A, (.Position)
                ADD A, A
                LD L, A
                LD A, (Inventory.States.DraggedItem.Size)
                ADD A, L
                LD C, A

                ; проверка положения левого края очередного предмета
                LD A, E
                ADD A, A
                CP C
                JR NC, .Loop                                                    ; переход, если предмет находится правее проверяемой области
                LD E, A

                ; расчёт нижней границы проверяемой области в знакоместах
                LD A, (.Position + 1)
                ADD A, A
                LD L, A
                LD A, (Inventory.States.DraggedItem.Size + FSize.Height)
                ADD A, L
                LD B, A

                ; проверка положения верхнего края очередного предмета
                LD A, D
                ADD A, A
                CP B
                JR NC, .Loop                                                    ; переход, если предмет находится ниже проверяемой области
                LD D, A

                ; чтение размеров очередного предмета с сохранением его положения
                PUSH DE
                LD A, IYL
                CALL TakeItem.ReadSize
                POP DE

                ; проверка пересечения по горизонтали
                LD A, (.Position)
                ADD A, A
                SUB E
                JR C, .CheckY                                                   ; переход, если левый край области находится левее предмета
                CP C
                JR NC, .Loop                                                    ; переход, если предмет заканчивается левее проверяемой области

.CheckY         ; проверка пересечения по вертикали
                LD A, (.Position + 1)
                ADD A, A
                SUB D
                CCF
                RET NC                                                          ; выход, если предмет пересекает область по обеим осям

                CP B
                CCF
                RET NC                                                          ; выход, если верхний край области находится внутри высоты предмета

                JR .Loop
; -----------------------------------------
; звуковое событие размещения предмета
; In:
;   A  - идентификатор размещённого предмета
; Out:
; Corrupt:
; Note:
;   звук выбирается по предмету, пока без воспроизведения
; -----------------------------------------
.Sound          RET

.Buffer         EQU Adr.RenderBuffer                                            ; существующий временный буфер данных описания

                endif                                                           ; ~_MODULE_INVENTORY_UI_UTILITIES_PUT_ITEM_

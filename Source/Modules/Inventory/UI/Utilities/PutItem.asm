                ifndef _MODULE_INVENTORY_UI_UTILITIES_PUT_ITEM_
                define _MODULE_INVENTORY_UI_UTILITIES_PUT_ITEM_
; -----------------------------------------
; размещение взятого предмета в сетке или слоте экипировки
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
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
                CALL EquipItem
                RET C                                                           ; выход, если нажатие обработано слотом экипировки

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
                CALL .GridAxis
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
                CALL .GridAxis
                RET C                                                           ; выход, если предмет не пересекает сетку по вертикали
                LD A, E
                LD (.Position + FVector8.Y), A
                ; -----------------------------------------

                ; проверка занятости области по размерам переносимого предмета
                LD BC, (Inventory.States.DraggedItem.Size)
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

                ; запись нового размещения предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL .WritePlacement

                ; вызов звукового события размещённого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CALL .Sound

.Finish         ; завершение перетаскивания и показ обычного курсора
                RES_INPUT_FLAG INPUT_DRAG_DROP_BIT
                RES_RENDER_FLAG CURSOR_HIDDEN_BIT
                LD A, ITEM_ID_NONE
                LD (Inventory.States.DraggedItem.ID), A

                ; обновление предмета под курсором после размещения
                CALL .RefreshHover

                ; запрос перерисовки окна и актуального описания
                LD HL, Inventory.States.HoveredItem.Flags
                SET_OR_FLAGS INVENTORY_REDRAW | INVENTORY_DESCRIPTION
                RET
; -----------------------------------------
; определение позиции в сетке при частичном пересечении по одной оси
; In:
;   H - размер экрана в знакоместах
;   D - размер сетки в ячейках
;   E - смещение точки захвата в пикселях
;   B - размер предмета в знакоместах
;   C - начало сетки в знакоместах
;   A - позиция нажатия в пикселях
; Out:
;   E - позиция размещения в ячейках
;   флаг переполнения установлен, если пересечения с сеткой нет
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
.GridAxis       ; ограничение положения предмета левой или верхней границей экрана
                SUB E
                JR NC, .AxisLeft                                                ; переход, если начало предмета находится внутри экрана
                XOR A

.AxisLeft       ; ограничение положения предмета правой или нижней границей экрана
                LD L, A
                LD A, H
                SUB B
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                CP L
                JR NC, .AxisScreen                                              ; переход, если предмет целиком помещается на экране
                LD L, A

.AxisScreen     ; расчёт положения предмета относительно начала сетки
                LD A, C
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD C, A
                LD A, L
                SUB C
                JR NC, .AxisInside                                              ; переход, если начало предмета находится внутри сетки или после неё

                ; проверка пересечения при начале предмета перед сеткой
                NEG
                LD L, A
                LD A, B
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                CP L
                RET C                                                           ; выход, если предмет заканчивается перед сеткой
                SCF                                                             ; установка флага переполнения для случая касания границы
                RET Z                                                           ; выход, если предмет только касается начала сетки
                XOR A
                JR .AxisClamp

.AxisInside     ; проверка пересечения с концом сетки
                LD L, A
                LD A, D
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                CP L
                RET C                                                           ; выход, если предмет начинается после сетки
                SCF                                                             ; установка флага переполнения для случая касания границы
                RET Z                                                           ; выход, если предмет только касается конца сетки
                LD A, L

.AxisClamp      ; перевод положения в ячейки сетки
                SRL A
                SRL A
                SRL A
                SRL A
                LD E, A

                ; расчёт последней позиции для полного размещения предмета
                LD A, B
                INC A
                SRL A
                LD L, A
                LD A, D
                SUB L
                RET C                                                           ; выход, если размер предмета превышает размер сетки

                ; ограничение размещения последней допустимой позицией
                CP E
                RET NC                                                          ; выход, если позиция уже позволяет разместить предмет целиком
                LD E, A
                OR A
                RET
; -----------------------------------------
; запись размещения из общего буфера в страницу предметов
; In:
;   A - идентификатор экземпляра предмета
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   запись FItemLocation предварительно формируется в Buffer
; -----------------------------------------
.WritePlacement ; получение адреса размещения экземпляра
                CALL Item.Utilities.GetLocAdr.HL                                ; получить адрес размещения предмета
                EX DE, HL
                EX AF, AF'
                CALL GetPage
                LD HL, .Buffer
                LD BC, FItemLocation
                CALL Memcpy.FromPage
                RET
; -----------------------------------------
; обновление предмета под курсором после размещения
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
.RefreshHover   ; определение слота под текущей позицией курсора
                LD HL, (Mouse.Position)
                CALL EquipItem.FindSlot
                JR NC, .GridHover                                               ; переход, если курсор находится вне слотов экипировки

                ; определение предмета в найденном слоте
                LD A, E
                ADD A, FCharacter.Equipment
                LD E, A
                CALL_IN_PAGE Page.Object, Inventory.SharedCode.Utilities.GetItemBySlot
                JP SetHoverItem

.GridHover      ; определение предмета под курсором в сетке
                LD A, (GameState.Inventory.Page)
                CALL_IN_PAGE_A Inventory.SharedCode.Utilities.GetItemByCursor.Wrap
                JP SetHoverItem

; -----------------------------------------
; проверка отсутствия пересечений с предметами в сетке
; In:
;   BC - размер области в знакоместах, B - высота, C - ширина
; Out:
;   флаг переполнения установлен, если область свободна, иначе сброшен
; Corrupt:
;   HL, DE, BC, AF, AF', IY
; Note:
;   позиция проверяемой области хранится в Position
;   размер области передаётся в BC
; -----------------------------------------
.CheckFree      ; сохранение размеров проверяемой области
                LD A, C
                LD (.CheckWidth), A
                LD A, B
                LD (.CheckHeight), A

                ; подготовка обхода экземпляров предметов
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
                ADD A, A    ; x2
                LD L, A
.CheckWidth     EQU $+1                                                         ; ширина проверяемой области в знакоместах
                LD A, #00
                ADD A, L
                LD C, A

                ; проверка положения левого края очередного предмета
                LD A, E
                ADD A, A    ; x2
                CP C
                JR NC, .Loop                                                    ; переход, если предмет находится правее проверяемой области
                LD E, A

                ; расчёт нижней границы проверяемой области в знакоместах
                LD A, (.Position + 1)
                ADD A, A    ; x2
                LD L, A
.CheckHeight    EQU $+1                                                         ; высота проверяемой области в знакоместах
                LD A, #00
                ADD A, L
                LD B, A

                ; проверка положения верхнего края очередного предмета
                LD A, D
                ADD A, A    ; x2
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
                ADD A, A    ; x2
                SUB E
                JR C, .CheckY                                                   ; переход, если левый край области находится левее предмета
                CP C
                JR NC, .Loop                                                    ; переход, если предмет заканчивается левее проверяемой области

.CheckY         ; проверка пересечения по вертикали
                LD A, (.Position + 1)
                ADD A, A    ; x2
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

                endif ; ~_MODULE_INVENTORY_UI_UTILITIES_PUT_ITEM_

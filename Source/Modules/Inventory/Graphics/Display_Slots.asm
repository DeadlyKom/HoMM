
                ifndef _MODULE_INVENTORY_GRAPHICS_DISPLAY_SLOTS_
                define _MODULE_INVENTORY_GRAPHICS_DISPLAY_SLOTS_
; -----------------------------------------
; обработка анимации и отображение слотов по прошедшим кадрам
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   интервал между вызовами определяется по TickCounterRef для всех слотов
;   за один вызов выполняется не более одного перехода между фазами
; -----------------------------------------
Slots:          ; расчёт числа кадров после предыдущей обработки слотов
                LD HL, (TickCounterRef)
.LastTick       EQU $+1                                                         ; номер кадра предыдущей обработки слотов
                LD DE, #0000
                LD (.LastTick), HL
                OR A
                SBC HL, DE

                ; ограничение интервала снизу одним кадром
                JR NZ, $+3                                                      ; переход, если между вызовами прошёл хотя бы один кадр
                INC HL
                LD (.Frames), HL

                ; подготовка показа подходящих слотов при перетаскивании
                CALL .PrepareDrag

                ; инициализация обхода состояний слотов
                LD IY, Inventory.UI.Equipment                                   ; адрес элементов слоя экипировки
                LD HL, Inventory.States.Slots.Head
                LD B, Inventory.States.Slots.Num
                LD C, #00                                                       ; индекс слота в FCharacterEquipment

                ; фиксация состояния клавиши показа всех слотов на текущий обход
                LD A, (GameState.Input.Value)
                AND ACCELERATE_CURSOR
                LD (.ShowFlag), A

.Loop           ; определение активности слота по клавише и наведению
                LD A, (IY + FUIElement.FLags)
                AND UI_STATE_HOVER
.ShowFlag       EQU $+1
                OR #00

                ; сброс активности перед проверкой наведения и переносимого предмета
                RES INVENTORY_ACTIVE_SLOT_BIT, (HL)
                JR NZ, .Activate                                                ; переход, если слот выбран наведением или клавишей

.ShowDragged    ; -----------------------------------------
                ; показ подходящих слотов экипировки при перетаскивании вне сетки
                ; -----------------------------------------

                ; проверка разрешения показа подходящих слотов вне сетки
                FLAG_MODIFY 0                                                   ; флаг, показа подходящих слотов при перетаскивании
                JR NC, .ProcessSlot                                             ; переход, если показ подходящих слотов не требуется

                ; проверка соответствия переносимого предмета текущему слоту
                PUSH HL
                PUSH BC
                LD IXL, C
.DraggedType    EQU $+1                                                         ; тип переносимого предмета для текущего обхода слотов
                LD A, #00
                ; -----------------------------------------
                ; In:
                ;   A   - тип предмета
                ;   IXL - индекс слота
                ; Out:
                ;   IXH - тип предмета
                ;   флаг переполнения установлен, если предмет подходит слоту
                ; Corrupt:
                ;   HL, DE, BC, AF, IX
                ; -----------------------------------------
                CALL Inventory.Utilities.Equipment.CheckType.ByType
                POP BC
                POP HL
                JR NC, .ProcessSlot                                             ; переход, если предмет не подходит текущему слоту

.Activate       SET INVENTORY_ACTIVE_SLOT_BIT, (HL)                             ; установка флага активности текущего слота

.ProcessSlot    ; обновление состояния и анимации текущего слота

                ; сохранение параметров обхода слотов
                PUSH HL
                PUSH BC
                PUSH IY
                CALL .Process
                POP IY
                POP BC
                POP HL

                ; переход к следующему состоянию слота
                LD DE, FInventorySlotStates
                ADD HL, DE
                INC C

                ; переход к следующему описанию слота интерфейса
                LD DE, FUIElement
                ADD IY, DE

                DJNZ .Loop
                RET
; -----------------------------------------
; подготовка показа подходящих слотов при перетаскивании вне сетки
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.PrepareDrag    ; сброс флага показа подходящих слотов перед проверкой перетаскивания
                RES_FLAG_MODIFY .ShowDragged

                ; проверка активности перетаскивания
                CHECK_INPUT_FLAG INPUT_DRAG_DROP_BIT
                RET Z                                                           ; выход, если перетаскивание неактивно

                ; проверка наведения курсора на сетку "инвентаря"
                LD A, (Inventory.UI.Grid + FUIElement.FLags)
                AND UI_STATE_HOVER
                RET NZ                                                          ; выход, если курсор находится внутри сетки

                ; проверка наличия переносимого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если переносимого предмета нет

                ; чтение типа переносимого предмета один раз для всех слотов
                CALL Inventory.Utilities.Equipment.CheckType.ReadType           ; A - тип переносимого предмета
                ; сохранение типа переносимого предмета для текущего обхода слотов
                LD (.DraggedType), A
                SET_FLAG_MODIFY .ShowDragged                                    ; разрешение показа подходящих слотов вне сетки
                RET
; -----------------------------------------
; обработка состояния и анимации текущего слота
; In:
;   HL - адрес FInventorySlotStates
;   C  - индекс слота в FCharacterEquipment
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   перед изменением экрана восстанавливает фон переносимого предмета
;   при изменении изображения или атрибутов устанавливает ML_UPDATE_BIT
; -----------------------------------------
.Process        ; проверка активности слота перед сохранением фона
                BIT INVENTORY_ACTIVE_SLOT_BIT, (HL)
                JR Z, .Direction                                                ; переход, если слот неактивен

                ; проверка текущей позиции анимации и оставшейся задержки
                INC HL                                                          ; переход к FInventorySlotStates.Animation
                LD A, (HL)                                                      ; чтение FInventorySlotStates.Animation
                INC HL                                                          ; переход к FInventorySlotStates.Delay
                OR (HL)

                ; возврат к флагам состояния слота
                DEC HL                                                          ; переход к FInventorySlotStates.Animation
                DEC HL                                                          ; переход к FInventorySlotStates.Flags
                CALL Z, .Prepare                                                ; вызов, если анимация не началась - сохранение изображения

.Direction      ; выбор направления анимации слота

                ; сохранение предыдущего направления анимации
                LD A, (HL)

                ; проверка активности слота
                BIT INVENTORY_ACTIVE_SLOT_BIT, (HL)
                RES INVENTORY_FADE_OUT_SLOT_BIT, (HL)                           ; установка направления появления слота
                JR NZ, $+4                                                      ; переход, если слот активен
                SET INVENTORY_FADE_OUT_SLOT_BIT, (HL)                           ; установка направления исчезновения слота

                ; проверка изменения направления анимации
                XOR (HL)
                AND INVENTORY_FADE_OUT_SLOT
                JR Z, .Delay                                                    ; переход, если направление анимации не изменилось

                ; проверка направления после изменения активности слота
                BIT INVENTORY_FADE_OUT_SLOT_BIT, (HL)
                LD DE, #0000                                                    ; исключение прошедших кадров при возобновлении появления
                JR Z, .TimeFlags                                                ; переход, если выбрано направление появления

                ; переход к позиции анимации слота
                INC HL                                                          ; переход к FInventorySlotStates.Animation
                
                ; проверка наличия отображённого состояния слота
                LD A, (HL)
                OR A                                                            
                RET Z                                                           ; выход, если слот уже скрыт

                ; сохранение позиции анимации и адреса задержки
                LD C, A
                INC HL                                                          ; переход к FInventorySlotStates.Delay
                PUSH HL

                ; расчёт смещения текущего состояния в таблице исчезновения
                LD A, .FadeInEnd - .FadeInTable - 2
                SUB C
                LD E, A
                LD D, #00
                LD HL, .FadeOutTable
                ADD HL, DE

                ; чтение задержки перед продолжением исчезновения
                LD A, (HL)
                POP HL
                LD (HL), A
                RET

.Delay          ; чтение числа кадров между текущим и предыдущим обходами слотов
.Frames         EQU $+1                                                         ; общий интервал в кадрах для обработки каждого слота
                LD DE, #0000

.TimeFlags      ; сохранение флагов для выбора направления следующей фазы
                LD C, (HL)

                ; переход к оставшейся задержке текущей фазы
                INC HL                                                          ; переход к FInventorySlotStates.Animation
                INC HL                                                          ; переход к FInventorySlotStates.Delay

                ; проверка завершения задержки текущей фазы
                LD A, (HL)
                OR A
                JR Z, .NextFrame                                                ; переход, если задержка текущей фазы завершена

                ; проверка превышения байтовой задержки прошедшим интервалом
                LD A, D
                OR A
                JR NZ, .ClearDelay                                              ; переход, если прошло не менее 256 кадров

                ; вычитание прошедших кадров из задержки текущей фазы
                LD A, (HL)
                SUB E
                JR NC, .SaveDelay                                               ; переход, если результат вычитания неотрицательный

.ClearDelay     XOR A                                                           ; ограничение оставшейся задержки нулём
.SaveDelay      ; обновление оставшейся задержки текущей фазы
                LD (HL), A
                RET NZ                                                          ; выход, если задержка текущей фазы ещё не завершена

                ; проверка завершения задержки скрытого состояния
                DEC HL                                                          ; переход к FInventorySlotStates.Animation
                LD A, (HL)
                OR A
                JR NZ, .FrameStep                                               ; переход, если требуется следующая видимая фаза

                ; проверка возобновления появления во время последней задержки
                BIT INVENTORY_FADE_OUT_SLOT_BIT, C
                JR Z, .AdvanceFrame                                             ; переход, если появление слота возобновлено

                ; возврат к флагам перед восстановлением фона
                DEC HL                                                          ; переход к FInventorySlotStates.Flags
                JP .RestoreBack

.NextFrame      ; возврат к позиции анимации
                DEC HL                                                          ; переход к FInventorySlotStates.Animation

.FrameStep      ; проверка направления следующего перехода анимации
                BIT INVENTORY_FADE_OUT_SLOT_BIT, C

                ; чтение текущей позиции анимации
                LD A, (HL)
                JR NZ, .PrevFrame                                               ; переход, если выбрано направление исчезновения

.AdvanceFrame   ; проверка достижения последнего состояния появления
                CP .FadeInEnd - .FadeInTable - 2
                RET Z                                                           ; выход, если слот полностью появился

                ; расчёт позиции следующего состояния появления
                ADD A, #02
                LD (HL), A
                LD DE, .FadeInTable
                JR .ReadFrame

.PrevFrame      ; проверка достижения скрытого состояния слота
                OR A
                RET Z                                                           ; выход, если слот уже скрыт

                ; расчёт позиции предыдущего состояния анимации
                SUB #02
                LD (HL), A

                ; расчёт смещения состояния в обратной таблице
                LD C, A
                LD A, .FadeInEnd - .FadeInTable - 2
                SUB C
                LD DE, .FadeOutTable

.ReadFrame      ; сохранение адреса задержки состояния слота
                INC HL                                                          ; переход к FInventorySlotStates.Delay
                PUSH HL

                ; расчёт адреса записи выбранной таблицы
                LD L, A
                LD H, #00
                ADD HL, DE

                ; чтение задержки и значения атрибута текущего кадра
                LD C, (HL)
                INC HL                                                          ; переход к атрибуту или маске записи таблицы
                LD A, (HL)

                ; обновление задержки состояния слота
                POP HL
                LD (HL), C

.FillAttributes ; подготовка атрибута или маски для заливки области
                LD E, A

                ; возврат к позиции анимации
                DEC HL                                                          ; переход к FInventorySlotStates.Animation

                ; проверка перехода к состояниям с исходными атрибутами
                LD A, (HL)
                CP .FadeInEnd - .FadeInTable - 4
                LD D, #00
                JR C, .FillAttr                                                 ; переход, если требуется заливка одним атрибутом
                INC D

.FillAttr       ; удаление переносимого предмета перед изменением слота
                CALL Inventory.Display.DraggedItem.Restore

                ; возврат к флагам состояния слота
                DEC HL                                                          ; переход к FInventorySlotStates.Flags
                PUSH HL
                POP IX

                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос обновления экрана после заливки атрибутов

                ; чтение адреса буфера конечных атрибутов
                LD HL, (IX + FInventorySlotStates.AttributesAdr)

                ; передача параметров заливки атрибутов в страницу буфера
                EXX
                JP_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Attributes.Fill.Wrap
; -----------------------------------------
; подготовка изображения и буферов слота
; In:
;   HL - адрес FInventorySlotStates
;   C  - индекс слота в FCharacterEquipment
; Out:
;   HL - адрес FInventorySlotStates
; Corrupt:
;   DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.Prepare        ; удаление переносимого предмета перед изменением слота
                CALL Inventory.Display.DraggedItem.Restore

                ; сохранение индекса и адреса состояния слота
                PUSH BC

                ; проверка готовности исходного фона
                BIT INVENTORY_READY_SLOT_BIT, (HL)
                JR NZ, .DrawContents                                            ; переход, если исходный фон уже сохранён

                PUSH HL                                                         ; сохранение адреса состояния слота

                ; проверка запроса перерисовки, поступившего перед сохранением фона
                LD HL, Inventory.States.HoveredItem.Flags
                CHECK_FLAG INVENTORY_REDRAW_BIT
                CALL NZ, Inventory.Display.Window.Redraw                        ; вызов, если перед сохранением фона требуется перерисовка окна
                POP HL                                                          ; восстановление адреса состояния слота
                PUSH HL                                                         ; сохранение адреса состояния на время копирования фона

                ; инициализация параметров копирования фона
                SET_REGISTER IX, HL
                LD HL, (IX + FInventorySlotStates.BackgroundAdr)                ; чтение адреса буфера фона
                LD DE, (IX + FInventorySlotStates.Location)                     ; чтение положения сохраняемой области
                LD BC, (IX + FInventorySlotStates.Size)                         ; чтение размера сохраняемой области
                EXX                                                             ; передача параметров сохранения через альтернативные регистры
                ; -----------------------------------------
                ; сохранение экранной области в буфер (обёртка)
                ; In:
                ;   HL' - адрес буфера
                ;   DE' - позиция в знакоместах (D' - y, E' - x)
                ;   BC' - размер в знакоместах (B' - y, C' - x)
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, HL', BC', IX, IY
                ; -----------------------------------------
                CALL_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Bound.Save.Wrap
                POP HL                                                          ; восстановление адреса состояния слота

.DrawContents   ; отображение рамки и предмета с исходными атрибутами
                POP BC                                                          ; восстановление индекса слота после сохранения фона
                CALL .DrawSlot

                ; сохранение адреса состояния на время копирования атрибутов
                PUSH HL
                SET_REGISTER IX, HL

                ; инициализация параметров копирования атрибутов
                LD HL, (IX + FInventorySlotStates.AttributesAdr)                ; чтение адреса буфера конечных атрибутов
                LD DE, (IX + FInventorySlotStates.Location)                     ; чтение положения сохраняемой области
                LD BC, (IX + FInventorySlotStates.Size)                         ; чтение размера сохраняемой области
                EXX                                                             ; передача параметров сохранения через альтернативные регистры
                ; -----------------------------------------
                ; сохранение атрибутов экранной области в буфер (обёртка)
                ; In:
                ;   HL' - адрес буфера
                ;   DE' - позиция в знакоместах (D' - y, E' - x)
                ;   BC' - размер в знакоместах (B' - y, C' - x)
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, HL', BC', IX
                ; -----------------------------------------
                CALL_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Attributes.Save.Wrap
                POP HL                                                          ; восстановление адреса состояния слота
                SET INVENTORY_READY_SLOT_BIT, (HL)                              ; установка готовности обоих сохранённых буферов
                RET
; -----------------------------------------
; отображение рамки и предмета без сохранения буферов
; In:
;   HL - адрес FInventorySlotStates
;   C  - индекс слота в FCharacterEquipment
; Out:
;   HL - адрес FInventorySlotStates
; Corrupt:
;   DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   основной экран должен быть выбран перед вызовом
; -----------------------------------------
.DrawSlot       ; сохранение адреса состояния и индекса слота
                PUSH HL                                                         ; сохранение адреса состояния слота
                PUSH BC                                                         ; сохранение индекса слота на время вывода рамки

                ; чтение положения сохраняемой области
                SET_REGISTER IX, HL
                LD HL, (IX + FInventorySlotStates.SpriteAdr)                    ; чтение адреса составного спрайта рамки
                LD DE, (IX + FInventorySlotStates.Location)                     ; чтение положения рамки в знакоместах

                ; расчёт горизонтальной позиции рамки в пикселях
                LD A, E
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD E, A

                ; расчёт вертикальной позиции рамки в пикселях
                LD A, D
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD D, A

                ; отображение рамки на основном экране
                ; -----------------------------------------
                ; отображение составного спрайта OR & XOR без отсечения
                ; In:
                ;   HL - адрес блока спрайтов
                ;   DE - координаты в пикселях (D - y, E - x)
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
                ; -----------------------------------------
                CALL Inventory.Display.Draw.NotClipping.Composite
                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос обновления экрана после отображения рамки
                POP BC                                                          ; восстановление индекса слота после вывода рамки
                POP HL                                                          ; восстановление адреса состояния слота
                PUSH HL                                                         ; сохранение адреса состояния на время вывода предмета

                ; чтение экранной позиции и индекса слота
                SET_REGISTER IX, HL
                LD DE, (IX + FInventorySlotStates.Location)
                LD A, C
                PUSH BC                                                         ; сохранение индекса слота на время вывода предмета
                ; -----------------------------------------
                ; отображение предмета в слоте экипировки
                ; In:
                ;   DE - экранная позиция слота в знакоместах
                ;   A  - индекс слота в FCharacterEquipment
                ; Out:
                ;   D  - тип отображённого предмета или ITEM_ID_NONE, если слот пуст
                ;   IX - размер изображения в знакоместах (IXH - y, IXL - x)
                ;   IY - позиция изображения в знакоместах (IYH - y, IYL - x)
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IX, IY
                ; -----------------------------------------
                CALL Inventory.SharedCode.Render.Equipment
                POP BC

                ; наложение сетки на двуручный предмет в левой руке
                ; -----------------------------------------
                ; In:
                ;   C  - индекс слота в FCharacterEquipment
                ;   D  - тип отображённого предмета или ITEM_ID_NONE
                ;   IX - размер изображения в знакоместах (IXH - y, IXL - x)
                ;   IY - позиция изображения в знакоместах (IYH - y, IYL - x)
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF
                ; -----------------------------------------
                CALL .TwoHanded

                ; восстановление адреса состояния после вывода предмета
                POP HL
                RET
; -----------------------------------------
; наложение сетки на двуручный предмет после отображения в левой руке
; In:
;   C  - индекс слота в FCharacterEquipment
;   D  - тип отображённого предмета или ITEM_ID_NONE
;   IX - размер изображения в знакоместах (IXH - y, IXL - x)
;   IY - позиция изображения в знакоместах (IYH - y, IYL - x)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.TwoHanded      ; проверка отображения предмета в левой руке
                LD A, C
                CP FCharacterEquipment.LeftHand.ID
                RET NZ                                                          ; выход, если отображается другой слот

                ; проверка двуручного типа отображённого предмета
                LD A, D
                CP ITEM_TYPE_TWO_HANDED
                RET NZ                                                          ; выход, если двуручный предмет не отображался

                ; передача размера и позиции изображения методу сетки
                LD B, IXH
                LD C, IXL
                LD D, IYH
                LD E, IYL
                ; -----------------------------------------
                ; In:
                ;   DE - позиция в знакоместах (D - y, E - x)
                ;   BC - размер в знакоместах (B - y, C - x)
                ; Out:
                ; Corrupt:
                ;   HL, DE, AF
                ; -----------------------------------------
                JP Inventory.Display.Utilities.GridPattern
; -----------------------------------------
; восстановление исходного фона после исчезновения слота
; In:
;   HL - адрес FInventorySlotStates
; Out:
;   HL - адрес FInventorySlotStates
; Corrupt:
;   DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   восстанавливает пиксели и атрибуты из буфера BackgroundAdr
;   устанавливает ML_UPDATE_BIT после восстановления фона
;   сбрасывает INVENTORY_READY_SLOT_BIT, если за время восстановления изменился тик
; -----------------------------------------
.RestoreBack    ; удаление переносимого предмета перед изменением слота
                CALL Inventory.Display.DraggedItem.Restore

                ; сохранение адреса состояния слота
                PUSH HL

                ; сохранение тика перед полным восстановлением фона
                LD DE, (TickCounterRef)
                PUSH DE

                ; чтение адреса буфера сохранённого фона
                PUSH HL
                POP IX
                LD HL, (IX + FInventorySlotStates.BackgroundAdr)

                ; передача параметров восстановления в страницу буфера
                EXX
                CALL_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Bound.Restore.Wrap

                ; запрос обновления экрана после восстановления фона
                SET_MAIN_FLAG ML_UPDATE_BIT

                ; проверка изменения тика после полного восстановления фона
                POP DE
                LD HL, (TickCounterRef)
                OR A
                SBC HL, DE
                POP HL
                RET Z                                                           ; выход, если тик не изменился

                ; сброс готовности буферов после прерывания при восстановлении
                RES INVENTORY_READY_SLOT_BIT, (HL)
                RET
; -----------------------------------------
; перерисовка текущего состояния слотов
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   основной экран должен быть выбран перед вызовом
; -----------------------------------------
.Redraw         ; подготовка обхода состояний слотов
                LD HL, Inventory.States.Slots.Head
                LD BC, Inventory.States.Slots.Num << 8

.RedrawLoop     ; сохранение параметров обхода слотов
                PUSH HL
                PUSH BC

                ; проверка наличия видимого состояния слота
                INC HL                                                          ; переход к FInventorySlotStates.Animation
                LD A, (HL)                                                      ; чтение позиции анимации
                INC HL                                                          ; переход к FInventorySlotStates.Delay
                OR (HL)

                ; возврат к началу состояния без изменения результата проверки
                DEC HL                                                          ; переход к FInventorySlotStates.Animation
                DEC HL                                                          ; переход к FInventorySlotStates.Flags
                CALL NZ, .RedrawSlot                                            ; вызов, если слот ещё виден

                ; восстановление параметров обхода слотов
                POP BC
                POP HL

                ; расчёт адреса состояния следующего слота
                LD DE, FInventorySlotStates
                ADD HL, DE
                INC C
                DJNZ .RedrawLoop
                RET

.RedrawSlot     ; проверка готовности буферов после изменения содержимого слота
                BIT INVENTORY_READY_SLOT_BIT, (HL)
                JR NZ, .RedrawReady                                             ; переход, если сохранённые атрибуты соответствуют содержимому слота
                CALL .Prepare
                JR .RedrawAttrs

.RedrawReady    ; отображение содержимого с ранее подготовленными буферами
                CALL .DrawSlot

.RedrawAttrs    ; применение текущей фазы анимации к актуальным атрибутам

                ; сохранение адреса состояния на время чтения атрибута
                PUSH HL

                ; чтение позиции текущей фазы анимации
                INC HL                                                          ; переход к FInventorySlotStates.Animation
                LD E, (HL)
                LD D, #00

                ; расчёт адреса атрибута текущей фазы
                LD HL, .FadeInTable + 1
                ADD HL, DE
                LD A, (HL)

                ; подготовка адреса Delay для существующего входа заливки
                POP HL
                INC HL                                                          ; переход к FInventorySlotStates.Animation
                INC HL                                                          ; переход к FInventorySlotStates.Delay
                JP .FillAttributes
; -----------------------------------------
; сброс готовности буферов слотов после изменения экипировки
; In:
; Out:
; Corrupt:
;   HL, DE, BC
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.ResetBuffers   ; подготовка обхода состояний слотов
                LD HL, Inventory.States.Slots.Head
                LD DE, FInventorySlotStates
                LD B, Inventory.States.Slots.Num

.ResetSlotLoop  ; сброс готовности фона и конечных атрибутов слота
                RES INVENTORY_READY_SLOT_BIT, (HL)
                ADD HL, DE
                DJNZ .ResetSlotLoop
                RET
; -----------------------------------------
; таблицы кадров анимации слота
; формат записи:
;   +0 - задержка в кадрах
;   +1 - атрибут заливки или маска сохранённых атрибутов
; -----------------------------------------
MAKE_SLOT_FRAME macro Delay?, Ink?, Paper?, Bright?, Flash?
                DB Delay?
                ZX_COLOR_IPBF Ink?, Paper?, Bright?, Flash?
                endm

.FadeInTable    ; MAKE_SLOT_FRAME  1, BLACK, BLACK, 0, 0                          ; чёрный
                MAKE_SLOT_FRAME  1, BLACK, BLUE,  0, 0                          ; синий
                MAKE_SLOT_FRAME  1, BLACK, BLUE,  1, 0                          ; ярко-синий
                MAKE_SLOT_FRAME  1, WHITE, WHITE, 0, 1                          ; маска исходных атрибутов без BRIGHT
                MAKE_SLOT_FRAME  1, WHITE, WHITE, 1, 1                          ; маска исходных атрибутов без изменений
.FadeInEnd      EQU $

.FadeOutTable   MAKE_SLOT_FRAME 10, WHITE, WHITE, 1, 1                          ; маска исходных атрибутов без изменений
                MAKE_SLOT_FRAME  2, WHITE, WHITE, 0, 1                          ; маска исходных атрибутов без BRIGHT
                MAKE_SLOT_FRAME  2, BLACK, BLUE,  1, 0                          ; ярко-синий
                MAKE_SLOT_FRAME  2, BLACK, BLUE,  0, 0                          ; синий
                ; MAKE_SLOT_FRAME  2, BLACK, BLACK, 0, 0                          ; чёрный

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_SLOTS_

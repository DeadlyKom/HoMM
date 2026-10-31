
                ifndef _MODULE_INVENTORY_GRAPHICS_DISPLAY_SLOTS_
                define _MODULE_INVENTORY_GRAPHICS_DISPLAY_SLOTS_
; -----------------------------------------
; отображение слотов
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Slots:          ; инициализация обхода состояний слотов
                LD IY, Inventory.UI.Equipment                                   ; адрес элементов слоя экипировки
                LD HL, Inventory.States.Slots.Head
                LD B, Inventory.States.Slots.Num
                LD C, #00                                                       ; индекс слота в FCharacterEquipment

.Loop           ; определение активности слота по клавише и наведению
                LD A, (GameState.Input.Value)
                AND ACCELERATE_CURSOR
                LD E, A
                LD A, (IY + FUIElement.FLags)
                AND UI_STATE_HOVER
                OR E

                ; обновление флага активности текущего слота
                RES INVENTORY_ACTIVE_SLOT_BIT, (HL)
                JR Z, $+4                                                       ; переход, если клавиша отпущена и курсор вне слота
                SET INVENTORY_ACTIVE_SLOT_BIT, (HL)

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
; обработка состояния и анимации текущего слота
; In:
;   HL - адрес FInventorySlotStates
;   C  - индекс слота в FCharacterEquipment
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
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
                RES INVENTORY_FADE_OUT_SLOT_BIT, (HL)                            ; установка направления появления слота
                JR NZ, $+4                                                      ; переход, если слот активен
                SET INVENTORY_FADE_OUT_SLOT_BIT, (HL)                            ; установка направления исчезновения слота

                ; проверка изменения направления анимации
                XOR (HL)
                AND INVENTORY_FADE_OUT_SLOT
                JR Z, .Delay                                                    ; переход, если направление анимации не изменилось

                ; проверка начала исчезновения слота
                BIT INVENTORY_FADE_OUT_SLOT_BIT, (HL)
                JR Z, .Delay                                                    ; переход, если выбрано направление появления

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
                LD D, 0
                LD HL, .FadeOutTable
                ADD HL, DE

                ; чтение задержки перед продолжением исчезновения
                LD A, (HL)
                POP HL
                LD (HL), A
                RET

.Delay          ; сохранение флагов для выбора направления следующего кадра
                LD C, (HL)

                ; переход к оставшейся задержке текущего кадра
                INC HL                                                          ; переход к FInventorySlotStates.Animation
                INC HL                                                          ; переход к FInventorySlotStates.Delay

                ; проверка завершения задержки текущего кадра
                LD A, (HL)
                OR A
                JR Z, .NextFrame                                                ; переход, если задержка текущего кадра завершена

                ; уменьшение оставшейся задержки текущего кадра
                DEC (HL)
                RET NZ                                                          ; выход, если задержка текущего кадра ещё не завершена

                ; возврат к позиции анимации
                DEC HL                                                          ; переход к FInventorySlotStates.Animation

                ; проверка завершения задержки скрытого состояния
                LD A, (HL)
                OR A
                RET NZ                                                          ; выход, если текущее состояние ещё не скрыто

                ; проверка возобновления появления во время последней задержки
                BIT INVENTORY_FADE_OUT_SLOT_BIT, C
                JR Z, .AdvanceFrame                                             ; переход, если появление слота возобновлено

                ; возврат к флагам перед восстановлением фона
                DEC HL                                                          ; переход к FInventorySlotStates.Flags
                JP .RestoreBack

.NextFrame      ; возврат к позиции анимации
                DEC HL                                                          ; переход к FInventorySlotStates.Animation

                ; проверка направления анимации
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

.FillAttr       ; возврат к флагам состояния слота
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
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
.Prepare        ; сохранение индекса и адреса состояния слота
                PUSH BC

                ; проверка готовности исходного фона
                BIT INVENTORY_READY_SLOT_BIT, (HL)
                JR NZ, .DrawContents                                            ; переход, если исходный фон уже сохранён

                PUSH HL                                                         ; сохранение адреса состояния слота
                CALL Convert.SetBaseScreen                                      ; выбор основного экрана для сохранения фона

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
;   ℹ️ необходимо включить страницу модуля "инвентаря"
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
                ; -----------------------------------------
                ; отображение предмета в слоте экипировки
                ; In:
                ;   DE - экранная позиция слота в знакоместах
                ;   A  - индекс слота в FCharacterEquipment
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IX, IY
                ; -----------------------------------------
                CALL Inventory.SharedCode.Render.Equipment

                ; восстановление адреса состояния после вывода предмета
                POP HL
                RET
; -----------------------------------------
; восстановление исходного фона после исчезновения слота
; In:
;   HL - адрес FInventorySlotStates
; Out:
;   HL - адрес FInventorySlotStates
; Corrupt:
;   DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
;   восстанавливает пиксели и атрибуты из буфера BackgroundAdr
;   устанавливает ML_UPDATE_BIT после восстановления фона
;   сбрасывает INVENTORY_READY_SLOT_BIT, если за время восстановления изменился тик
; -----------------------------------------
.RestoreBack    ; сохранение адреса состояния слота
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
;   ℹ️ необходимо включить страницу модуля "инвентаря"
;   основной экран должен быть выбран перед вызовом
; -----------------------------------------
.Redraw         ; подготовка обхода состояний слотов
                LD HL, Inventory.States.Slots.Head
                LD B, Inventory.States.Slots.Num
                LD C, #00

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

.RedrawSlot     ; повторное отображение рамки и предмета
                CALL .DrawSlot

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
; таблицы кадров анимации слота
; формат записи:
;   +0 - задержка в кадрах
;   +1 - атрибут заливки или маска сохранённых атрибутов
; -----------------------------------------
MAKE_SLOT_FRAME macro Delay?, Ink?, Paper?, Bright?, Flash?
                DB Delay?
                ZX_COLOR_IPBF Ink?, Paper?, Bright?, Flash?
                endm

.FadeInTable    MAKE_SLOT_FRAME  1, BLACK, BLACK, 0, 0                          ; чёрный
                MAKE_SLOT_FRAME  1, BLACK, BLUE,  0, 0                          ; синий
                MAKE_SLOT_FRAME  1, BLACK, BLUE,  1, 0                          ; ярко-синий
                MAKE_SLOT_FRAME  1, WHITE, WHITE, 0, 1                          ; маска исходных атрибутов без BRIGHT
                MAKE_SLOT_FRAME  1, WHITE, WHITE, 1, 1                          ; маска исходных атрибутов без изменений
.FadeInEnd      EQU $

.FadeOutTable   MAKE_SLOT_FRAME 10, WHITE, WHITE, 1, 1                          ; маска исходных атрибутов без изменений
                MAKE_SLOT_FRAME  2, WHITE, WHITE, 0, 1                          ; маска исходных атрибутов без BRIGHT
                MAKE_SLOT_FRAME  2, BLACK, BLUE,  1, 0                          ; ярко-синий
                MAKE_SLOT_FRAME  2, BLACK, BLUE,  0, 0                          ; синий
                MAKE_SLOT_FRAME  2, BLACK, BLACK, 0, 0                          ; чёрный
                
                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_SLOTS_

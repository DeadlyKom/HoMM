
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
                LD HL, Inventory.States.Slots.Head
                LD B, Inventory.States.Slots.Num

.Loop           ; цикл обхода слотов
                PUSH HL
                PUSH BC
                CALL .Process
                POP BC
                POP HL

                ; переход к следующему состоянию слота
                LD DE, FInventorySlotStates
                ADD HL, DE

                DJNZ .Loop
                RET

.Process        ; обработчик текущего слота, HL - адрес состояния

                ; проверка активности слота перед сохранением фона
                BIT INVENTORY_ACTIVE_SLOT_BIT, (HL)
                JR Z, .Direction                                                ; переход, если слот неактивен

                ; пропуск поля
                INC HL                                                          ; FInventorySlotStates.Flags

                ; проверка текущей позиции анимации и оставшейся задержки
                LD A, (HL)
                INC HL                                                          ; FInventorySlotStates.Animation
                OR (HL)

                ; возврат к флагам состояния слота
                DEC HL                                                          ; FInventorySlotStates.Animation
                DEC HL                                                          ; FInventorySlotStates.Flags
                JR NZ, .Direction                                               ; переход, если анимация слота уже выполняется

                ; проверка готовности буферов перед появлением рамки
                BIT INVENTORY_READY_SLOT_BIT, (HL)
                CALL Z, .SaveBackground                                         ; вызов сохранения, если буферы не готовы

                ; отображение рамки перед первым шагом появления
                CALL .DrawFrame

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

                ; пропуск полей
                INC HL                                                          ; FInventorySlotStates.Flags
                
                ; проверка наличия отображённого состояния слота
                LD A, (HL)
                OR A                                                            
                RET Z                                                           ; выход, если слот уже скрыт

                ; сохранение позиции анимации и адреса задержки
                LD C, A
                INC HL                                                          ; FInventorySlotStates.Animation
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

                ; пропуск полей
                INC HL                                                          ; FInventorySlotStates.Flags
                INC HL                                                          ; FInventorySlotStates.Animation

                ; проверка завершения задержки текущего кадра
                LD A, (HL)
                OR A
                JR Z, .NextFrame                                                ; переход, если задержка текущего кадра завершена

                ; уменьшение оставшейся задержки текущего кадра
                DEC (HL)
                RET NZ                                                          ; выход, если задержка текущего кадра ещё не завершена

                ; возврат к позиции анимации
                DEC HL                                                          ; FInventorySlotStates.Animation

                ; проверка завершения задержки скрытого состояния
                LD A, (HL)
                OR A
                RET NZ                                                          ; выход, если текущее состояние ещё не скрыто

                ; проверка возобновления появления во время последней задержки
                BIT INVENTORY_FADE_OUT_SLOT_BIT, C
                JR Z, .AdvanceFrame                                             ; переход, если появление слота возобновлено

                ; возврат к флагам перед восстановлением фона
                DEC HL                                                          ; FInventorySlotStates.Flags
                JP .RestoreBack

.NextFrame      ; возврат к позиции анимации
                DEC HL                                                          ; FInventorySlotStates.Animation

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
                INC HL                                                          ; FInventorySlotStates.Animation
                PUSH HL

                ; расчёт адреса записи выбранной таблицы
                LD L, A
                LD H, #00
                ADD HL, DE

                ; чтение задержки и значения атрибута текущего кадра
                LD C, (HL)
                INC HL                                                          ; задержка записи таблицы
                LD A, (HL)

                ; обновление задержки состояния слота
                POP HL
                LD (HL), C

.FillAttributes ; подготовка атрибута или маски для заливки области
                LD E, A

                ; возврат к позиции анимации
                DEC HL                                                          ; FInventorySlotStates.Animation

                ; проверка перехода к состояниям с исходными атрибутами
                LD A, (HL)
                CP .FadeInEnd - .FadeInTable - 4
                LD D, #00
                JR C, .FillAttr                                                 ; переход, если требуется заливка одним атрибутом
                INC D

.FillAttr       ; возврат к флагам состояния слота
                DEC HL                                                          ; FInventorySlotStates.Flags
                PUSH HL
                POP IX

                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос обновления экрана после заливки атрибутов

                ; чтение адреса буфера конечных атрибутов
                LD HL, (IX + FInventorySlotStates.AttributesAdr)

                ; передача параметров заливки атрибутов в страницу буфера
                EXX
                JP_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Attributes.Fill.Wrap

.DrawFrame      ; сохранение адреса состояния слота
                PUSH HL
                PUSH HL
                POP IX

                ; чтение положения сохраняемой области
                LD DE, (IX + FInventorySlotStates.Location)

                ; расчёт положения рамки в пикселях
                LD A, E
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD E, A

                LD A, D
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD D, A

                ; отображение рамки на основном экране
                LD HL, (IX + FInventorySlotStates.SpriteAdr)                    ; чтение адреса составного спрайта рамки
                CALL Inventory.Display.Draw.NotClipping.Composite

                ; запрос обновления экрана после отображения рамки
                SET_MAIN_FLAG ML_UPDATE_BIT

                ; восстановление адреса состояния слота
                POP HL
                RET

.SaveBackground ; сохранение адреса состояния слота
                PUSH HL
                PUSH HL
                POP IX

                ; выбор основного экрана для чтения чистого фона
                CALL Convert.SetBaseScreen

                ; инициализация параметров копирования фона
                LD HL, (IX + FInventorySlotStates.BackgroundAdr)                ; чтение адреса буфера фона
                LD DE, (IX + FInventorySlotStates.Location)                     ; чтение положения сохраняемой области
                LD BC, (IX + FInventorySlotStates.Size)                         ; чтение размера сохраняемой области

                ; передача параметров сохранения через альтернативные регистры
                EXX
                CALL_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Bound.Save.Wrap

                ; восстановление адреса состояния для сохранения конечных атрибутов
                POP IX
                PUSH IX

                ; чтение адреса буфера конечных атрибутов
                LD L, (IX + FInventorySlotStates.AttributesAdr + 0)
                LD H, (IX + FInventorySlotStates.AttributesAdr + 1)

                ; чтение положения сохраняемой области
                LD E, (IX + FInventorySlotStates.Location + 0)
                LD D, (IX + FInventorySlotStates.Location + 1)

                ; чтение размера сохраняемой области
                LD C, (IX + FInventorySlotStates.Size + 0)
                LD B, (IX + FInventorySlotStates.Size + 1)

                ; передача параметров сохранения атрибутов через альтернативные регистры
                EXX
                CALL_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Attributes.Save.Wrap

                ; восстановление адреса состояния слота после возврата страницы
                POP HL

                ; установка готовности обоих сохранённых буферов
                SET INVENTORY_READY_SLOT_BIT, (HL)
                RET

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

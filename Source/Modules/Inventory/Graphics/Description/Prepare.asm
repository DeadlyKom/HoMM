
                ifndef _MODULE_INVENTORY_GRAPHICS_DESCRIPTION_PREPARE_
                define _MODULE_INVENTORY_GRAPHICS_DESCRIPTION_PREPARE_
; -----------------------------------------
; подготовка данных предмета, размера и положения подложки описания
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
.Prepare        ; сброс количества подготовленных строк описания
                XOR A
                LD (Inventory.States.Description.Num), A
                LD IY, Inventory.States.Description.Lines

                ; -----------------------------------------
                ; получение копии экземпляра предмета под курсором
                LD A, (Inventory.States.HoveredItem.ID)
                LD DE, .Prepare.Buffer
                CALL Inventory.SharedCode.Utilities.GetItem

                ; сохранение индекса базового описания экземпляра
                LD A, (HL)                                                      ; чтение индекса базового описания из FItem.BaseItem
                PUSH AF

                ; получение цвета названия по качеству экземпляра
                INC HL                                                          ; переход к полю FItem.Quality
                LD E, (HL)
                LD D, #00
                LD HL, .NameColors
                ADD HL, DE
                LD A, (HL)
                POP BC                                                          ; B - индекс базового описания экземпляра
                PUSH AF                                                         ; сохранение цвета названия и типа предмета

                ; получение базового описания со свойствами в тот же буфер
                LD A, B
                LD DE, .Prepare.Buffer
                CALL Inventory.SharedCode.Utilities.GetBaseItem

                ; -----------------------------------------
                ; чтение индекса названия из копии базового описания
                LD C, (HL)                                                      ; FBaseItem.Name

                ; получение текста типа предмета из таблицы
                LD DE, FBaseItem.Type
                ADD HL, DE                                                      ; переход к полю FBaseItem.Type
                LD A, (HL)
                PUSH AF                                                         ; сохранение типа предмета для выбора формата названия
                ADD A, A    ; x2
                LD E, A
                LD D, #00
                LD HL, .Types
                ADD HL, DE
                LD E, (HL)                                                      ; чтение младшего байта адреса текста типа
                INC HL                                                          ; переход к старшему байту адреса текста типа
                LD D, (HL)
                PUSH DE                                                         ; сохранение адреса текста типа предмета

                ; сохранение индекса названия на время загрузки текстового ресурса
                LD A, C
                PUSH AF

                ; проверка вместимости ресурса названий во временный буфер
                assert Text.Items.Size <= Size.TilemapBuffer, "item names exceed description buffer"

                ; копирование ресурса названий в буфер для обработки в модуле
                LD HL, (Inventory.States.Resource.Description.Item.Adr)
                LD A, (Inventory.States.Resource.Description.Item.Page)
                LD DE, .Prepare.Buffer
                LD BC, Text.Items.Size
                CALL Func.CopyFromPage
                LD HL, .Prepare.Buffer
                POP AF

                ; проверка индекса первого названия в ресурсе
                OR A
                JR Z, .NameReady                                                ; переход, если требуется первое название

                ; подготовка количества строк перед выбранным названием
                LD B, A

.NameNext       ; расчёт адреса следующего названия с учётом завершающего нуля
                PUSH BC
                CALL String.Length
                ADD HL, BC
                POP BC
                DJNZ .NameNext

.NameReady      ; восстановление типа предмета и цвета названия
                POP DE
                POP BC                                                          ; B - тип предмета из FBaseItem.Type
                POP AF
                PUSH DE
                PUSH AF

                ; проверка объединения названия амулета с его типом
                LD A, B
                CP ITEM_TYPE_AMULET
                JR Z, .JewelryName                                              ; переход, если предмет является амулетом

                ; проверка объединения названия кольца с его типом
                CP ITEM_TYPE_RING
                JR Z, .JewelryName                                              ; переход, если предмет является кольцом

                ; добавление названия в первый слот описания
                POP AF
                PUSH AF
                LD DE, .Prepare.Buffer
                CALL .AddLine

                ; проверка наличия дополнительной строки для категории предмета
                POP AF
                POP HL
                PUSH AF
                LD A, H
                OR L
                JR Z, .NoTypeLine                                               ; переход, если дополнительная строка не задана

                ; добавление дополнительной строки цветом названия
                POP AF
                CALL .AddLine
                JR .Properties

.NoTypeLine     ; восстановление цвета без добавления отдельной строки типа
                POP AF
                JR .Properties

.JewelryName    ; формирование единой строки с типом и именем украшения
                POP AF
                POP DE
                PUSH AF
                CALL .JoinName
                POP AF
                LD DE, .Prepare.Buffer
                CALL .AddLine

.Properties     ; добавление пробных строк свойств
                ; добавление трёх пробных свойств для проверки многострочного вывода
                LD HL, .ProbeAttack
                LD A, INVENTORY_DESCRIPTION_PROPERTY_COLOR
                CALL .AddLine
                LD HL, .ProbePower
                LD A, INVENTORY_DESCRIPTION_PROPERTY_COLOR
                CALL .AddLine
                LD HL, .ProbeMana
                LD A, INVENTORY_DESCRIPTION_PROPERTY_COLOR
                CALL .AddLine

                ; -----------------------------------------
                ; подготовка обхода заполненных слотов для определения ширины
                LD A, (Inventory.States.Description.Num)
                LD B, A
                LD HL, Inventory.States.Description.Lines
                LD C, #00                                                       ; C - максимальная ширина строки в пикселях

.MaxWidth       ; проверка ширины очередной строки относительно максимальной
                LD A, (HL)
                CP C
                JR C, .NextLine                                                 ; переход, если строка короче максимальной

                LD C, A

.NextLine       ; расчёт адреса следующего слота строки
                LD DE, INVENTORY_DESCRIPTION_LINE_SIZE
                ADD HL, DE
                DJNZ .MaxWidth

                ; расчёт ширины текста в знакоместах с округлением вверх
                LD L, C
                LD H, #00
                LD DE, 7
                ADD HL, DE
                SRL H
                RR L
                SRL H
                RR L
                SRL H
                RR L

                ; расчёт ширины плашки с отступом по одному знакоместу с краёв
                LD A, L
                ADD A, 2

                ; проверка минимальной ширины для рисования рамки
                CP 3
                JR NC, .WidthReady                                              ; переход, если ширина не меньше трёх знакомест

                LD A, 3

.WidthReady     ; сохранение рассчитанной ширины плашки
                LD C, A                                                         ; C - ширина области в знакоместах

                ; расчёт высоты по числу строк с шагом и отступами в знакоместах
                LD A, (Inventory.States.Description.Num)
                ADD A, A    ; x2
                ADD A, 2
                LD D, A                                                         ; D - высота области в знакоместах
                ; -----------------------------------------

                ; расчёт количества допустимых горизонтальных позиций
                LD A, 33
                SUB C
                LD B, A
                CALL .Sample
                LD E, A                                                         ; E - столбец левой границы области

                ; расчёт количества допустимых вертикальных позиций
                LD A, 25
                SUB D
                LD B, A
                CALL .Sample

                ; подготовка положения и высоты области
                LD B, D                                                         ; B - высота области в знакоместах
                LD D, A                                                         ; D - строка верхней границы области

                ; сохранение положения и размера новой области описания
                LD (Inventory.States.HoveredItem.Location), DE
                LD (Inventory.States.HoveredItem.Size), BC
                RET

.Prepare.Buffer EQU Adr.TilemapBuffer                                           ; адрес временного буфера данных предмета
; -----------------------------------------
; объединение типа украшения и его имени в строку с кавычками
; In:
;   HL - адрес имени предмета
;   DE - адрес префикса типа с пробелом и открывающей кавычкой
; Out:
;   HL - адрес объединённой строки в общем буфере
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.JoinName       ; сохранение префикса и размещение имени в начале буфера
                PUSH DE
                LD DE, .Prepare.Buffer
                CALL String.Copy
                POP HL
                PUSH HL

                ; расчёт смещения имени на длину префикса без завершающего нуля
                CALL String.Length
                DEC BC
                PUSH BC
                LD HL, .Prepare.Buffer
                CALL String.Length
                ADD HL, BC
                DEC HL                                                          ; переход к завершающему нулю имени
                POP DE
                EX DE, HL
                ADD HL, DE
                EX DE, HL

                ; перенос имени вправо с сохранением перекрывающихся данных
                PUSH DE
                LDDR
                POP DE

                ; добавление закрывающей кавычки и завершение строки
                LD A, INVENTORY_DESCRIPTION_CLOSE_QUOTE
                LD (DE), A
                INC DE
                XOR A
                LD (DE), A

                ; копирование префикса перед перенесённым именем
                POP HL
                CALL String.Length
                DEC BC
                LD DE, .Prepare.Buffer
                LDIR
                LD HL, .Prepare.Buffer
                RET

; -----------------------------------------
; добавление строки в очередной слот описания
; In:
;   HL - адрес исходной строки
;   DE - адрес свободного участка временного буфера
;   A  - атрибут цвета строки
;   IY - адрес свободного слота строки
; Out:
;   DE - адрес свободного участка после скопированной строки
;   IY - адрес следующего слота строки
; Corrupt:
;   HL, DE, BC, AF, AF', IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.AddLine        ; копирование строки с сохранением цвета и адреса начала
                PUSH AF
                PUSH DE
                CALL String.Copy
                POP HL
                PUSH DE
                PUSH HL

                ; измерение ширины строки из общего буфера
                EX DE, HL
                CALL_IN_PAGE Page.Font, Font.GetWidth
                LD (IY + FInventoryDescriptionLine.Width), E

                ; заполнение адреса строки в текущем слоте
                POP DE
                LD (IY + FInventoryDescriptionLine.Text), E
                LD (IY + FInventoryDescriptionLine.Text + 1), D
                POP BC                                                          ; BC - адрес свободного участка буфера
                POP AF
                LD (IY + FInventoryDescriptionLine.Attribute), A

                ; переход к свободному участку буфера и следующему слоту
                LD D, B
                LD E, C
                LD BC, INVENTORY_DESCRIPTION_LINE_SIZE
                ADD IY, BC

                ; обновление количества подготовленных строк
                LD HL, Inventory.States.Description.Num
                INC (HL)
                RET

; -----------------------------------------
; получение меняющегося значения в заданном диапазоне для визуальной пробы
; In:
;   B  - количество допустимых значений, от 1 до 255
; Out:
;   A  - значение от 0 до B - 1
; Corrupt:
;   HL, AF
; -----------------------------------------
.Sample         ; получение значения из счётчика тиков и регистра R
                LD HL, TickCounterRef
                LD A, R
                XOR (HL)

.Limit          ; проверка попадания значения в допустимый диапазон
                CP B
                RET C                                                           ; выход, если значение меньше количества допустимых значений

                ; уменьшение значения на размер диапазона
                SUB B
                JR .Limit

                ; -----------------------------------------
                ; цвета названия и типа по значениям ITEM_QUALITY_
.NameColors     DB INVENTORY_DESCRIPTION_NORMAL_COLOR                           ; ITEM_QUALITY_NORMAL
                DB INVENTORY_DESCRIPTION_MAGIC_COLOR                            ; ITEM_QUALITY_MAGIC
                DB INVENTORY_DESCRIPTION_RARE_COLOR                             ; ITEM_QUALITY_RARE
                DB INVENTORY_DESCRIPTION_UNIQUE_COLOR                           ; ITEM_QUALITY_UNIQUE
                DB INVENTORY_DESCRIPTION_SET_COLOR                              ; ITEM_QUALITY_SET
                ; -----------------------------------------

                ; -----------------------------------------
                ; тексты типов по значениям ITEM_TYPE_
.Types          DW #0000                                                        ; ITEM_TYPE_HEAD
                DW #0000                                                        ; ITEM_TYPE_BREAST
                DW .TypeAmulet                                                  ; ITEM_TYPE_AMULET
                DW .TypeRing                                                    ; ITEM_TYPE_RING
                DW #0000                                                        ; ITEM_TYPE_LEFT_HAND
                DW .TypeOneHand                                                 ; ITEM_TYPE_RIGHT_HAND
                DW .TypeTwoHand                                                 ; ITEM_TYPE_TWO_HANDED
                DW #0000                                                        ; ITEM_TYPE_BELT
                DW #0000                                                        ; ITEM_TYPE_SHOULDER_PAD
                DW #0000                                                        ; ITEM_TYPE_BOOT
                ; -----------------------------------------

.TypeAmulet     lua allpass
                Convert ('Амулет «')
                endlua

.TypeRing       lua allpass
                Convert ('Кольцо «')
                endlua

.TypeOneHand    lua allpass
                Convert ("Одноручное")
                endlua

.TypeTwoHand    lua allpass
                Convert ("Двуручное")
                endlua

                ; -----------------------------------------
                ; пробные свойства для визуальной проверки вывода строк
.ProbeAttack    lua allpass
                Convert ("+3 к атаке")
                endlua

.ProbePower     lua allpass
                Convert ("+1 к силе заклинаний")
                endlua

.ProbeMana      lua allpass
                Convert ("+10% получения маны")
                endlua
                ; -----------------------------------------

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DESCRIPTION_PREPARE_

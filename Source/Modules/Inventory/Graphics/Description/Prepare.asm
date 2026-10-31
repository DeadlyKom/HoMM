
                ifndef _MODULE_INVENTORY_GRAPHICS_DESCRIPTION_PREPARE_
                define _MODULE_INVENTORY_GRAPHICS_DESCRIPTION_PREPARE_
; -----------------------------------------
; подготовка данных предмета, размера и положения подложки описания
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
.Prepare        ; -----------------------------------------
                ; получение копии экземпляра предмета под курсором
                LD A, (Inventory.States.HoveredItem.ID)
                LD DE, .Prepare.Buffer
                CALL Inventory.SharedCode.Utilities.GetItem

                ; получение базового описания со свойствами в тот же буфер
                LD A, (HL)                                                      ; чтение индекса базового описания из FItem.BaseItem
                LD DE, .Prepare.Buffer
                CALL Inventory.SharedCode.Utilities.GetBaseItem

                ; -----------------------------------------
                ; сохранение индекса названия из копии базового описания
                LD A, (HL)                                                      ; чтение индекса названия из FBaseItem.Name
                PUSH AF

                ; проверка вместимости ресурса названий во временный буфер
                if Text.Items.Size > Size.TilemapBuffer
                error "item names exceed description buffer"
                endif

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

.NameReady      ; размещение выбранного названия в начале буфера
                LD DE, .Prepare.Buffer
                CALL String.Copy
                ; -----------------------------------------

                ; выбор ширины области от 10 до 24 знакомест
                LD B, 15
                CALL .Sample
                ADD A, 10
                LD C, A                                                         ; C - ширина области в знакоместах

                ; выбор высоты области от 6 до 16 знакомест
                LD B, 11
                CALL .Sample
                ADD A, 6
                LD D, A                                                         ; D - высота области в знакоместах

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

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DESCRIPTION_PREPARE_

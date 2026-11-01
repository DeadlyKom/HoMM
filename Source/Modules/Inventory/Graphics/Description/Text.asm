
                ifndef _MODULE_INVENTORY_GRAPHICS_DESCRIPTION_TEXT_
                define _MODULE_INVENTORY_GRAPHICS_DESCRIPTION_TEXT_
; -----------------------------------------
; отображение текста на подложке описания
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
.Text           ; проверка наличия подготовленных строк
                LD A, (Inventory.States.Description.Num)
                OR A
                RET Z                                                           ; выход, если подготовленных строк нет

                ; инициализация
                LD B, A

                ; расчёт базовой линии первой строки относительно верха плашки
                LD A, (Inventory.States.HoveredItem.Location + FVector8.Y)
                ADD A, 2
                RLCA
                RLCA
                RLCA
                LD C, A                                                         ; C - базовая линия текущей строки в пикселях
                LD HL, Inventory.States.Description.Lines

.TextLoop       ; сохранение счётчика строк, базовой линии и адреса текущего слота
                PUSH BC
                PUSH HL

                ; чтение сохранённой ширины строки для расчёта выравнивания
                LD E, (HL)                                                      ; FInventoryDescriptionLine.Width
                LD D, #00

                ; расчёт ширины плашки в пикселях с учётом полного экрана
                LD A, (Inventory.States.HoveredItem.Size + FSize.Width)
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8

                ; расчёт отступа строки от левого края плашки для центрирования
                OR A
                SBC HL, DE
                SRL H
                RR L

                ; расчёт экранной позиции начала строки в пикселях
                LD A, (Inventory.States.HoveredItem.Location + FVector8.X)
                RLCA
                RLCA
                RLCA
                ADD A, L
                LD E, A                                                         ; E - горизонтальная позиция строки в пикселях
                LD D, C                                                         ; D - базовая линия строки в пикселях

                ; чтение атрибута цвета из текущего слота
                POP HL
                PUSH HL
                INC HL                                                          ; переход к полю FInventoryDescriptionLine.Attribute
                LD A, (HL)
                PUSH AF

                ; чтение адреса буфера строки из текущего слота
                INC HL                                                          ; переход к полю FInventoryDescriptionLine.Text
                LD C, (HL)                                                      ; чтение младшего байта адреса строки
                INC HL                                                          ; переход к старшему байту адреса строки
                LD H, (HL)                                                      ; чтение старшего байта адреса строки
                LD L, C

                ; отображение строки с сохранением её экранной позиции
                PUSH DE
                CALL String.DrawColor.AutoPage
                POP DE
                POP AF

                ; окраска области строки атрибутом из слота
                POP HL
                PUSH HL
                LD C, (HL)                                                      ; чтение ширины строки из FInventoryDescriptionLine.Width
                CALL .TextAttr
                POP HL
                POP BC

                ; расчёт адреса следующего слота и базовой линии следующей строки
                LD DE, INVENTORY_DESCRIPTION_LINE_SIZE
                ADD HL, DE
                LD A, C
                ADD A, 16
                LD C, A
                DJNZ .TextLoop

                RET
; -----------------------------------------
; окраска основного ряда знакомест строки
; In:
;   DE - координаты в пикселях (D - базовая линия, E - начало строки)
;   C  - ширина строки в пикселях
;   A  - атрибут цвета строки
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
.TextAttr       ; проверка наличия ширины окрашиваемой строки
                PUSH AF
                LD A, C
                OR A
                JR Z, .TextAttrEmpty                                            ; переход, если строка не занимает пикселей

                ; расчёт количества знакомест с учётом пиксельного смещения строки
                LD A, E
                AND #07
                ADD A, C
                DEC A
                SRL A
                SRL A
                SRL A
                INC A
                LD C, A                                                         ; C - ширина окрашиваемой области в знакоместах

                ; расчёт левого столбца и основного ряда строки в знакоместах
                SRL E
                SRL E
                SRL E
                LD A, D
                SRL A
                SRL A
                SRL A
                DEC A
                LD D, A

                ; получение адреса атрибутов начала области строки
                CALL Convert.AttributeAdr
                EX DE, HL
                POP AF
                LD B, C

.TextAttrByte   ; применение атрибута строки к очередному знакоместу
                LD (HL), A
                INC HL
                DJNZ .TextAttrByte

                RET

.TextAttrEmpty  ; восстановление атрибута без окраски пустой строки
                POP AF
                RET

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DESCRIPTION_TEXT_

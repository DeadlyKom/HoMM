
                ifndef _INVENTORY_RENDER_ITEMS_
                define _INVENTORY_RENDER_ITEMS_
; -----------------------------------------
; отображение предмета выбранного персонажа
; In:
;   A  - идентификатор экземпляра предмета
;   DE - координаты в знакоместах (D - y, E - x)
;        у предмета необходимо вкл флаг ITEM_ITEM_POSITION_CUSTOM_BIT
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Item:           ; сохранение идентификатора экземпляра
                LD B, A
                EX AF, AF'

                ; подготовка восстановления страницы при выходе
                PUSH_PAGE
                LD HL, SetPageInStack
                PUSH HL

                ; получение размещения и проверка владельца
                LD A, B
                CALL .Location
                RET NZ                                                          ; выход, если предмет не принадлежит выбранному персонажу

                ; проверка режима заданной экранной позиции
                BIT ITEM_ITEM_POSITION_CUSTOM_BIT, C
                JR NZ, .Position                                                ; переход, если позиция передана в DE

                JR .GridPosition
; -----------------------------------------
; отображение предмета в сетке выбранного персонажа
; In:
;   A  - идентификатор экземпляра предмета
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
.Grid           ; сохранение идентификатора экземпляра
                LD B, A
                EX AF, AF'

                ; подготовка восстановления страницы при выходе
                PUSH_PAGE
                LD HL, SetPageInStack
                PUSH HL

                ; получение размещения и проверка владельца
                LD A, B
                CALL .Location
                RET NZ                                                          ; выход, если предмет не принадлежит выбранному персонажу

                ; проверка размещения предмета в сетке
                LD A, C
                AND ITEM_LOCATION_EQUIPPED | ITEM_ITEM_POSITION_CUSTOM
                RET NZ                                                          ; выход, если предмет экипирован или использует пользовательскую позицию

.GridPosition   ; чтение позиции предмета в сетке
                INC HL                                                          ; FItemLocation.Container
                LD E, (HL)
                INC HL
                LD D, (HL)

                ; расчёт горизонтальной позиции на экране в знакоместах
                LD A, E
                ADD A, A                                                        ; x2
                ADD A, SCR_INVENTORY_POS_X
                LD E, A

                ; расчёт вертикальной позиции на экране в знакоместах
                LD A, D
                ADD A, A                                                        ; x2
                ADD A, SCR_INVENTORY_POS_Y
                LD D, A

.Position       ; чтение индекса базового описания экземпляра
                EX AF, AF'
                CALL Kernel.Item.Utilities.Address.HL
                LD A, (HL)                                                      ; FItem.BaseItem
                EX AF, AF'

                ; включение страницы базовых описаний
.Metadata.Page  EQU $+1                                                         ; операнд с номером страницы метаданных
                LD A, #00
                SET_PAGE_A

                ; получение адреса базовых описаний
.Metadata.Adr   EQU $+1                                                         ; операнд с адресом ресурса метаданных
                LD HL, #0000
                EX AF, AF'                                                      ; восстановление индекса базового предмета

                ; получение базового описания с сохранением экранной позиции
                PUSH DE
                CALL Kernel.Item.Utilities.BaseAddress.HL

                ; чтение индекса визуала базового предмета
                INC HL                                                          ; FBaseItem.Name
                LD L, (HL)
                LD H, #00
                POP DE

                ; расчёт смещения заголовка FItemVisual по индексу
                ADD HL, HL                                                      ; x2
                ADD HL, HL                                                      ; x4

                ; расчёт адреса заголовка внутри графического ресурса
.Address        EQU $+1                                                         ; операнд с адресом графического ресурса
                LD BC, #0000
                ADD HL, BC

                ; включение страницы графики предметов
.Page           EQU $+1                                                         ; операнд с номером страницы графики
                LD A, #00
                SET_PAGE_A

                ; расчёт адреса данных спрайта
                INC HL                                                          ; FItemVisual.Size.Width
                INC HL                                                          ; FItemVisual.Size.Height
                LD C, (HL)
                INC HL
                LD B, (HL)
                ADD HL, BC

                ; расчёт горизонтальной позиции в пикселях
                LD A, E
                ADD A, A                                                        ; x2
                ADD A, A                                                        ; x4
                ADD A, A                                                        ; x8
                LD E, A

                ; расчёт вертикальной позиции в пикселях
                LD A, D
                ADD A, A                                                        ; x2
                ADD A, A                                                        ; x4
                ADD A, A                                                        ; x8
                LD D, A

                ; подготовка функции вывода спрайта без указания блока спрайтов (FSpriteBlock)
                LD BC, #0000                                                    ; значение счётчиков и флагов для полного вывода
                LD (Kernel.Boundary.Functions.VHCounters), BC                   ; установка счётчиков полного вывода спрайта
                LD IX, Kernel.Boundary.Functions.OR_XOR_ATTR                    ; выбор обработчика OR/XOR с атрибутами

                ; передача адреса данных через стек обработчику
                PUSH HL
                JP Kernel.Boundary.Functions.Draw

; -----------------------------------------
; получение размещения предмета и проверка владельца
; In:
;   A  - идентификатор экземпляра предмета
; Out:
;   HL - адрес FItemLocation.Container
;   C  - состояние FItemLocation.State
;   флаг Z установлен, если предмет принадлежит выбранному персонажу
; Corrupt:
;   HL, BC, AF
; Note:
;   ⚠️ ВАЖНО ⚠️
;   меняет страницу памяти
;   при выходе включена страница массива предметов
; -----------------------------------------
.Location       ; получение адреса размещения экземпляра
                CALL Kernel.Item.Utilities.Location.HL
                SET_PAGE_A

                ; чтение состояния размещения предмета
                LD C, (HL)
                INC HL                                                          ; FItemLocation.State

                ; проверка принадлежности выбранному персонажу
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CP (HL)
                RET

                display " - Display inventory item:\t\t\t\t", /A, Item, "\t= busy [ ", /D, $-Item, " byte(s) ]"

                endif                                                           ; ~_INVENTORY_RENDER_ITEMS_

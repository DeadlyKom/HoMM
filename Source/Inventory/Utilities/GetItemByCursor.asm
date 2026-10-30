
                ifndef _INVENTORY_UTILITIES_GET_ITEM_BY_CURSOR_
                define _INVENTORY_UTILITIES_GET_ITEM_BY_CURSOR_
; -----------------------------------------
; определение предмета под курсором в сетке инвентаря (обёртка)
; In:
; Out:
;   E  - идентификатор экземпляра предмета или ITEM_ID_NONE
;   флаг, переполнения установлен, если предмет найден
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; Note:
;   ℹ️ код расположен в "общей памяти"
;   меняет страницу памяти
; -----------------------------------------
GetItemByCursor.Wrap:; определение предмета под курсором
                CALL Inventory.SharedCode.Utilities.GetItemByCursor
                RET C                                                           ; выход, если предмет под курсором найден

                ; подготовка результата при отсутствии предмета
                LD E, ITEM_ID_NONE
                RET
; -----------------------------------------
; определение предмета под курсором в сетке инвентаря
; In:
; Out:
;   E  - идентификатор экземпляра предмета, если предмет найден
;   флаг, переполнения установлен, если предмет найден
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; Note:
;   ℹ️ код расположен в "общей памяти"
;   положение курсора читается из Mouse.PositionX и Mouse.PositionY
;   ресурсы графики и базовых описаний предметов должны быть загружены
;   меняет страницу памяти
; -----------------------------------------
GetItemByCursor ; расчёт горизонтальной позиции курсора относительно сетки
                LD A, (Mouse.PositionX)                                         ; чтение координаты X курсора в пикселях
                SUB SCR_INVENTORY_POS_X << 3
                CCF
                RET NC                                                          ; выход, если курсор находится левее сетки

                ; проверка правой границы сетки
                CP SCR_INVENTORY_SIZE_X << 4
                RET NC                                                          ; выход, если курсор находится правее сетки

                ; расчёт горизонтального индекса ячейки размером 16 пикселей
                SRL A
                SRL A
                SRL A
                SRL A
                LD IXL, A

                ; расчёт вертикальной позиции курсора относительно сетки
                LD A, (Mouse.PositionY)                                         ; чтение координаты Y курсора в пикселях
                SUB SCR_INVENTORY_POS_Y << 3
                CCF
                RET NC                                                          ; выход, если курсор находится выше сетки

                ; проверка нижней границы сетки
                CP SCR_INVENTORY_SIZE_Y << 4
                RET NC                                                          ; выход, если курсор находится ниже сетки

                ; расчёт вертикального индекса ячейки размером 16 пикселей
                SRL A
                SRL A
                SRL A
                SRL A
                LD IXH, A

                ; подготовка обхода массива предметов
                LD A, (GameState.ItemsNum)
                LD IYL, A

.Loop           ; проверка оставшегося количества предметов
                LD A, IYL
                OR A
                RET Z                                                           ; выход, если все предметы проверены

                ; получение размещения очередного экземпляра
                DEC IYL
                LD A, IYL
                CALL Kernel.Item.Utilities.Location.HL
                SET_PAGE_A

                ; проверка размещения предмета в сетке
                LD A, (HL)
                AND ITEM_LOCATION_EQUIPPED | ITEM_ITEM_POSITION_CUSTOM
                JP NZ, .Loop                                                    ; переход, если предмет экипирован или использует пользовательскую позицию

                ; проверка принадлежности выбранному персонажу
                INC HL                                                          ; переход к полю FItemLocation.Container
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CP (HL)
                JP NZ, .Loop                                                    ; переход, если предмет принадлежит другому контейнеру

                ; расчёт расстояния по X от левого края предмета до ячейки под курсором
                INC HL                                                          ; переход к полю FItemLocation.Position.X
                LD A, IXL                                                       ; A - столбец ячейки под курсором
                SUB (HL)
                JP C, .Loop                                                     ; переход, если искомая ячейка находится левее предмета

                ; перевод расстояния по X в знакоместа для сравнения с шириной FItemVisual
                ; одна ячейка сетки занимает два знакоместа по каждой оси
                ADD A, A    ; x2
                LD E, A                                                         ; E - расстояние от левого края предмета в знакоместах

                ; расчёт расстояния по Y от верхнего края предмета до ячейки под курсором
                INC HL                                                          ; переход к полю FItemLocation.Position.Y
                LD A, IXH                                                       ; A - строка ячейки под курсором
                SUB (HL)
                JP C, .Loop                                                     ; переход, если искомая ячейка находится выше предмета

                ; перевод расстояния по Y в знакоместа для сравнения с высотой FItemVisual
                ADD A, A    ; x2
                LD D, A                                                         ; D - расстояние от верхнего края предмета в знакоместах

                ; сохранение расстояний в знакоместах для проверки попадания в предмет
                ; DE - расстояния от краёв предмета (D - y, E - x)
                PUSH DE

                ; получение индекса базового описания экземпляра
                LD A, IYL
                CALL Kernel.Item.Utilities.Address.HL
                LD E, (HL)                                                      ; чтение индекса базового предмета из FItem.BaseItem

                ; получение базового описания из загруженного ресурса
                LD A, (Inventory.SharedCode.Render.Item.Metadata.Page)
                SET_PAGE_A
                LD HL, (Inventory.SharedCode.Render.Item.Metadata.Adr)
                LD A, E
                CALL Kernel.Item.Utilities.BaseAddress.HL

                ; расчёт адреса поля с индексом визуала предмета
                LD DE, FBaseItem.Visual                                         ; смещение поля FBaseItem.Visual
                ADD HL, DE                                                      ; переход к полю FBaseItem.Visual

                ; чтение индекса визуала для расчёта адреса FItemVisual
                LD L, (HL)                                                      ; чтение индекса визуала из FBaseItem.Visual
                LD H, #00                                                       ; расширение индекса визуала до 16 бит

                ; расчёт смещения заголовка FItemVisual размером 4 байта по индексу
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                LD BC, (Inventory.SharedCode.Render.Item.Address)
                ADD HL, BC

                ; чтение размеров из страницы графики предметов
                LD A, (Inventory.SharedCode.Render.Item.Page)
                SET_PAGE_A
                POP DE

                ; проверка попадания ячейки в ширину предмета
                LD A, E
                CP (HL)                                                         ; FItemVisual.Size.Width
                JP NC, .Loop                                                    ; переход, если искомая ячейка находится правее предмета

                ; проверка попадания ячейки в высоту предмета
                INC HL                                                          ; переход к полю FItemVisual.Size.Height
                LD A, D
                CP (HL)
                JP NC, .Loop                                                    ; переход, если искомая ячейка находится ниже предмета

                ; получение идентификатора предмета под курсором
                LD E, IYL
                SCF                                                             ; флаг установлен, предмет под курсором найден
                RET

                endif ; ~_INVENTORY_UTILITIES_GET_ITEM_BY_CURSOR_

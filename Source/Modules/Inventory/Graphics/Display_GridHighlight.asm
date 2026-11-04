                ifndef _MODULE_INVENTORY_GRAPHICS_DISPLAY_GRID_HIGHLIGHT_
                define _MODULE_INVENTORY_GRAPHICS_DISPLAY_GRID_HIGHLIGHT_
; -----------------------------------------
; подсветка размещения или обмена в сетке инвентаря
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
GridHighlight:  ; проверка приоритета слота экипировки под курсором
.Cursor         EQU $+1                                                         ; позиция курсора в пикселях
                LD HL, #0000
                ; -----------------------------------------
                ; In:
                ;   HL - позиция курсора в пикселях (H - y, L - x)
                ; Out:
                ;   E  - индекс слота или ITEM_ID_NONE
                ;   флаг переполнения установлен, если слот найден
                ; Corrupt:
                ;   DE, BC, AF, IX
                ; -----------------------------------------
                CALL Inventory.UI.Utilities.GetSlotByPoint
                RET C                                                           ; выход, если курсор находится в области слота экипировки

                ; определение области размещения по тем же правилам, что и при ЛКМ
                LD HL, (.Cursor)
                ; -----------------------------------------
                ; In:
                ;   HL - позиция курсора в пикселях (H - y, L - x)
                ; Out:
                ;   DE - позиция в ячейках сетки (D - y, E - x)
                ;   флаг переполнения установлен, если предмет пересекает сетку
                ; Corrupt:
                ;   HL, DE, BC, AF
                ; -----------------------------------------
                CALL Inventory.Utilities.Grid.GetPosition
                RET NC                                                          ; выход, если предмет не пересекает сетку
                LD (.Position), DE

                ; проверка допустимости обмена с пересекаемыми предметами
                LD BC, (Inventory.States.DraggedItem.Size)
                ; -----------------------------------------
                ; In:
                ;   DE - позиция области в ячейках сетки (D - y, E - x)
                ;   BC - размер области в знакоместах (B - y, C - x)
                ; Out:
                ;   E  - идентификатор заменяемого предмета или ITEM_ID_NONE
                ;   флаг переполнения установлен, если размещение или обмен разрешены
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IY
                ; -----------------------------------------
                CALL Inventory.Utilities.Grid.CheckFree.Swap
                LD A, INVENTORY_GRID_HIGHLIGHT_SWAP_COLOR
                JR C, $+4                                                       ; переход, если возможны размещение или обмен
                LD A, INVENTORY_GRID_HIGHLIGHT_BLOCKED_COLOR
                LD (.ItemColour), A                                             ; сохранение цвета пересекаемых предметов на время копирования атрибутов

                ; сохранение исходных атрибутов всей сетки
                LD HL, .Buffer
                LD DE, SCR_INVENTORY_POS_Y << 8 | SCR_INVENTORY_POS_X
                LD BC, SlotBuffers.GridHighlight.Height << 8 | SlotBuffers.GridHighlight.Width
                EXX
                CALL_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Attributes.Save.Wrap
                SET_FLAG_MODIFY .Ready

                ; окраска свободных ячеек области размещения
.Position       EQU $+1                                                         ; позиция области размещения в ячейках сетки
                LD DE, #0000
                SLA E
                SLA D
                LD BC, (Inventory.States.DraggedItem.Size)
                LD A, INVENTORY_GRID_HIGHLIGHT_FREE_COLOR
                CALL .PaintItem

                ; окраска всех пересекаемых предметов целиком
                LD HL, .PaintOverlap
                LD DE, (.Position)
                LD BC, (Inventory.States.DraggedItem.Size)
                ; -----------------------------------------
                ; In:
                ;   HL - адрес обработчика пересекаемого предмета
                ;   DE - позиция области в ячейках сетки (D - y, E - x)
                ;   BC - размер области в знакоместах (B - y, C - x)
                ; Out:
                ; Corrupt:
                ;   HL, DE, BC, AF, AF', IX, IY
                ; -----------------------------------------
                CALL Inventory.Utilities.Grid.CheckFree.ForEach
                RET

.Buffer         EQU Adr.BuffersSlots.GridHighlight.Attributes \
                    + Size.BuffersSlots.GridHighlight.Attributes - 4            ; адрес шапки буфера исходных атрибутов

; -----------------------------------------
; восстановление исходных атрибутов сетки
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.Restore        ; проверка наличия подсветки на экране
.Ready          FLAG_MODIFY 0                                                   ; флаг, готовности исходных атрибутов сетки
                RET NC                                                          ; выход, если подсветка отсутствует

                ; восстановление атрибутов до обновления интерфейса
                LD HL, .Buffer
                EXX
                CALL_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Attributes.Restore.Wrap
                RES_FLAG_MODIFY .Ready
                RET
; -----------------------------------------
; окраска пересекаемого предмета
; In:
;   DE - позиция относительно сетки в знакоместах (D - y, E - x)
;   BC - размер предмета в знакоместах (B - y, C - x)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.PaintOverlap   ; чтение цвета, выбранного по результату проверки размещения
.ItemColour     EQU $+1                                                         ; цвет обмена или запрещённого размещения
                LD A, #00
; -----------------------------------------
; окраска области предмета с округлением высоты до ячеек сетки
; In:
;   DE - позиция относительно сетки в знакоместах (D - y, E - x)
;   BC - размер предмета в знакоместах (B - y, C - x)
;   A  - атрибут цвета
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.PaintItem      ; перевод позиции в экранные знакоместа
                PUSH AF
                LD A, E
                ADD A, SCR_INVENTORY_POS_X
                LD E, A
                LD A, D
                ADD A, SCR_INVENTORY_POS_Y
                LD D, A

                ; округление высоты до целой ячейки сетки
                LD A, B
                INC A
                AND #FE
                LD B, A
                POP AF
; -----------------------------------------
; заливка прямоугольной области одним атрибутом
; In:
;   DE - позиция в знакоместах (D - y, E - x)
;   BC - размер в знакоместах (B - y, C - x)
;   A  - атрибут цвета
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.Fill           ; расчёт адреса верхнего левого атрибута
                PUSH AF
                CALL Convert.AttributeAdr
                EX DE, HL
                POP AF
                LD E, A

.Row            ; подготовка ширины очередной строки
                PUSH BC
                LD B, C

.Cell           LD (HL), E
                INC HL
                DJNZ .Cell

                ; расчёт начала следующей строки атрибутов
                POP BC
                LD A, #20
                SUB C
                ADD A, L
                LD L, A
                JR NC, .NextRow                                                 ; переход, если перенос в старший байт адреса не требуется
                INC H

.NextRow        DJNZ .Row
                RET

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_GRID_HIGHLIGHT_

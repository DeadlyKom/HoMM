                ifndef _MODULE_INVENTORY_GRAPHICS_DISPLAY_DRAGGED_ITEM_
                define _MODULE_INVENTORY_GRAPHICS_DISPLAY_DRAGGED_ITEM_
; -----------------------------------------
; отображение перетаскиваемого предмета с сохранением фона
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
DraggedItem:    ; проверка активности перетаскивания
                CHECK_INPUT_FLAG INPUT_DRAG_DROP_BIT
                RET Z                                                           ; выход, если перетаскивание неактивно

                ; проверка наличия перетаскиваемого предмета
                LD A, (Inventory.States.DraggedItem.ID)
                CP ITEM_ID_NONE
                RET Z                                                           ; выход, если перетаскиваемый предмет отсутствует

.Ready          FLAG_MODIFY 0                                                   ; флаг, готовности сохранённого фона
                RET C                                                           ; выход, если предмет уже отображён поверх актуального фона

                ; проверка подготовленного размера предмета
                LD BC, (Inventory.States.DraggedItem.Size)
                LD A, B
                OR A
                RET Z                                                           ; выход, если высота предмета не задана

                LD A, C
                OR A
                RET Z                                                           ; выход, если ширина предмета не задана

                ; отображение подсветки перед сохранением фона и выводом предмета
                CALL Inventory.Display.GridHighlight
                LD DE, (Inventory.States.DraggedItem.Location)                  ; чтение подготовленного положения предмета
                PUSH DE                                                         ; сохранение положения на время копирования фона

                ; сохранение фона под новым положением предмета
                LD HL, .Buffer
                LD BC, (Inventory.States.DraggedItem.Size)
                EXX
                CALL_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Bound.Save.Wrap
                POP DE

                SET_FLAG_MODIFY .Ready                                          ; установка готовности сохранённого фона

                ; отображение предмета поверх сохранённого фона
                LD A, (Inventory.States.DraggedItem.ID)
                CALL Inventory.SharedCode.Render.Item.Dragged
                SET_MAIN_FLAG ML_UPDATE_BIT                                     ; запрос показа перетаскиваемого предмета
                RET

.Buffer         EQU Adr.BuffersSlots.DraggedItem.Background \
                    + Size.BuffersSlots.DraggedItem.Background - 4              ; адрес шапки буфера сохранённого фона
; -----------------------------------------
; подготовка положения и фона перетаскиваемого предмета
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;   при полной перерисовке старый фон повторно не восстанавливается
; -----------------------------------------
.Prepare        ; проверка активности перетаскивания
                CHECK_INPUT_FLAG INPUT_DRAG_DROP_BIT
                JR NZ, .Active                                                  ; переход, если перетаскивание активно

                ; сброс готовности фона после завершения перетаскивания
                RES_FLAG_MODIFY DraggedItem.Ready
                RES_FLAG_MODIFY Inventory.Display.GridHighlight.Ready
                RET

.Active         ; проверка первого сохранения фона
                CHECK_FLAG_MODIFY DraggedItem.Ready
                JR NZ, .CheckWindow                                             ; переход, если фон под предметом уже сохранён

                ; запрос удаления предмета из прежнего размещения при взятии
                LD HL, Inventory.States.HoveredItem.Flags
                SET INVENTORY_REDRAW_BIT, (HL)

.CheckWindow    ; проверка запроса полной перерисовки окна
                LD HL, Inventory.States.HoveredItem.Flags
                CHECK_FLAG INVENTORY_REDRAW_BIT
                JR Z, .Position                                                 ; переход, если окно не будет перерисовано целиком

                ; подготовка флагов перед полной перерисовкой
                RES_FLAG_MODIFY DraggedItem.Ready                               ; сброс готовности сохранённого фона предмета
                RES_FLAG_MODIFY Inventory.Display.GridHighlight.Ready           ; сброс готовности сохранённых атрибутов сетки

.Position       ; расчёт положения предмета с учётом точки захвата
                LD HL, (Mouse.Position)
                LD (Inventory.Display.GridHighlight.Cursor), HL
                CALL Inventory.Utilities.DraggedItem.GetPosition.ByCursor       ; DE - положение предмета в знакоместах (D - y, E - x)

.PositionReady  ; проверка изменения положения в знакоместах
                LD HL, (Inventory.States.DraggedItem.Location)
                OR A
                SBC HL, DE
                RET Z                                                           ; выход, если положение предмета не изменилось

                ; удаление прежнего изображения перед изменением положения
                CALL .Restore
                LD (Inventory.States.DraggedItem.Location), DE
                RET
; -----------------------------------------
; восстановление фона перед изменением изображения под предметом
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
.Restore        ; сохранение флагов и адреса вызывающего кода
                PUSH AF
                PUSH HL

                ; проверка активности перетаскивания
                CHECK_INPUT_FLAG INPUT_DRAG_DROP_BIT
                JR Z, .Return                                                   ; переход, если перетаскивание неактивно

                ; проверка наличия изображения предмета на экране
                CHECK_FLAG_MODIFY DraggedItem.Ready
                JR NZ, .SaveRegs                                                ; переход, если предмет отображён поверх сохранённого фона

                ; проверка наличия подсветки без изображения предмета
                CHECK_FLAG_MODIFY Inventory.Display.GridHighlight.Ready
                JR Z, .Return                                                   ; переход, если фон предмета и атрибуты сетки уже восстановлены

.SaveRegs       ; сохранение регистров обработки слота
                PUSH DE
                PUSH BC
                EXX
                PUSH HL
                PUSH DE
                PUSH BC
                EX AF, AF'
                PUSH AF
                EX AF, AF'
                PUSH IX
                PUSH IY

                ; проверка необходимости удалить изображение предмета
                CHECK_FLAG_MODIFY DraggedItem.Ready
                JR Z, .RestoreGrid                                              ; переход, если изображение предмета уже удалено

                ; восстановление пикселей и атрибутов без переносимого предмета
                LD HL, .Buffer
                EXX
                CALL_IN_PAGE Page.SharedScreen, Inventory.SharedScreen.Memcpy.Bound.Restore.Wrap
                RES_FLAG_MODIFY DraggedItem.Ready

.RestoreGrid    ; -----------------------------------------
                ; восстановление атрибутов сетки и регистров вызывающего кода
                ; -----------------------------------------

                ; удаление подсветки после восстановления фона предмета
                CALL Inventory.Display.GridHighlight.Restore

                ; восстановление регистров обработки слота
                POP IY
                POP IX
                POP AF
                EX AF, AF'
                POP BC
                POP DE
                POP HL
                EXX
                POP BC
                POP DE

.Return         POP HL
                POP AF
                RET

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_DRAGGED_ITEM_

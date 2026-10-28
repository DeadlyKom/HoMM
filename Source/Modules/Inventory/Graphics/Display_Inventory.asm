
                ifndef _MODULE_INVENTORY_GRAPHICS_DISPLAY_INVENTORY_
                define _MODULE_INVENTORY_GRAPHICS_DISPLAY_INVENTORY_
; -----------------------------------------
; отображение сетки инвентаря
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ адрес исполнения неизвестен
;   основной экран должен быть выбран перед вызовом
; -----------------------------------------
Inventory:      ; отображение сетки инвентаря
                
                ; инициализация
                LD HL, Slots.Inventory.Grid                                     ; адреса спрайта внутри пакета графики
                LD DE, ((SCR_INVENTORY_POS_Y << 3) << 8) |\
                        (SCR_INVENTORY_POS_X << 3)                              ; позиция сетки в пикселях
                LD B, SCR_INVENTORY_SIZE_Y                                      ; количество строк сетки

.Row            ; установка начала строки и количества столбцов
                LD E, SCR_INVENTORY_POS_X << 3                                  ; начало строки сетки в пикселях
                LD C, SCR_INVENTORY_SIZE_X                                      ; количество столбцов сетки

.Cell           ; отображение текущей ячейки сетки
                PUSH HL
                PUSH BC
                PUSH DE
                CALL .DrawCell
                POP DE
                POP BC
                POP HL

                ; расчёт позиции следующего столбца
                LD A, E
                ADD A, 16
                LD E, A

                ; проверка оставшихся столбцов
                DEC C
                JR NZ, .Cell                                                    ; переход, если остались столбцы

                ; расчёт позиции следующей строки
                LD A, D
                ADD A, 16
                LD D, A

                DJNZ .Row
                RET

.DrawCell       ; отображение спрайта ячейки с атрибутами

                ; подготовка функции вывода спрайта без указания блока спрайтов (FSpriteBlock)
                LD BC, #0000                                                    ; значение счётчиков для полного вывода спрайта
                LD (Kernel.Boundary.Functions.VHCounters), BC                   ; установка счётчиков полного вывода спрайта

                ; установка обработчика данных LD_ATTR
                LD IX, Kernel.Boundary.Functions.LD_ATTR                        ; выбор обработчика LD_ATTR с атрибутами

                ; передача адреса данных через стек обработчику
                PUSH HL                                                         ; адрес сырых данных для Boundary.Draw
                JP Kernel.Boundary.Functions.Draw                               ; переход к выводу с сохранением цепочки возврата
                
                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_INVENTORY_

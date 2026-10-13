
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
; -----------------------------------------
Inventory:      ; отображение сетки инвентаря
                CALL Convert.SetBaseScreen

                ; расчёт адреса спрайта внутри пакета графики
                LD HL, Slots.Inventory.Grid

                ; установка начальной позиции и количества строк
                LD DE, #7878
                LD B, 4

.Row            ; установка начала строки и количества столбцов
                LD E, 15 * 8
                LD C, 8

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

                ; установка вывода без зеркалирования и ограничений
                LD BC, #0000
                LD (Kernel.Boundary.Functions.VHCounters), BC

                ; установка обработчика данных LD_ATTR
                LD IX, Kernel.Boundary.Functions.LD_ATTR

                ; передача адреса данных через стек обработчику
                PUSH HL
                JP Kernel.Boundary.Functions.Draw
                
                endif ; ~_MODULE_INVENTORY_GRAPHICS_DISPLAY_INVENTORY_

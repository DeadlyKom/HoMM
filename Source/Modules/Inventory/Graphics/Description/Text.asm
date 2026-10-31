
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
.Text           ; расчёт позиции текста относительно левого верхнего угла плашки
                LD DE, (Inventory.States.HoveredItem.Location)
                LD A, E
                INC A
                RLCA
                RLCA
                RLCA
                LD E, A                                                         ; E - горизонтальная позиция текста в пикселях
                LD A, D
                ADD A, 3
                RLCA
                RLCA
                RLCA
                LD D, A                                                         ; D - позиция базовой линии шрифта в пикселях

                ; отображение подготовленного названия предмета
                LD HL, .Prepare.Buffer
                JP String.DrawString.AutoPage

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DESCRIPTION_TEXT_

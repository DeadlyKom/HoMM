
                ifndef _INVENTORY_RENDER_ITEMS_
                define _INVENTORY_RENDER_ITEMS_
; -----------------------------------------
; отображение предмета по заголовку визуала
; In:
;   HL - адрес FItemVisual
;   DE - положение на экране в знакоместах (D - y, E - x)
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; Note:
;   ℹ️ код расположен в "общей памяти"
;   основной экран должен быть выбран перед вызовом
;   номер страницы графики заполняется загрузчиком
;   восстановление страницы подготавливается вызывающим кодом
;
;   ⚠️ ВАЖНО ⚠️
;   меняет страницу памяти
; -----------------------------------------
Item:           ; включение страницы графики предметов
.Page           EQU $+1                                                         ; операнд с номером страницы графики
                LD A, #00                                                       ; страница загруженного графического ресурса
                SET_PAGE_A                                                      ; включение страницы графики предметов

                ; расчёт адреса спрайта
                INC HL                                                          ; FItemVisual.Size.Width
                INC HL                                                          ; FItemVisual.Size.Height
                LD C, (HL)
                INC HL 
                LD B, (HL)
                ADD HL, BC

                ; расчёт горизонтальной позиции в пикселях
                LD A, E                                                         ; столбец вывода в знакоместах
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD E, A                                                         ; координата X в пикселях

                ; расчёт вертикальной позиции в пикселях
                LD A, D                                                         ; строка вывода в знакоместах
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD D, A                                                         ; координата Y в пикселях

                ; подготовка функции вывода спрайта без указания блока спрайтов (FSpriteBlock)
                LD BC, #0000                                                    ; значение счётчиков и флагов для полного вывода
                LD (Kernel.Boundary.Functions.VHCounters), BC                   ; установка счётчиков полного вывода спрайта
                LD IX, Kernel.Boundary.Functions.OR_XOR_ATTR                    ; выбор обработчика OR/XOR с атрибутами

                ; передача адреса данных через стек обработчику
                PUSH HL                                                         ; адрес сырых данных для Boundary.Draw
                JP Kernel.Boundary.Functions.Draw                               ; переход к выводу с сохранением цепочки возврата

                display " - Display inventory item:\t\t\t\t", /A, Item, "\t= busy [ ", /D, $-Item, " byte(s) ]"

                endif ; ~_INVENTORY_RENDER_ITEMS_

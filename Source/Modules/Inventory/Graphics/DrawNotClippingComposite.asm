
                ifndef _MODULE_INVENTORY_GRAPHICS_DRAW_NOT_CLIPPING_COMPOSITE_
                define _MODULE_INVENTORY_GRAPHICS_DRAW_NOT_CLIPPING_COMPOSITE_
; -----------------------------------------
; отображение составного спрайта OR & XOR без отсечения
; In:
;   HL - адрес блока спрайтов
;   DE - координаты в пикселях (D - y, E - x)
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY, SP
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
;
;   ⚠️ ВАЖНО ⚠️
;   - спрайт не проверяется на границы экрана и не обрезается
;   - спрайт перед отрисовкой копируется в общий буфер
;   - спрайт может выводиться в любую область экрана
;   - вывод выполняется в основной экран #4000 без изменения атрибутов
;   - все части спрайта должны полностью помещаться на экране
; -----------------------------------------
Draw.NotClipping.Composite:
                ; проверка наличия частей составного спрайта
                LD A, (HL)
                OR A
                RET Z                                                           ; выход, если список частей пуст

                ; инициализация
                LD B, A
                INC HL
                CALL Convert.SetBaseScreen                                      ; выбор основного экрана

                ; получение страницы графики составного спрайта
                LD A, (Kernel.Modules.Inventory.Page)
                LD C, A

.Loop           ; сохранение счётчика, страницы, описания и общей позиции
                PUSH BC
                PUSH HL
                PUSH DE

                ; отображение текущей части составного спрайта
                LD A, C
                CALL Draw.SpriteNotClipping.OR_XOR

                ; восстановление общей позиции и адреса текущей части
                POP DE
                POP HL

                ; расчёт адреса следующей части
                LD BC, FSprite
                ADD HL, BC

                ; восстановление счётчика и страницы графики
                POP BC
                DJNZ .Loop

                RET

                endif ; ~_MODULE_INVENTORY_GRAPHICS_DRAW_NOT_CLIPPING_COMPOSITE_

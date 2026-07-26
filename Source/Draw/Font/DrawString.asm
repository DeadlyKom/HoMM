
                ifndef _DRAW_FONT_STRING_NOT_CLIPPING_
                define _DRAW_FONT_STRING_NOT_CLIPPING_
; -----------------------------------------
; отображение строки (без поддержки обрезки)
; In:
;   DE - координаты в пикселях (D - y, E - x)
;        позиция базовой линии шрифта
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;   - строка не проверяется на границы экрана и не обрезается
;   - спрайт каждого символа перед отрисовкой копируется в общий буфер
;   - экран вывода определяется переменной GameState.Screen
;
;   ℹ️ структура глифа шрифта, см FFontGlyph
; -----------------------------------------
Draw.String:    LD HL, Adr.TilemapBuffer
.Loop           ; проверка на завершающий ноль
                LD A, (HL)
                OR A
                RET Z                                                           ; выход, если строка закончилась

                SUB #20                                                         ; дополнительное смещение
                INC HL
                PUSH HL     ; сохранение адреса строки

                ; расчёт адреса в таблице
                ADD A, LOW (Adr.Font >> 1)
                LD L, A
                ADC A, HIGH (Adr.Font >> 1)
                SUB L
                LD H, A
                ADD HL, HL  ; x2

                ; чтение смещения
                LD C, (HL)
                INC HL
                LD B, (HL)
                ADD HL, BC                                                      ; расчёт адреса символа

                ; проверка наличия высоты
                LD A, (HL)
                INC HL
                LD C, (HL)                                                      ; чтение ширины спрайта
                OR A
                JR Z, .CursorOffset                                             ; переход, если нет тела спрайта

                ; сохранение высоты и ширины спрайта
                INC HL
                LD B, A
                LD (GameState.FontSize), BC

                INC HL          ; пропуск SpacingProfile
                PUSH DE
                
                ; расчёт верхней границы шрифта
                LD A, D         ; позиция базовой линии шрифта
                SUB (HL)        ; FFontGlyph.Baseline
                LD D, A         ; позиция символа по вертикали

                ; адрес спрайта символа
                INC HL

                ; отображение символа
                CALL Font.Draw
                POP DE
                LD A, (GameState.FontSize + FSize.Width)
                LD C, A

.CursorOffset   ; смещение курсора вывода
                LD A, C
                ADD A, E
                DEC A                                                           ; временно смещение на пиксель назад
                LD E, A

                ; переход к следующему символу
                POP HL
                JR .Loop

                display " - Draw string not clipping:\t\t\t\t", /A, Draw.String, "\t= busy [ ", /D, $-Draw.String, " byte(s)  ]"

                endif ; ~ _DRAW_FONT_STRING_NOT_CLIPPING_

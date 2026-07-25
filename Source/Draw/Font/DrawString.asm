
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
;   - строка перед отрисовкой не копируется в буфер
;   - строка выводится только в основное окно (#4000)
;
;   функция временно использует стек для чтения данных спрайта через POP BC
;   защита при разрешённых прерываниях устанавливается внутри функции через RESTORE_BC
;
;   ℹ️ структура шрифта, см FFont
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
                LD C, (HL)                                                      ; чтение отступа спрайта
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
                SUB (HL)        ; FFont.Baseline
                LD D, A         ; позиция символа по вертикали

                ; установка адреса спрайта символа
                INC HL
                LD (Kernel.Sprite.DrawOR_XOR.SpriteAddress), HL

                ; отображение символа
                CALL Font.Draw
                POP DE
                LD A, (GameState.FontSize + FSize.Width)
                LD C, A

.CursorOffset   ; смещение курсора вывода
                LD A, C
                ADD A, E
                DEC A
                LD E, A

                ; переход к следующему символу
                POP HL
                JR .Loop

                display " - Draw string not clipping:\t\t\t\t", /A, Draw.String, "\t= busy [ ", /D, $-Draw.String, " byte(s)  ]"

                endif ; ~ _DRAW_FONT_STRING_NOT_CLIPPING_

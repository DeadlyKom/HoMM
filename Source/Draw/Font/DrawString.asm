
                ifndef _DRAW_FONT_STRING_NOT_CLIPPING_
                define _DRAW_FONT_STRING_NOT_CLIPPING_
; -----------------------------------------
; отображение цветной строки (без поддержки обрезки)
; In:
;   HL - адрес строки
;   DE - координаты в пикселях (D - y, E - x)
;        позиция базовой линии шрифта
;   A  - атрибут цвета
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;   - строка не проверяется на границы экрана и не обрезается
;   - спрайт каждого символа перед отрисовкой копируется в общий буфер
;   - экран вывода определяется переменной GameState.Screen
;
;   ℹ️ необходимо включить страницу шрифта
;   структура глифа шрифта, см FFontGlyph
; -----------------------------------------
Draw.ColorString:; инициализация
                LD BC, Font.Draw.Color.Glyph
                LD (Font.Draw.Color.Attribute), A
                JR Draw.String.Custom
; -----------------------------------------
; отображение строки (без поддержки обрезки)
; In:
;   HL - адрес строки
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
;   ℹ️ необходимо включить страницу шрифта
;   структура глифа шрифта, см FFontGlyph
; -----------------------------------------
Draw.String:    ; инициализация
                LD BC, Font.Draw.Glyph
.Custom         XOR A
                LD (.PreviousRight), A                                          ; сброс профиля предыдущего глифа
                LD (.GlyphCall), BC

.Loop           ; проверка на завершающий ноль
                LD A, (HL)
                OR A
                RET Z                                                           ; выход, если строка закончилась

                SUB #20                                                         ; преобразование к индексу глифа
                INC HL
                PUSH HL     ; сохранение адреса строки

                ; расчёт адреса в таблице
                ADD A, LOW (Adr.Font >> 1)
                LD L, A
                ADC A, HIGH (Adr.Font >> 1)
                SUB L
                LD H, A
                ADD HL, HL  ; x2

                ; чтение относительного смещения глифа
                LD C, (HL)
                INC HL
                LD B, (HL)
                ADD HL, BC                                                      ; расчёт адреса глифа

                ; чтение параметров глифа
                LD A, (HL)                                                      ; FFontGlyph.Height
                INC HL
                LD C, (HL)                                                      ; FFontGlyph.Width
                
                ; проверка наличия высоты
                OR A
                JR Z, .CursorOffset                                             ; переход, если отсутствуют данные спрайта,
                                                                                ; и сброс профиля предыдущего глифа

                INC HL
                LD B, A
                LD (GameState.FontSize), BC

                ; чтение профиля перекрытия
                LD B, (HL)                                                      ; FFontGlyph.SpacingProfile
                INC HL
                PUSH HL                                                         ; сохранение адреса глифа

                ; расчёт допустимого перекрытия текущего глифа с предыдущим
.PreviousRight  EQU $+1
                LD H, #00                                                       ; профиль предыдущего глифа

                ; Upper = Previous.RU + Current.LU
                LD A, H
                RRCA
                RRCA
                AND %00000011
                LD L, A                                                         ; Previous.RU

                LD A, B
                RLCA
                RLCA
                AND %00000011                                                   ; Current.LU
                ADD A, L
                LD L, A                                                         ; L = Upper

                ; Lower = Previous.RL + Current.LL
                LD A, H
                AND %00000011
                LD H, A                                                         ; Previous.RL

                LD A, B
                RRCA
                RRCA
                RRCA
                RRCA
                AND %00000011                                                   ; Current.LL
                ADD A, H                                                        ; A = Lower

                ; Overlap = min(Upper, Lower)
                CP L
                JR C, $+3
                LD A, L

                ; смещение символа влево
                NEG                                                             ; A = -Overlap
                ADD A, E
                LD E, A                                                         ; смещение текущего символа влево

                POP HL                                                          ; восстановление адреса глифа
                PUSH BC                                                         ; сохранение ширины (C) и профиля перекрытия (B)
                PUSH DE                                                         ; сохранение позиции символа

                ; расчёт верхней границы шрифта
                LD A, D         ; позиция базовой линии шрифта
                SUB (HL)        ; FFontGlyph.Baseline
                LD D, A         ; позиция символа по вертикали

                ; адрес спрайта символа
                INC HL

                ; отображение символа
.GlyphCall      EQU $+1
                CALL #0000
                POP DE                                                          ; восстановление позиции символа
                POP BC                                                          ; восстановление ширины (C) и профиля перекрытия (B)

                LD A, B                                                         ; профиль текущего глифа
.CursorOffset   LD (.PreviousRight), A                                          ; сохранение профиля текущего глифа

                ; смещение курсора вывода
                LD A, C
                ADD A, E
                DEC A
                LD E, A

                ; переход к следующему символу
                POP HL
                JR .Loop

                display " - Draw string not clipping:\t\t\t\t", /A, Draw.String, "\t= busy [ ", /D, $-Draw.String, " byte(s)  ]"

                endif ; ~ _DRAW_FONT_STRING_NOT_CLIPPING_

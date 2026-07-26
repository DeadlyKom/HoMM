
                ifndef _DRAW_FONT_SPRITE_NOT_CLIPPING_
                define _DRAW_FONT_SPRITE_NOT_CLIPPING_
; -----------------------------------------
; отображение символа (без поддержки обрезки)
; In:
;   HL - адрес спрайта символа
;   DE - координаты в пикселях (D - y, E - x)
;   GameState.FontSize.Height - высота спрайта в пикселях
;   GameState.FontSize.Width  - ширина спрайта в пикселях (FFontGlyph.Width)
;        максимальная ширина 32 пикселя
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;   - спрайт не проверяется на границы экрана и не обрезается
;   - спрайт перед отрисовкой копируется в буфер
;   - экран вывода определяется переменной GameState.Screen
;
;   ℹ️ структура глифа шрифта, см FFontGlyph
; -----------------------------------------
Draw:           PUSH HL                                                         ; сохранение адреса спрайта

                ; определение адреса экрана
                LD H, HIGH Adr.ScrAdrTable
                LD L, D                                                         ; координата Y (в пикселях)
                LD A, (HL)                                                      ; младший
                INC H
                LD D, (HL)                                                      ; старший

                ; корректировка адреса по горизонтали
                INC H
                LD B, E                                                         ; координата X (в пикселях)
                LD L, B
                OR (HL)                                                         ; номер знакоместа
                LD E, A

                ; корректировка адреса вывода
                LD A, (GameState.Screen)
                XOR D
                AND %10000000
                XOR D
                LD D, A

                POP HL                                                          ; восстановление адреса спрайта

                ; подготовка данных
                PUSH DE                                                         ; сохраним адрес экрана
                EXX
                POP DE                                                          ; восстановить адрес экрана
                LD A, (GameState.FontSize + FSize.Height)                       ; новая высота видимой части спрайта в пикселях
                LD B, A
                LD C, #00                                                       ; обнуление - ширина невидимой части
                EXX

                EX DE, HL                                                       ; DE - адрес спрайта

                ; ширина спрайта в знакоместах (начиная с 0)
                LD A, (GameState.FontSize + FSize.Width)
                DEC A
                SRL A
                SRL A
                SRL A
                EX AF, AF'                                                      ; сохранение ширины

                ; установка типа вывода и страницы исходных данных
                LD A, OR_XOR | Page.Font
                LD (Kernel.Sprite.DrawClipping.Flags), A

                ; DrawOR_XOR переключит страницу после копирования,
                ; поэтому заранее подготовить восстановление страницы шрифта
                PUSH_PAGE
                LD HL, Func.PopPage
                PUSH HL

                ; адрес таблицы расчёта размера спрайта
                EX AF, AF'
                LD L, A
                EX AF, AF'
                LD H, HIGH Adr.MultiplySprite

                JP Kernel.Sprite.DrawOR_XOR.ToCopy

                display " - Draw font not clipping:\t\t\t\t", /A, Draw, "\t= busy [ ", /D, $-Draw, " byte(s)  ]"

                endif ; ~ _DRAW_FONT_SPRITE_NOT_CLIPPING_

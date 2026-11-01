
                ifndef _DRAW_FONT_COLOR_GLYPH_
                define _DRAW_FONT_COLOR_GLYPH_
; -----------------------------------------
; окраска знакомест глифа и отображение его спрайта
; In:
;   HL - адрес спрайта OR & XOR
;   DE - положение глифа в пикселях (D - y, E - x)
;   GameState.FontSize - ширина и высота глифа в пикселях
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   ℹ️ необходимо включить страницу шрифта
;   атрибут устанавливается методом Draw.ColorString
; -----------------------------------------
Draw.Color.Glyph:; сохранение параметров для последующего отображения глифа
                PUSH HL
                PUSH DE

                ; проверка пиксельного сдвига глифа относительно знакоместа
                LD A, E
                AND #07
                LD B, A
                LD A, #FF
                JR Z, .MasksReady                                               ; переход, если глиф выровнен по знакоместу

                ; расчёт адреса младшей части сдвига байта #FF в существующей таблице
                PUSH HL                                                         ; сохранение адреса спрайта на время чтения таблицы
                LD A, B
                ADD A, A
                NEG
                ADD A, (HIGH Adr.ShiftTable) + 15
                LD H, A
                LD L, #FF
                LD A, (HL)                                                      ; чтение маски левой части байта
                POP HL                                                          ; восстановление адреса спрайта

.MasksReady     ; сохранение масок левой и правой частей байта
                LD (.LeftMask), A
                CPL
                LD (.RightMask), A

                ; расчёт количества пар OR & XOR в строке спрайта
                LD A, (GameState.FontSize + FSize.Width)
                DEC A
                SRL A
                SRL A
                SRL A
                INC A
                LD C, A                                                         ; C - количество пар байтов в строке спрайта
                LD A, (GameState.FontSize + FSize.Height)
                LD B, A                                                         ; B - количество пиксельных строк глифа

.Row            ; сохранение счётчиков и положения пиксельной строки
                PUSH BC
                PUSH DE

                ; расчёт координат начала строки глифа в знакоместах
                SRL E
                SRL E
                SRL E
                SRL D
                SRL D
                SRL D
                CALL Convert.AttributeAdr
                LD B, C

.Byte           ; чтение вырезаемых пикселей из XOR-байта спрайта
                INC HL                                                          ; пропуск OR-маски и переход к XOR-байту
                LD C, (HL)
                INC HL                                                          ; переход к следующей паре OR & XOR

                ; проверка пикселей в левом экранном знакоместе
                LD A, C
.LeftMask       EQU $+1
                AND #FF
                CALL NZ, .PaintCell                                             ; вызов, если в левое знакоместо попали пиксели глифа

                ; проверка пикселей в соседнем экранном знакоместе
                INC DE
                LD A, C
.RightMask      EQU $+1
                AND #00
                CALL NZ, .PaintCell                                             ; вызов, если в соседнее знакоместо попали пиксели глифа

                DJNZ .Byte

                ; переход к следующей пиксельной строке глифа
                POP DE
                POP BC
                INC D
                DJNZ .Row

                ; восстановление параметров и отображение глифа обычным методом
                POP DE
                POP HL
                JP Draw.Glyph

.PaintCell      ; запись цвета в знакоместо с пикселями глифа
.Attribute      EQU $+1
                LD A, #00
                LD (DE), A
                RET

                endif ; ~_DRAW_FONT_COLOR_GLYPH_

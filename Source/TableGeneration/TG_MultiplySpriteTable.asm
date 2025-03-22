                ifndef _TABLE_GENERATION_MULTIPLY_SPRITE_TABLE_
                define _TABLE_GENERATION_MULTIPLY_SPRITE_TABLE_

                module Tables
; -----------------------------------------
; генерация таблица умножения для расчёта размера (без учёта маски)
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | 0  | W1 | W0 | R4 | R3 | R2 | R1 | R0 |
;   +----+----+----+----+----+----+----+----+
;
;   W1,W0   [6,5]   - ширина спрайта в знакоместах
;   R4-R0   [4..0]  - количество строк
;
;   Width - ширина спрайта      1-4 байта
;   Row   - количество строк    1-32 строки

; 
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | AR | R4 | R3 | R2 | R1 | R0 | W1 | W0 |
;   +----+----+----+----+----+----+----+----+
;
;   AR      [7]         - флаг, учитывать атрибуты, биты R2..R0 не имеют значения
;   R4-R0   [6..2]      - количество строк              (макс 32 строки)
;   W1,W0   [1,0]       - ширина спрайта в знакоместах  (1-4 байта)
;
;   размер таблицы 256 байт
; -----------------------------------------
TG_MulSprTable: LD HL, Adr.MultiplySprite

                LD D, #20
                LD C, #01
.RowLoop        LD E, C
                LD B, #04
                XOR A
.WidthLoop      ADD A, E
                LD (HL), A
                INC L
                DJNZ .WidthLoop

                INC C
                DEC D
                JR NZ, .RowLoop

                RET

                display " - Multiply sprite table generator:\t\t\t", /A, TG_MulSprTable, "\t= busy [ ", /D, $-TG_MulSprTable, " byte(s)  ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_MULTIPLY_SPRITE_TABLE_

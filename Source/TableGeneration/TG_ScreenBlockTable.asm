                ifndef _TABLE_GENERATION_SCREEN_BLOCK_TABLE_
                define _TABLE_GENERATION_SCREEN_BLOCK_TABLE_

                module Tables
; -----------------------------------------
; генерация таблицы номера экранного блока (с 1 по 22 строку включительно) с высотой гексагона
; In:
;   HL - адрес таблицы выровнен 256 байт!
;   D  - старший байт таблицы Div6Table22 (младший адрес 0-21)
; Out:
; Corrupt:
; Note:
;
;   входные данные:
;
;    ℹ️ структура байта
;       7    6    5    4    3    2    1    0
;    +----+----+----+----+----+----+----+----+
;    | S4 | S3 | S2 | S1 | S0 | H2 | H1 | H0 |
;    +----+----+----+----+----+----+----+----+
;    
;    S4-S0   [7-3]       - номер строки в знакоместах
;    H2-H0   [3-0]       - высота гексагона
;
;   результат:
;
;    ℹ️ структура байта
;       7    6    5    4    3    2    1    0
;    +----+----+----+----+----+----+----+----+
;    | H1 | H0 | 0  | 0  | S1 | S0 | 0  | 0  |
;    +----+----+----+----+----+----+----+----+
;    
;    S1-S0   [3,2]       - смещение в массиве screen block'ов
;    H1,H0   [7,6]       - количество пересекаемых screen block'ов (0,1,2)
;                           0 - screen block 0-3
;                           1 - screen block 4-7
;                           2 - screen block 8-11
;                           3 - screen block 12-15
;
; -----------------------------------------
TG_ScrBlockTable:; инициализация генерации
                ; LD HL, Adr.ScrBlockTable
                ; LD D, HIGH Adr.Div6Table22
                LD A, D
                EXX
                LD H, A
                LD L, #00                                                       ; начальная строка (в знакоместах)Div6Table22

                LD B, SCR_WORLD_SIZE_Y
.RowsLoop       LD C, #00                                                       ; высота гексагона
.HeightLoop     ; цикл просчёта перечсечений высоты гексагона screen block'ов
                LD A, L
                SUB C
                LD E, A
                JR NC, $+4
                LD E, #00   ; установка значения верхнего порога

                ; расчитать разницу screen block'ов
                LD D, L     ; сохранение изначальной строки
                LD A, (HL)  ; чтение B / 6 (0-3) - нижняя строка
                LD L, E     ; номер новой строки (вверхняя гексагона)
                SUB (HL)    ; чтение B / 6 (0-3) - верхняя строка
                LD L, D

                ;
                NEG
                ADD A, #02
                RRCA
                RRCA
                OR (HL)

                EXX
                LD (HL), A
                INC L
                EXX

                INC C
                LD A, C
                CP HEXTILE_ALL_Y
                JR C, .HeightLoop

                INC L                                                           ; следующая строка
                DJNZ .RowsLoop

                RET

                display " - Generate table screen block:\t\t\t\t\t= busy [ ", /D, $-TG_ScrBlockTable, " byte(s) ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_SCREEN_BLOCK_TABLE_

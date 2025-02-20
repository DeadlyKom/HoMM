
                ifndef _TR_DOS_DRAW_
                define _TR_DOS_DRAW_

                ; отображение информации при работе с TR-DOS
; -----------------------------------------
; отображение окна
; In:
;   A - номер фрейма окна
; Out:
; Corrupt:
; Note:
; -----------------------------------------
DrawWindow:     LD HL, .Frame

                ; проверка на 0-ой фрейм
                OR A
                JR Z, .DrawRects

                LD B, A
                LD DE, #05                                                      ; размер данных

.Loop           ; ищим данные фрейма
                ADD HL, DE
                LD A, (HL)
                INC A
                JR NZ, .Loop

                INC HL
                DJNZ .Loop

.DrawRects      ; чтение позиции прямоугольника
                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL

                ; -----------------------------------------
                ; расчёт экраного адреса атрибутов
                ; In:
                ;   DE - координаты D - y (в знакоместах), E - x (в знакоместах)
                ; Out:
                ;   DE - адрес экрана атрибутов
                ; Corrupt:
                ;   AF
                ; -----------------------------------------
                CALL Convert.AttributeAdr

                ; чтение размера прямоугольника
                LD C, (HL)                                                      ; высота
                INC HL
                LD B, (HL)                                                      ; ширина
                INC HL

                ; чтение цвета прямоугольника
                LD A, (HL)
                INC HL

.RectLoop       PUSH HL
                CALL AttributeRect                                              ; заполнение прямоугольника атрибутом
                POP HL

                LD A, (HL)
                INC A
                JR NZ, .DrawRects
                RET

.Frame          ; 0-ой фрейм окна
                DB 12, 11                                                       ; позиция   (в знакоместах)
                DB 1, 8                                                         ; размер    (в знакоместах)
                ZX_COLOR_IPBF BLUE, BLUE, 0, 0                                  ; цвет прямоугольника
                DB #FF                                                          ; конец

                ; 1-ый фрейм окна
                DB 9, 10                                                        ; позиция   (в знакоместах)
                DB 3, 14                                                        ; размер    (в знакоместах)
                ZX_COLOR_IPBF BLUE, BLUE, 0, 0                                  ; цвет прямоугольника

                DB 10, 11                                                       ; позиция   (в знакоместах)
                DB 1, 12                                                        ; размер    (в знакоместах)
                ZX_COLOR_IPBF CYAN, CYAN, 0, 0                                  ; цвет прямоугольника
                DB #FF                                                          ; конец

                ; 2-ой фрейм окна
                DB 5, 9                                                         ; позиция   (в знакоместах)
                DB 5, 22                                                        ; размер    (в знакоместах)
                ZX_COLOR_IPBF BLUE, BLUE, 0, 0                                  ; цвет прямоугольника

                DB 6, 10                                                        ; позиция   (в знакоместах)
                DB 3, 20                                                        ; размер    (в знакоместах)
                ZX_COLOR_IPBF CYAN, CYAN, 0, 0                                  ; цвет прямоугольника
                DB #FF                                                          ; конец

                ; 3-ий фрейм окна
                DB 1, 8                                                         ; позиция   (в знакоместах)
                DB 7, 30                                                        ; размер    (в знакоместах)
                ZX_COLOR_IPBF BLUE, BLUE, 0, 0                                  ; цвет прямоугольника

                DB 2, 9                                                         ; позиция   (в знакоместах)
                DB 5, 28                                                        ; размер    (в знакоместах)
                ZX_COLOR_IPBF CYAN, CYAN, 0, 0                                  ; цвет прямоугольника
                DB #FF                                                          ; конец
; -----------------------------------------
; заполнение прямоугольника атрибутом
; In:
;   A  - цвет заполнения
;   DE - адрес экрана
;   BC - размер прямоугольника (B - x, C - y)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
AttributeRect:
.RowsLoop       LD H, D
                LD L, E
                PUSH BC

.ColumnLoop     LD (HL), A
                INC L
                DJNZ .ColumnLoop

                POP BC
                EX AF, AF'
                LD A, E
                ADD A, #20
                LD E, A
                ADC A, D
                SUB E
                LD D, A
                EX AF, AF'
                DEC C
                JR NZ, .RowsLoop
                RET
; -----------------------------------------
; запомнить символ в буфере
; In:
;   A  - символ
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Print:
.ToBuffer       ; запись в буфер
.Buffer         EQU $+1
                LD HL, #0000
                LD (HL), A
                INC HL
                LD (.Buffer), HL

                ; принудительно завершим строку
                INC HL
                LD (HL), #00

                JP DOS_RestoreRegs

.ToBuffer_BC    ; запись числа в буфер
                LD DE, (.Buffer)
                LD H, B
                LD L, C
                CALL NumToASCII
                LD (.Buffer), DE

                JP DOS_RestoreRegs
; -----------------------------------------
; преобразовать число в строку
; In:
;   HL - число
;   DE - адрес строки
; Out:
; Corrupt:
; Note:
; -----------------------------------------
NumToASCII:     LD BC, -10000
                CALL .Get
                LD BC, -1000
                CALL .Get
                LD BC, -100
                CALL .Get
                LD BC, -10
                CALL .Get
                LD C, B
.Get            LD A, -1
.Loop           INC A
                ADD HL, BC
                JR C, .Loop
                SBC HL, BC

                OR A
                RET Z

                ADD A, '0'
                LD (DE), A
                INC DE
                RET

                endif ; ~ _TR_DOS_DRAW_

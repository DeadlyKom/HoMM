                ifndef _DRAW_HEXAGON_WORLD_
                define _DRAW_HEXAGON_WORLD_
; -----------------------------------------
; отображение гексагонального мира
; In:
; Out:
; Corrupt:
; Note:
;   отображение производится снизу вверх
; -----------------------------------------
World:          CALL HexByDL

                ; инициализация
                LD IX, Adr.RenderBuffer + 64
                LD IYH, HIGH Adr.RenderBuffer
                LD (Exit.ContainerSP), SP
                LD SP, CallSequence + 30
                LD HL, Exit
                PUSH HL

                ; обнуление счётчика строк
                XOR A
                LD (RowCounter), A

                ; формирование цикла по вертикали:
                ;   0 - 7 строк
                ;   1 - 7 строк
                ;   2 - 7 строк
                ;   3 - 8 строк
                ;   4 - 7 строк
                ;   5 - 7 строк
                ;   6 - 7 строк
                ;   7 - 8 строк
                LD BC, .NewRow
                ; PUSH BC (лишний т.к. первый рисуется вне цикла)
                PUSH BC
                PUSH BC
                PUSH BC
                PUSH BC
                PUSH BC
                PUSH BC
                LD A, (.Shift_Y)                                                ; смещение по вертикали в знакоместах (0-7)
                AND #03
                SUB #03
                JR NZ, $+3
                PUSH BC

.NewRow         ; отображение строки
                EXX
                LD HL, RowCounter                                               ; счётчик строк по вертикали в знакоместах (0-7)
                LD C, (HL)                                                      ; чтение значения счётчика
                INC (HL)                                                        ; увеличение счётчика строк
                
                ; корректировка адреса для каждой новой строки (RowCounter * TILEMAP_WIDTH_DATA)
                LD A, C
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, C    ; x5
                LD IYL, A

                ; формирование дополнительного смещения по вертикали,
                ; если счётчик строк >= 4
                ; LD A, (.Shift_Y)
                ; CP #04
                ; CCF

                ; расчёт строки вывода гексагона
                LD A, C
                ; ADC A, #00                                                      ; корректировка высоты, если счётчик строк >= 4
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, #03
.Shift_Y        EQU $+1
                SUB #00                                                         ; смещение по вертикали в знакоместах (0-7)
                INC A                                                           ; смещение отображение на знакоместо ниже
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                OR 7
                LD L, A

                ; определение отображение колонки ниже видимой области
                LD H, #00
                LD A, L
                CP (SCR_WORLD_SIZE_Y + SCR_WORLD_POS_Y) << 3
                LD A, H
                JR C, .InView                                                   ; переход, если начало отображение колонки в видимой области
                
                ; расчёт количество пропускаемых знакомест
                LD A, L
                LD L, (SCR_WORLD_SIZE_Y + SCR_WORLD_POS_Y) << 3
                SUB L
                DEC L                                                           ; установка строки равной самой нижней видемой строки
                
                ; округление до знакоместа
                SRL A
                ADC A, H
                RRA
                ADC A, H
                RRA
                ADC A, H
.InView         EX AF, AF'

                ; рассчёт адреса экранной области
                LD H, HIGH Adr.ScrAdrTable
                LD E, (HL)
                INC E                                                           ; начало с 1 знакоместа
                INC H
                LD D, (HL)
                RES 7, D                                                        ; сброс бита, переход на основной экран

                ; расчёт адреса таблицы в зависимости от смещения карты по горизонтали
                LD B, SCR_WORLD_SIZE_X - HEXTILE_SIZE_X                         ; ширина строки
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                ADD A, C                                                        ; номер рисуемой строки
                RRA
                CCF
                SBC A, A
                AND #03

.Shift_X        EQU $+1                                                         ; смещение по горизонтали в знакоместах (0-5)
                ADD A, #00
                
                ; корректировка смещение по горизонтали в знакоместах (0-5)
                CP #06
                JR C, .Less                                                     ; переход, если меньше ширины гексагона
                SUB #06
                INC IYL                                                         ; смещение адреса читаемого тайла
.Less           LD C, A

                EX AF, AF'
                LD H, A
                EX AF, AF'

                include "Row.asm"
Exit:           ;
.ContainerSP    EQU $+1
                LD SP, #0000
                RET

                display " - Draw hexagon world:\t\t\t\t", /A, World, "\t= busy [ ", /D, $-World-Row.Size, " byte(s)  ]"

                endif ; ~ _DRAW_HEXAGON_WORLD_
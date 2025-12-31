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
World:          ;
                
                ;
                LD IX, Row.Sequent
                LD IY, Adr.RenderBuffer
                LD (Exit.ContainerSP), SP
                LD SP, CallSequence + 30
                LD HL, Exit.RET
                PUSH HL

                XOR A
                LD (VertCounter), A

                LD BC, NewRow
                ; PUSH BC (лишний т.к. первый рисуется вне цикла)
                ; PUSH BC
                ; PUSH BC
                PUSH BC
                PUSH BC
                PUSH BC
                PUSH BC
                LD A, (NewRow.Shift_Y)                                          ; смещение по вертикали в знакоместах (0-7)
                AND #03
                SUB #03
                JR NZ, $+3
                PUSH BC
NewRow          ; LD HL, -14
                ; ADD HL, SP
                ; LD A, L
                ; LD (Row.LowSP), A

                ;
                EXX
                LD HL, VertCounter                                              ; счётчик строк по вертикали в знакоместах (0-7)
                LD C, (HL)
                INC (HL)

                LD A, C
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, #03
.Shift_Y        EQU $ + 1
                SUB #00                                                         ; смещение по вертикали в знакоместах (0-7)
                INC A                                                           ; смещение отображение на знакоместо ниже
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                OR 7
                LD L, A

                ; рассчёт адреса экранной области
                LD H, HIGH Adr.ScrAdrTable
                LD E, (HL)
                INC E                                                           ; начало с 1 знакоместа
                INC H
                LD D, (HL)
                RES 7, D

                ; расчёт адреса таблицы в зависимости от смещения карты по горизонтали
                LD B, 22 - 6                                                    ; ширина строки
                LD A, C
                RRA
                CCF
                SBC A, A
                AND #03

.Shift_X        EQU $ + 1                                                       ; смещение по горизонтали в знакоместах (0-5)
                ADD A, #00
                LD C, A

                ; LD A, C
                OR A
                JR Z, .L0

                PUSH IX

                LD A, #06
                SUB C
                EXX
                LD HL, Column.x8
                LD BC, Column.x6
                LD DE, Column.x2

                PUSH DE ; x2
                DEC A
                JR Z, Row.LLL0
                PUSH BC ; x6
                DEC A
                JR Z, Row.LLL0
                PUSH HL ; x8
                DEC A
                JR Z, Row.LLL0
                PUSH HL ; x8
                DEC A
                JR Z, Row.LLL0
                PUSH BC ; x6
                JR Row.LLL0

.L0             include "Row.asm"
Exit:           ;
.ContainerSP    EQU $+1
.RET            LD SP, #0000
                RET

                display " - Draw hexagon world:\t\t\t\t", /A, World, "\t= busy [ ", /D, $-World, " byte(s)  ]"

                endif ; ~ _DRAW_HEXAGON_WORLD_
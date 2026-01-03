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
                LD IX, Row.Sequent
                LD IY, Adr.RenderBuffer
                LD (Exit.ContainerSP), SP
                LD SP, CallSequence + 30
                LD HL, Exit
                PUSH HL

                ; XOR A
                LD A, #00
                LD (VertCounter), A

                LD BC, NewRow
                ; PUSH BC (лишний т.к. первый рисуется вне цикла)
                PUSH BC
                PUSH BC
                PUSH BC
                PUSH BC
                PUSH BC
                PUSH BC
                LD A, (NewRow.Shift_Y)                                          ; смещение по вертикали в знакоместах (0-7)
                AND #03
                SUB #03
                JR NZ, $+3
                PUSH BC
NewRow          ;
                EXX
                LD HL, VertCounter                                              ; счётчик строк по вертикали в знакоместах (0-7)
                LD C, (HL)
                INC (HL)

                LD A, (.Shift_Y)
                CP #04
                CCF

                LD A, C
                ADC A, #00
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, #03
.Shift_Y        EQU $ + 1
                SUB #04                                                         ; смещение по вертикали в знакоместах (0-7)
                INC A                                                           ; смещение отображение на знакоместо ниже
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                OR 7
                LD L, A

                ; округление до знакоместа
                LD H, #00
                LD A, L
                CP 184
                LD A, H
                JR C, .LLLLLL                                                   ; переход, если начало отображение колонки в видимой области
                LD A, L
                LD L, 184
                SUB L
                DEC L
                SRL A
                ADC A, H
                RRA
                ADC A, H
                RRA
                ADC A, H
.LLLLLL         EX AF, AF'

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

                include "Row.asm"
Exit:           ;
.ContainerSP    EQU $+1
                LD SP, #0000
                RET

                display " - Draw hexagon world:\t\t\t\t", /A, World, "\t= busy [ ", /D, $-World, " byte(s)  ]"

                endif ; ~ _DRAW_HEXAGON_WORLD_
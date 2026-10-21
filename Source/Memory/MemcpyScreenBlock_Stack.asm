
                ifndef _MEMORY_COPY_SCREEN_BLOCK_STACK_
                define _MEMORY_COPY_SCREEN_BLOCK_STACK_

                module Memcpy
Begin:          EQU $
; -----------------------------------------
; копирование экранного блока шириной в 6 знакомест
; In:
;   HL  - начальный адрес
;   IXL - высота в знакоместах
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Screen_6:       ; инициализация
                PUSH HL
                LD A, L
                ADD A, #06
                LD L, A
                SET 7, H
                EXX
                POP HL

                LD (.ContainerSP), SP

.Loop_06        ; копирование пикселей
.l0             POP_LINE_6
                PUSH_LINE_6
.l1             POP_LINE_6
                PUSH_LINE_6
.l2             POP_LINE_6
                PUSH_LINE_6
.l3             POP_LINE_6
                PUSH_LINE_6
.l4             POP_LINE_6
                PUSH_LINE_6
.l5             POP_LINE_6
                PUSH_LINE_6
.l6             POP_LINE_6
                PUSH_LINE_6
.l7             POP_LINE_6_
                PUSH_LINE_6_

                ; копирование атрибутов
.PopAtr         HL_TO_ATTR_HL_SAVE_SCREEN
                POP_ATTR_6
.PushAtr        HL_TO_ATTR_HL_SAVE_SCREEN
                PUSH_ATTR_6
    
                ; переход на знакоместо ниже
                DOWN_HL
                EXX
                DOWN_HL
                EXX

                DEC IXL
                JP NZ, .Loop_06

.ContainerSP    EQU $+1
                LD SP, #0000
                RET
; -----------------------------------------
; копирование экранного блока шириной в 6 знакомест
; In:
;   HL  - начальный адрес
;   IXL - высота в знакоместах
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Screen_4:       ; инициализация
                PUSH HL
                LD A, L
                ADD A, #04
                LD L, A
                SET 7, H
                EXX
                POP HL

                LD (.ContainerSP), SP
.Loop_04        ; копирование пикселей
.l0             POP_LINE_4
                PUSH_LINE_4
.l1             POP_LINE_4
                PUSH_LINE_4
.l2             POP_LINE_4
                PUSH_LINE_4
.l3             POP_LINE_4
                PUSH_LINE_4
.l4             POP_LINE_4
                PUSH_LINE_4
.l5             POP_LINE_4
                PUSH_LINE_4
.l6             POP_LINE_4
                PUSH_LINE_4
.l7             POP_LINE_4_
                PUSH_LINE_4_

                ; копирование атрибутов
.PopAtr         HL_TO_ATTR_HL_SAVE_SCREEN
                POP_ATTR_4
.PushAtr        HL_TO_ATTR_HL_SAVE_SCREEN
                PUSH_ATTR_4
    
                ; переход на знакоместо ниже
                DOWN_HL
                EXX
                DOWN_HL
                EXX

                DEC IXL
                JP NZ, .Loop_04

.ContainerSP    EQU $+1
                LD SP, #0000
                RET

                display " - Memcpy screen block 'Stack':\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule

                endif ; ~_MEMORY_COPY_SCREEN_BLOCK_STACK_

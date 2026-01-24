
                ifndef _MEMORY_COPY_SCREEN_BLOCK_STACK_
                define _MEMORY_COPY_SCREEN_BLOCK_STACK_

                module Memcpy
Begin:          EQU $
; -----------------------------------------
; 
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
POP_LINE_6      macro
                LD SP, HL
                INC H
                POP DE
                POP BC
                POP AF
                EX AF, AF'
                EXX
                endm
POP_LINE_4      macro
                LD SP, HL
                INC H
                POP DE
                POP BC
                EXX
                endm
POP_LINE_6_     macro
                LD SP, HL
                POP DE
                POP BC
                POP AF
                EXX
                endm
POP_LINE_4_     macro
                LD SP, HL
                POP DE
                POP BC
                EXX
                endm
POP_ATTR_6      macro
                LD SP, HL
                EX DE, HL
                POP DE
                POP BC
                POP AF
                EXX
                endm
POP_ATTR_4      macro
                LD SP, HL
                EX DE, HL
                POP DE
                POP BC
                EXX
                endm
; -----------------------------------------
; 
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
PUSH_LINE_6     macro
                LD SP, HL
                INC H
                EXX
                EX AF, AF'
                PUSH AF
                PUSH BC
                PUSH DE
                endm
PUSH_LINE_4     macro
                LD SP, HL
                INC H
                EXX
                PUSH BC
                PUSH DE
                endm
PUSH_LINE_6_    macro
                LD SP, HL
                EXX
                PUSH AF
                PUSH BC
                PUSH DE
                endm
PUSH_LINE_4_    macro
                LD SP, HL
                EXX
                PUSH BC
                PUSH DE
                endm
PUSH_ATTR_6     macro
                LD SP, HL
                EX DE, HL
                EXX
                PUSH AF
                PUSH BC
                PUSH DE
                endm
PUSH_ATTR_4     macro
                LD SP, HL
                EX DE, HL
                EXX
                PUSH BC
                PUSH DE
                endm
; -----------------------------------------
; 
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
DOWN_HL         macro
                INC H
                LD A, L
                SUB #E0
                LD L, A
                SBC A, A
                AND #F8
                ADD A, H
                LD H, A
                endm
; -----------------------------------------
; преобразование адрес экрана в атрибутный
; In:
;   HL  - адрес экрана
; Out:
;   HL  - адрес знакоместа атрибутов
;   DE  - адрес экрана
; Corrupt:
;   DE
; Note:
;   отображение производится снизу вверх
; -----------------------------------------
HL_TO_ATTR_HL   macro
                LD E, L
                LD D, H
                LD L, H
                LD H, HIGH Adr.ScrAttrAdrTable
                LD H, (HL)
                LD L, E
                endm
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
.PopAtr         HL_TO_ATTR_HL
                POP_ATTR_6
.PushAtr        HL_TO_ATTR_HL
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
.PopAtr         HL_TO_ATTR_HL
                POP_ATTR_4
.PushAtr        HL_TO_ATTR_HL
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
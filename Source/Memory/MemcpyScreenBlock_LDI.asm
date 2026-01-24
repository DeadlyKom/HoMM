
                ifndef _MEMORY_COPY_SCREEN_BLOCK_LDI_
                define _MEMORY_COPY_SCREEN_BLOCK_LDI_

                module Memcpy
Begin:          EQU $
; -----------------------------------------
; копирование строки в 6 байт
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
MEMCPY_BYTES    macro NumByte?
                rept (NumByte?)-1
                LDI
                endr
                LD A, (HL)
                LD (DE), A
                INC H
                INC D
                endm
MEMCPY_BYTES_   macro NumByte?
                rept (NumByte?)
                LDI
                endr
                endm

MEMCPY_BYTES_R  macro NumByte?
                rept (NumByte?)-1
                LDD
                endr
                LD A, (HL)
                LD (DE), A
                INC H
                INC D
                endm
MEMCPY_BYTES_R_ macro NumByte?
                rept (NumByte?)-1
                LDD
                endr
                LD A, (HL)
                LD (DE), A
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
; Corrupt:
;   DE
; Note:
;   отображение производится снизу вверх
; -----------------------------------------
HL_TO_ATTR_HL   macro
                LD A, L
                LD L, H
                LD H, HIGH Adr.ScrAttrAdrTable
                LD H, (HL)
                LD L, A
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
Screen_6:       
.Loop_06        LD D, H
                LD E, L
                SET 7, D
                
                ; копирование пикселей
.l0             MEMCPY_BYTES 6
.l1             MEMCPY_BYTES_R 6
.l2             MEMCPY_BYTES 6
.l3             MEMCPY_BYTES_R 6
.l4             MEMCPY_BYTES 6
.l5             MEMCPY_BYTES_R 6
.l6             MEMCPY_BYTES 6
.l7             MEMCPY_BYTES_R_ 6

                ; копирование атрибутов
                PUSH HL
                HL_TO_ATTR_HL
                LD D, H
                LD E, L
                SET 7, D
                MEMCPY_BYTES_ 6
    
                ; переход на знакоместо ниже
                POP HL
                DOWN_HL

                DEC IXL
                JP NZ, .Loop_06
                RET

; -----------------------------------------
; копирование экранного блока шириной в 4 знакомест
; In:
;   HL  - начальный адрес
;   IXL - высота в знакоместах
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Screen_4:
.Loop_04        LD D, H
                LD E, L
                SET 7, D
                
                ; копирование пикселей
.l0             MEMCPY_BYTES 4
.l1             MEMCPY_BYTES_R 4
.l2             MEMCPY_BYTES 4
.l3             MEMCPY_BYTES_R 4
.l4             MEMCPY_BYTES 4
.l5             MEMCPY_BYTES_R 4
.l6             MEMCPY_BYTES 4
.l7             MEMCPY_BYTES_R_ 4

                ; копирование атрибутов
                PUSH HL
                HL_TO_ATTR_HL
                LD D, H
                LD E, L
                SET 7, D
                MEMCPY_BYTES_ 4
    
                ; переход на знакоместо ниже
                POP HL
                DOWN_HL

                DEC IXL
                JP NZ, .Loop_04
                RET

                display " - Memcpy screen block 'LDI':\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule

                endif ; ~_MEMORY_COPY_SCREEN_BLOCK_LDI_
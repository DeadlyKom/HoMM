
                ifndef _MINIMAP_MEMORY_COPY_
                define _MINIMAP_MEMORY_COPY_
MEMCPY_MM_BYTES macro NumByte?
                LD A, E
                rept (NumByte?)
                LDI
                endr
                LD E, A
                INC D
                endm
MEMCPY_MM_BYTES_ macro NumByte?
                LD A, E
                rept (NumByte?)
                LDI
                endr
                LD E, A
                endm
; -----------------------------------------
; 
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
DOWN_MM_DE      macro
                INC D
                LD A, E
                SUB #E0
                LD E, A
                SBC A, A
                AND #F8
                ADD A, D
                LD D, A
                endm
; -----------------------------------------
; копирование миникарты
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Memcpy:         ; инициализация
                LD HL, Adr.FogShadingBuf
                SCREEN_ADR_REG DE, SCR_ADR_BASE, SCR_MINIMAP_POS_X << 3, SCR_MINIMAP_POS_Y << 3
                LD IXL, SCR_MINIMAP_SIZE_Y

.Loop_06        ; копирование пикселей
.l0             MEMCPY_MM_BYTES SCR_MINIMAP_SIZE_X
.l1             MEMCPY_MM_BYTES SCR_MINIMAP_SIZE_X
.l2             MEMCPY_MM_BYTES SCR_MINIMAP_SIZE_X
.l3             MEMCPY_MM_BYTES SCR_MINIMAP_SIZE_X
.l4             MEMCPY_MM_BYTES SCR_MINIMAP_SIZE_X
.l5             MEMCPY_MM_BYTES SCR_MINIMAP_SIZE_X
.l6             MEMCPY_MM_BYTES SCR_MINIMAP_SIZE_X
.l7             MEMCPY_MM_BYTES_ SCR_MINIMAP_SIZE_X

                ; переход на знакоместо ниже
                DOWN_MM_DE

                DEC IXL
                JP NZ, .Loop_06
                RET
                RET

                display " - Memory copy minimap:\t\t\t\t", /A, Memcpy, "\t= busy [ ", /D, $-Memcpy, " byte(s)  ]"

                endif ; ~_MINIMAP_MEMORY_COPY_

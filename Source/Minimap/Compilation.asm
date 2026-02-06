
                ifndef _MINIMAP_COMPILATION_
                define _MINIMAP_COMPILATION_
COMPILATION_BYTE macro
                LD A, (DE)
                OR (HL)
                LD (HL), A
                INC HL
                INC DE
                endm
; -----------------------------------------
; компиляция миникарты
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Compilation:    LD HL, Adr.FogShadingBuf
                LD DE, Adr.MapShadingBuf
                LD B, MAX_WORLD_HEX_Y

.Loop           COMPILATION_BYTE
                COMPILATION_BYTE
                COMPILATION_BYTE
                COMPILATION_BYTE
                COMPILATION_BYTE
                COMPILATION_BYTE
                COMPILATION_BYTE
                COMPILATION_BYTE
                DJNZ .Loop

                RET

                display " - Compilation minimap:\t\t\t\t", /A, Compilation, "\t= busy [ ", /D, $-Compilation, " byte(s)  ]"

                endif ; ~_MINIMAP_COMPILATION_

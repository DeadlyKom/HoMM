
                ifndef _MEMORY_COPY_FAST_LDIR_
                define _MEMORY_COPY_FAST_LDIR_

                module Memcpy
; -----------------------------------------
; копирование данных
; In:
;   HL - адрес исходника
;   DE - адрес назначения
;   BC - длина блока (не равна нулю!)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   копирование эффективно, если размер блока > 18 байт
; -----------------------------------------
FastLDIR:       XOR A
                SUB C
                AND #3F
                ADD A, A    ; x2
                LD (.Jump), A
.Jump           EQU $+1
                JR NZ, .Loop
.Loop           rept 64
                LDI
                endr
                JP PE, .Loop

                RET

                display " - Memcpy fast LDIR: \t\t\t\t\t", /A, FastLDIR, " = busy [ ", /D, $ - FastLDIR, " byte(s)  ]"
                
                endmodule

                endif ; ~_MEMORY_COPY_FAST_LDIR_
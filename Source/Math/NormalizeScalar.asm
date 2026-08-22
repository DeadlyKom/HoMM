
                ifndef _MATH_NORMALIZE_SCALAR_
                define _MATH_NORMALIZE_SCALAR_

                module Math
; -----------------------------------------
; нормализация беззнакового скаляра к диапазону 0..255
; In:
;   A - нормализуемое значение [0..E]
;   E - верхняя граница исходного диапазона [1..255]
; Out:
;   A - нормализованное значение [0..255]
; Corrupt:
;   HL, BC, AF
; Note:
;   Result = Value * 255 / Range
; -----------------------------------------
NormalizeScal:  ; расчёт Value * 255 = Value * 256 - Value
                LD H, A
                LD L, #00
                LD C, A
                LD B, L
                OR A                                                            ; сброс флага переполнения перед вычитанием
                SBC HL, BC
                ; -----------------------------------------
                ; деление HL на E
                ; In:
                ;   HL - делимое
                ;   E  - делитель
                ; Out:
                ;   L  - результат деления
                ;   H  - остаток
                ; Corrupt:
                ;   HL, AF
                ; -----------------------------------------
                DIV_16x8_16
                LD A, L                                                         ; нормализованное значение
                RET

                display " - Normalize scalar:\t\t\t\t\t", /A, NormalizeScal, "\t= busy [ ", /D, $-NormalizeScal, " byte(s)  ]"
                endmodule

                endif ; ~_MATH_NORMALIZE_SCALAR_

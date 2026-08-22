
                ifndef _MATH_NORMALIZE_VECTOR_
                define _MATH_NORMALIZE_VECTOR_

                module Math
; -----------------------------------------
; нормализация вектора
; In:
;   DE - вектор (D - y [-128..127], E - x [-128..127])
; Out:
;   DE - нормализованный ветор (D - y [-128..127], E - x [-128..127])
;   A' - Sqrt(squared)
; Corrupt:
; Note:
; -----------------------------------------
NormalizeVec:   PUSH DE

                ; squared = x*x + y*y
                ; -----------------------------------------
                ; расчёт квадрата расстояния
                ; In :
                ;   DE - дельта расстояния (D - y [-128..127], E - x [-128..127])
                ; Out :
                ;   HL - квадрат расстояния
                ;   DE - модули дельт расстояния (D - |y|, E - |x|)
                ; -----------------------------------------
                CALL Math.DistSquared
                PUSH DE

                ; squared = Sqrt(squared)
                ; -----------------------------------------
                ; расчёт квадратного кореня
                ; In:
                ;   HL - значение
                ; Out:
                ;   A  - результат
                ;   HL - остаток 
                ; -----------------------------------------
                CALL Math.Sqrt

                POP DE
                LD C, E                                                         ; сохранение x
                LD E, A
                EX AF, AF'                                                      ; сохранение Sqrt(squared)
                
                ; y /= squared
                ; -----------------------------------------
                ; деление HL на E
                ; In :
                ;   HL - делимое
                ;   E  - делитель
                ; Out :
                ;   L  - результат деления
                ;   H  - остаток
                ; Corrupt :
                ;   HL, B, AF
                ; -----------------------------------------
                LD H, D
                LD L, #00
                CALL Math.Div16x8_16
                LD D, L                                                         ; сохранение результата y

                ; x /= squared
                ; -----------------------------------------
                ; деление HL на E
                ; In :
                ;   HL - делимое
                ;   E  - делитель
                ; Out :
                ;   L  - результат деления
                ;   H  - остаток
                ; Corrupt :
                ;   HL, B, AF
                ; -----------------------------------------
                LD H, C                                                         ; восстановление x
                LD L, #00
                CALL Math.Div16x8_16
                LD E, L                                                         ; сохранение результата x
                ; DE - нормальзованный вектор (D - y, E - x)

                ; восстановление знаков
                POP HL
                SRL D
                LD A, D
                
                RL H
                JR NC, $+5
                NEG
                LD D, A

                SRL E
                LD A, E
                RL L
                JR NC, $+5
                NEG
                LD E, A

                RET

                display " - Normalize vector:\t\t\t\t\t", /A, NormalizeVec, "\t= busy [ ", /D, $-NormalizeVec, " byte(s)  ]"
                endmodule

                endif ; ~_MATH_NORMALIZE_VECTOR_

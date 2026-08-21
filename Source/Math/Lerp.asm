
                ifndef _MATH_LERP_
                define _MATH_LERP_

                module Math
; -----------------------------------------
; линейная интерполяция двух 8-битных беззнаковых значений
; In:
;   A - Alpha       [0 .. 255]
;   D - значение A  [0 .. 255]
;   E - значение B  [0 .. 255]
; Out:
;   A - результат интерполяции  [0 .. 255]
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   Delta = abs(B - A)
;   Value = Delta * Alpha / 255
;
;   если A < B, Result = A + Value
;   если A > B, Result = A - Value
;
;   при Alpha = 0 возвращается A
;   при Alpha = 255 возвращается B
; -----------------------------------------
Lerp8:          LD C, A                                                         ; Alpha

                ; определение направления интерполяции
                LD A, D                                                         ; значение A
                CP E                                                            ; сравнение A с B
                RET Z                                                           ; выход, если границы диапазона равны
                JR C, .Delta                                                    ; переход, если перестановка границ не требуется

                ; перестановка границ нисходящего диапазона
                LD A, D
                LD D, E
                LD E, A                                                         ; D = B, E = A

.Delta          EX AF, AF'                                                      ; сохранение значение A и направление,
                                                                                ; флаг переполнения установлен при A < B
                LD A, E
                SUB D                                                           ; Delta = abs(B - A)
                LD E, A
                LD D, #00                                                       ; DE = Delta

                ; -----------------------------------------
                ; умножение DE на A
                ; In:
                ;   DE - множимое
                ;   A  - множитель
                ; Out:
                ;   HL - результат умножения DE * A
                ; Corrupt:
                ;   HL, F
                ; -----------------------------------------
                LD A, C
                MUL_16x8_16                                                     ; HL = Delta * Alpha

                ; деление HL на 255
                LD A, H
                INC A
                ADD A, L                                                        ; флаг переполнения = (H + L) >= 255
                LD A, H
                ADC A, #00                                                      ; A = Delta * Alpha / 255
                LD C, A                                                         ; Value

                ; применение направления интерполяции
                EX AF, AF'                                                      ; восстановление значение A и направление,
                                                                                ; флаг переполнения установлен при A < B
                JR C, .Add

.Subtract       SUB C                                                           ; Result = A - Value
                RET

.Add            ADD A, C                                                       ; Result = A + Value
                RET

                endmodule

                endif ; ~_MATH_LERP_

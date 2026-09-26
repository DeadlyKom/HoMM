
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_FUNCTIONS_ELLIPSE_
                define _VFX_CROSSFADE_FALLING_BLOCKS_FUNCTIONS_ELLIPSE_
; -----------------------------------------
; расчёт расстояния от блока до центра по эллиптической метрике
; In:
;   DE - смещения в блоках, D = dy [-11..11], E = dx [-15..15]
; Out:
;   A  - байтовая дистанция [0..250]
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в странице 7
;   пропорция эллипса 48 на 40 соответствует основанию игрового гексагона
;   A = (25 * dx * dx + 36 * dy * dy + 39) / 40
;   результат приведён к одному байту для удобства хранения
;   деление целочисленное, нулевое значение только в центре
; -----------------------------------------
Ellipse:        ; модуль |dx|
                LD A, E                                                         ; смещение по X
                OR A
                JP P, $+5
                NEG
                LD E, A

                ; модуль |dy|
                LD A, D                                                         ; смещение по Y
                OR A
                JP P, $+5
                NEG
                LD B, A

                ; расчёт квадрата смещения по X
                LD D, #00
                LD A, E
                ; ----------------------------------------
                ; In:
                ;   DE - multiplicand
                ;   A  - multiplier
                ; Out :
                ;   HL - product DE * A
                ; Corrupt :
                ;   HL, F
                ; ----------------------------------------
                CALL Math.Mul16x8_16

                ; расчёт вклада X, умножение квадрата смещения на 25
                LD D, H
                LD E, L
                ADD HL, HL                                                      ; 2 * dx * dx
                ADD HL, DE                                                      ; 3 * dx * dx
                ADD HL, HL                                                      ; 6 * dx * dx
                ADD HL, HL                                                      ; 12 * dx * dx
                ADD HL, HL                                                      ; 24 * dx * dx
                ADD HL, DE                                                      ; 25 * dx * dx

                ; сохранение вклада X на время расчёта вклада Y
                PUSH HL

                ; расчёт квадрата смещения по Y
                LD E, B
                LD D, #00
                LD A, B
                ; ----------------------------------------
                ; In:
                ;   DE - multiplicand
                ;   A  - multiplier
                ; Out :
                ;   HL - product DE * A
                ; Corrupt :
                ;   HL, F
                ; ----------------------------------------
                CALL Math.Mul16x8_16

                ; расчёт вклада Y, умножение квадрата смещения на 36
                ADD HL, HL                                                      ; 2 * dy * dy
                ADD HL, HL                                                      ; 4 * dy * dy
                LD D, H
                LD E, L
                ADD HL, HL                                                      ; 8 * dy * dy
                ADD HL, HL                                                      ; 16 * dy * dy
                ADD HL, HL                                                      ; 32 * dy * dy
                ADD HL, DE                                                      ; 36 * dy * dy

                ; расчёт суммы вкладов X и Y
                POP DE
                ADD HL, DE

                ; расчёт числителя для деления с округлением вверх
                LD DE, #0027
                ADD HL, DE

                ; расчёт байтовой дистанции, деление суммы на 40
                LD E, #28
                
                ; -----------------------------------------
                ; деление HL на E
                ; In :
                ;   HL - делимое
                ;   E  - делитель
                ; Out :
                ;   L  - результат деления
                ;   H  - остаток
                ; Corrupt :
                ;   HL, AF
                ; -----------------------------------------
                CALL Math.Div16x8_16
                LD A, L

                RET

                endif ; ~_VFX_CROSSFADE_FALLING_BLOCKS_FUNCTIONS_ELLIPSE_

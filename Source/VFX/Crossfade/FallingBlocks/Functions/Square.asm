
                ifndef _VFX_CROSSFADE_FALLING_BLOCKS_FUNCTIONS_SQUARE_
                define _VFX_CROSSFADE_FALLING_BLOCKS_FUNCTIONS_SQUARE_
; -----------------------------------------
; расчёт расстояния от блока до центра по квадратной метрике
; In:
;   DE - смещения в блоках, D = dy [-11..11], E = dx [-15..15]
; Out:
;   A  - байтовая дистанция [0..15]
; Corrupt:
;   DE, AF
; Note:
;   ℹ️ код расположен в странице 7
;   A = max(abs(dx), abs(dy))
;   нулевое значение только в центре
; -----------------------------------------
Square:         ; модуль |dx|
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

                ; сравнение модулей смещений для выбора наибольшего
                CP E
                RET NC                                                          ; выход, если модуль смещения по Y не меньше модуля смещения по X

                LD A, E
                RET

                endif ; ~_VFX_CROSSFADE_FALLING_BLOCKS_FUNCTIONS_SQUARE_

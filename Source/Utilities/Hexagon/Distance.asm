
                ifndef _HEXAGON_DISTANCE_BETWEEN_HEXAGONS_
                define _HEXAGON_DISTANCE_BETWEEN_HEXAGONS_

                module Hexagon
; -----------------------------------------
; определение расстояния между гексагонами
; In:
;   DE - координаты гексагона 1 (D - y, E - x)
;   BC - координаты гексагона 2 (B - y, C - x)
; Out:
;   A  - расстояние между гексагонами
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
Distance:       ; преобразование в аксиальные координаты первый гексагн
                LD L, D
                LD A, E
                SRA D
                SUB D
                LD D, L
                LD E, A     ; E - q1, D - r1

                ; преобразование в аксиальные координаты первый гексагн
                LD L, B
                LD A, C
                SRA B
                SUB B
                LD B, L
                LD C, A     ; C - q2, B - r2

                ; преобразование в кубические координаты
                LD A, E
                SUB C
                JP P, $+5
                NEG
                LD L, A     ; L - dq = abs(q1 - q2)
                LD A, D
                SUB B
                JP P, $+5
                NEG
                LD H, A     ; H - dr = abs(r1 - r2)

                ; abs((q1 + r1) - (q2 + r2))
                LD A, C
                ADD A, B
                LD C, A
                LD A, E
                ADD A, D
                SUB C
                JP P, $+5
                NEG
                ; A - dsum = abs((q1 + r1) - (q2 + r2))

                ; (dq + dr + dsum) / 2
                ADD A, L
                ADD A, H
                SRA A

                RET

                endmodule

                endif ; ~_HEXAGON_DISTANCE_BETWEEN_HEXAGONS_

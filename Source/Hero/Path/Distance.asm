
                ifndef _HERO_PATH_DISTANCE_
                define _HERO_PATH_DISTANCE_
; -----------------------------------------
; определение расстояние пути
; In:
;   DE - адрес хранения FPath
;   IX - адрес структуры объекта (FObjectHero)
; Out:
;   HL - растояние между точками по вертикали
;   DE - растояние между точками по горизонтали
; Corrupt:
; Note:
;   код расположен рядом с картой (страница 0)
; -----------------------------------------
Distance:       PUSH BC
                ; ToDo в будущем учитывать положение WayPoint'ов
                ;      пока расчитываем расстояние между центрами гексагонов

                ; -----------------------------------------
                ; X1 = X.High * 48 + (X.Low >> 2) - (Y.High % 1) * 24
                LD A, (IX + FObject.Position.X.High)
                ADD A, A    ; x2
                LD L, A
                ADD A, A    ; x4
                ADD A, L    ; x6
                LD L, A
                LD H, #00
                LD B, H
                RL H
                ADD HL, HL  ; x12
                ADD HL, HL  ; x24
                ADD HL, HL  ; x48
                LD C, (IX + FObject.Position.X.Low)
                SRL C
                SRL C
                ADD HL, BC  ; HL - X.High * 48 + (X.Low >> 2)
                ; учёт смещение по горизонтали, если чётная строка
                LD A, (IX + FObject.Position.Y.High)
                RRA
                CCF
                SBC A, A
                AND -((HEXTILE_SIZE_X << 3) >> 1)   ; половина ширины гексагона
                LD C, A
                ADD A, A
                SBC A, A
                LD B, A
                ADD HL, BC  ; HL - X.High * 48 + (X.Low >> 2) - (Y.High % 1) * 24
                PUSH HL   ; сохранение результата
                
                ; X2 = X.High * 48 + (X.Low >> 2) - (Y.High % 1) * 24
                LD A, (DE)  ; FPath.HexCoord.X (старший байт)
                ADD A, A    ; x2
                LD L, A
                ADD A, A    ; x4
                ADD A, L    ; x6
                LD L, A
                LD H, #00
                LD B, H
                RL H
                ADD HL, HL  ; x12
                ADD HL, HL  ; x24
                ADD HL, HL  ; x48
                LD C, (HEXTILE_SIZE_X << 4) >> 2    ; середина гексагона
                ADD HL, BC  ; HL - X.High * 48 + (X.Low >> 2)
                ; учёт смещение по горизонтали, если чётная строка
                INC E
                LD A, (DE)  ; FPath.HexCoord.Y (старший байт)
                RRA
                CCF
                SBC A, A
                AND -((HEXTILE_SIZE_X << 3) >> 1)   ; половина ширины гексагона
                LD C, A
                ADD A, A
                SBC A, A
                LD B, A
                ADD HL, BC  ; HL - X.High * 48 + (X.Low >> 2) - (Y.High % 1) * 24 (x2)

                POP BC      ; BC - X.High * 48 + (X.Low >> 2) - (Y.High % 1) * 24 (x1)
                ; расстояние между двумя точками в пикселях
                OR A
                SBC HL, BC
                ; JP P, .PositiveX
                ; ; NEG HL
                ; XOR A
                ; SUB L
                ; LD L, A
                ; SBC A, A
                ; SUB H
                ; LD H, A
.PositiveX      ; расстояние между двумя точками по горизонтали (положительное)
                PUSH HL

                ; -----------------------------------------
                ; Y1 = Y.High * 32 + (Y.Low >> 2)
                LD A, (IX + FObject.Position.Y.High)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD L, A
                LD H, #00
                LD B, H
                RL H
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32
                LD C, (IX + FObject.Position.Y.Low)
                SRL C
                SRL C
                ADD HL, BC  ; HL - Y.High * 32 + (Y.Low >> 2)
                PUSH HL   ; сохранение результата

                ; Y2 = Y.High * 32 + (Y.Low >> 2)
                LD A, (DE)  ; FPath.HexCoord.Y (старший байт)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD L, A
                LD H, #00
                ; LD B, H
                RL H
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32
                LD C, (HEXTILE_SIZE_Y << 4) >> 2    ; середина гексагона
                ADD HL, BC  ; HL - Y.High * 32 + (Y.Low >> 2)                   (x2)

                POP BC      ; BC - Y.High * 32 + (Y.Low >> 2)                   (x1)
                ; расстояние между двумя точками в пикселях
                OR A
                SBC HL, BC
                ; JP P, .PositiveY
                ; ; NEG HL
                ; XOR A
                ; SUB L
                ; LD L, A
                ; SBC A, A
                ; SUB H
                ; LD H, A
.PositiveY      ; расстояние между двумя точками по вертикали (положительное)
                POP DE

                POP BC
                RET

                endif ; ~_HERO_PATH_DISTANCE_

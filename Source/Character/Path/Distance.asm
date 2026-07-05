
                ifndef _CHARACTER_PATH_DISTANCE_
                define _CHARACTER_PATH_DISTANCE_
; -----------------------------------------
; определение расстояния до точки пути
; In:
;   DE - адрес хранения FPath
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   HL - знаковое расстояние по вертикали, в четвертях пикселя
;   DE - знаковое расстояние по горизонтали, в четвертях пикселя
; Corrupt:
;   HL, DE, AF
; Note:
;   код расположен в странице 0
; -----------------------------------------
Distance:       PUSH BC
                ; ToDo в будущем учитывать положение WayPoint'ов
                ;      пока рассчитываем расстояние между центрами гексагонов

                ; -----------------------------------------
                ; X1 = X.High * 192 + X.Low - (1 - (Y.High & 1)) * 96
                ; координаты выражены в четвертях пикселя
                LD A, (IX + FObject.Position.X.High)
                LD C, A
                LD B, #00
                LD H, B
                LD L, C
                ADD HL, HL  ; x2
                ADD HL, BC  ; x3
                ADD HL, HL  ; x6
                ADD HL, HL  ; x12
                ADD HL, HL  ; x24
                ADD HL, HL  ; x48
                ADD HL, HL  ; x96
                ADD HL, HL  ; x192
                LD C, (IX + FObject.Position.X.Low)
                ADD HL, BC  ; HL - X.High * 192 + X.Low
                ; учёт смещение по горизонтали, если чётная строка
                LD A, (IX + FObject.Position.Y.High)
                RRA
                CCF
                SBC A, A
                AND -(((HEXTILE_SIZE_X << 3) >> 1) << 2)                       ; половина ширины гексагона в четвертях пикселя
                LD C, A
                ADD A, A
                SBC A, A
                LD B, A
                ADD HL, BC  ; HL - X.High * 192 + X.Low - (1 - (Y.High & 1)) * 96
                PUSH HL   ; сохранение результата
                
                ; X2 = X.High * 192 + X.Low - (1 - (Y.High & 1)) * 96
                LD A, (DE)  ; FPath.HexCoord.X (старший байт)
                LD C, A
                LD B, #00
                LD H, B
                LD L, C
                ADD HL, HL  ; x2
                ADD HL, BC  ; x3
                ADD HL, HL  ; x6
                ADD HL, HL  ; x12
                ADD HL, HL  ; x24
                ADD HL, HL  ; x48
                ADD HL, HL  ; x96
                ADD HL, HL  ; x192
                LD C, HEXTILE_SIZE_X << 4                                      ; центр гекса в четвертях пикселя
                ADD HL, BC  ; HL - X.High * 192 + X.Low
                ; учёт смещение по горизонтали, если чётная строка
                INC E
                LD A, (DE)  ; FPath.HexCoord.Y (старший байт)
                RRA
                CCF
                SBC A, A
                AND -(((HEXTILE_SIZE_X << 3) >> 1) << 2)                       ; половина ширины гексагона в четвертях пикселя
                LD C, A
                ADD A, A
                SBC A, A
                LD B, A
                ADD HL, BC  ; HL - X.High * 192 + X.Low - (1 - (Y.High & 1)) * 96

                POP BC      ; BC - глобальная координата X1
                ; расстояние между двумя точками в четвертях пикселя
                OR A
                SBC HL, BC
                PUSH HL

                ; -----------------------------------------
                ; Y1 = Y.High * 128 + Y.Low
                LD A, (IX + FObject.Position.Y.High)
                LD L, A
                LD H, #00
                LD B, H
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32
                ADD HL, HL  ; x64
                ADD HL, HL  ; x128
                LD C, (IX + FObject.Position.Y.Low)
                ADD HL, BC  ; HL - Y.High * 128 + Y.Low
                PUSH HL   ; сохранение результата

                ; Y2 = Y.High * 128 + Y.Low
                LD A, (DE)  ; FPath.HexCoord.Y (старший байт)
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32
                ADD HL, HL  ; x64
                ADD HL, HL  ; x128
                LD C, HEXTILE_SIZE_Y << 4                                      ; центр гекса в четвертях пикселя
                ADD HL, BC  ; HL - Y.High * 128 + Y.Low                         (x2)

                POP BC      ; BC - глобальная координата Y1
                ; расстояние между двумя точками в четвертях пикселя
                OR A
                SBC HL, BC
                POP DE

                POP BC
                RET

                endif ; ~_CHARACTER_PATH_DISTANCE_

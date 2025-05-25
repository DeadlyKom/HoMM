
                ifndef _HERO_PATH_DIRECTION_
                define _HERO_PATH_DIRECTION_
; -----------------------------------------
; определение направления
; In:
;   HL - адрес хранения позиции
;   DE - начальная позиция в тайлах (D - y, E - x)
; Out:
;   HL - адрес хранения значения направления
;   DE - прочитаная позиция в тайлах (D - y, E - x)
; Corrupt:
;   HL, DE, C, AF
; Note:
; -----------------------------------------
Directon:       ;
                LD A, E
                SUB (HL)
                
                ; преобразование:
                ; если равен 0, то #00
                ; если больше 0 то #01
                ; если меньше 0 то #FF
                JR Z, $+6
                SBC A, A
                CCF
                ADC A, #00
                ; xxxxxxxx
                LD C, A

                LD E, (HL)
                INC HL

                LD A, D
                SUB (HL)
                ; преобразование:
                ; если равен 0, то #00
                ; если больше 0 то #01
                ; если меньше 0 то #FF
                JR Z, $+6
                SBC A, A
                CCF
                ADC A, #00
                ; yyyyyyyy

                LD D, (HL)

                ADD A, A    ; yyyyyyy0
                ADD A, A    ; yyyyyy00
                XOR C
                AND %11111100
                XOR C       ; yyyyyyxx
                AND %00001111

                ; расчёт адреса хранения направления
                ADD A, LOW .DirectionTable
                LD L, A
                ADC A, HIGH .DirectionTable
                SUB L
                LD H, A

                RET

.DirectionTable ; направление                                                   ; ---- yy xx
                DB DIR_UP                                                       ; 0000 00 00    (не действительная)
                DB DIR_LEFT                                                     ; 0000 00 01
                DB DIR_UP                                                       ; 0000 00 10    (не действительная)
                DB DIR_RIGHT                                                    ; 0000 00 11
                DB DIR_UP                                                       ; 0000 01 00
                DB DIR_UP_LEFT                                                  ; 0000 01 01
                DB DIR_UP                                                       ; 0000 01 10    (не действительная)
                DB DIR_UP_RIGHT                                                 ; 0000 01 11
                DB DIR_UP                                                       ; 0000 10 00    (не действительная)
                DB DIR_UP                                                       ; 0000 10 01    (не действительная)
                DB DIR_UP                                                       ; 0000 10 10    (не действительная)
                DB DIR_UP                                                       ; 0000 10 11    (не действительная)
                DB DIR_DOWN                                                     ; 0000 11 00
                DB DIR_DOWN_LEFT                                                ; 0000 11 01
                DB DIR_UP                                                       ; 0000 11 10    (не действительная)
                DB DIR_DOWN_RIGHT                                               ; 0000 11 11

                endif ; ~_HERO_PATH_DIRECTION_

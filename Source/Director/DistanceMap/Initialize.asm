                
                ifndef _AI_DIRECTOR_DISTANCE_MAP_INITIALIZE_
                define _AI_DIRECTOR_DISTANCE_MAP_INITIALIZE_
; -----------------------------------------
; инициализация карты расстояний
; In:
; Out:
; Corrupt:
; Note:
;   код расположен в общей
; -----------------------------------------
Initialize:     ; инициализация
                LD HL, Adr.Hextile                                              ; #4000/#C000 (DistanceMap/Hextile)
                LD D, HIGH Adr.SurfPassability
                LD BC, Size.Hextile

.Loop           ;
                LD E, (HL)                                                      ; индекс гексагона
                LD A, (DE)                                                      ; чтение FMapSurface.Passability
                AND SURFACE_TYPE_MASK

                ; обычные типы  → #FF
                ; дорога        → #0F
                ; поселение     → #F0
                RES 7, H
                LD (HL), #FF

                SUB SURFACE_TYPE_ROAD
                JR C, .NextHextile

                RRA
                RRA
                OR #67
                LD (.RollHalf), A
                XOR A
.RollHalf       EQU $+1
                DB #ED, #00                                                     ; #ED, #67 / #ED, #6F  - RRD/RLD

.NextHextile    ; следущий гексагон
                SET 7, H
                INC HL

                ; уменьнение счётчика
                DEC BC
                LD A, B
                OR C
                JR NZ, .Loop

                RET

                endif ; ~_AI_DIRECTOR_DISTANCE_MAP_INITIALIZE_

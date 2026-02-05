
                ifndef _HEXAGON_POSITION_BY_MOUSE_CURSOR_
                define _HEXAGON_POSITION_BY_MOUSE_CURSOR_

                module Hexagon
; -----------------------------------------
; позиционирование шестиугольника курсором мыши
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GetPosByMouse:  ; расчёт вертикальное положения мыши относительно центра гексагона (0,0)
                LD A, (Mouse.PositionY)
                ADD A, (-SCR_WORLD_POS_Y +1 - (HEXTILE_BASE_SIZE_Y >> 1)) << 3  ; где:
                                                                                ;  - положение игрового мира на экране (-SCR_WORLD_POS_Y)
                                                                                ;  - смещение по вертикали гексагона 0,0 (+1)
                                                                                ;  - половина гексагона (HEXTILE_BASE_SIZE_Y >> 1)
                ; добавить смещение, если отрицательное значение
                JP P, $+5
                ADD A, (HEXTILE_BASE_SIZE_Y >> 1) << 3
                
                LD B, A
                AND %00011111
                LD D, A         ; D - дельта Y между центрами гексагонов
                LD A, B
                RLCA
                RLCA
                RLCA
                AND %00000111
                LD B, A         ; B - Y (гексагон)

                ; расчёт горизонтальное положения мыши относительно центра гексагона (0,0)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                EX AF, AF'

                LD A, (Mouse.PositionX)
                ; проверка чётности строки, если чётная,
                ; сместить на половину гексагона по горизонтали влево
                BIT 0, B
                EXX
                LD L, A
                LD H, #00
                LD B, #FF
                JR Z, .Half
                LD C, -((HEXTILE_SIZE_X >> 1) << 3)
                ADD HL, BC
.Half           ; учёт смещение положения игрового мира на экране
                LD C, -(SCR_WORLD_POS_X << 3)
                ADD HL, BC

                EX AF, AF'
                LD C, A
                INC B       ; сброс B в ноль
                ADC HL, BC
                LD A, L
                EXX

                LD C, #00
                JP M, .NegativeX ; отрицательное значение

                ; деление на 48
                LD E, #60
                CP E
                JR C, $+4
                INC C
                SUB E
                SLA C
                SRL E
                CP E
                JR C, $+4
                INC C
                SUB E
.NegativeX      LD E, A         ; E - дельта X от центрами гексагона
                                ; C - X (гексагон)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                ADD A, C
                LD C, A

                ; правая часть
                LD A, E
                OR A
                JP M, .Left
                CP (HEXTILE_SIZE_X >> 1) << 3
                JR NC, .Left_
                ; правая часть гексагона
                ; A - положительная дельта X от центра гексагона
                LD E, A
                RET

.Left_          SUB HEXTILE_SIZE_X << 3
                INC C           ; +1 смещение по горизонтали

.Left           ; левая часть гексагона
                ; A - отрицательная дельта X от центра гексагона
                NEG
                LD E, A
                
                RET
                endmodule

                endif ; ~_HEXAGON_POSITION_BY_MOUSE_CURSOR_

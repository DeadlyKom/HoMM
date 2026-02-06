
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
GetPosByMouse:  ; сброс флага, необходимости дополнительной проверки
                LD A, #B7                                                       ; OR A/SCF #B7/#37
                LD (.Flag), A
                
                ; расчёт вертикального положения мыши относительно центра гексагона (0,0)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                EX AF, AF'
                
                ; расчёт вертикальное положения мыши относительно центра гексагона (0,0)
                LD A, (Mouse.PositionY)
                LD L, A
                LD H, #00
                LD B, #FF
                ; учёт смещение положения игрового мира на экране
                LD C, -((SCR_WORLD_POS_Y + 1) << 3)
                ADD HL, BC
                ; ADD A, (-SCR_WORLD_POS_Y +1 - (HEXTILE_BASE_SIZE_Y >> 1)) << 3  ; где:
                ;                                                                 ;  - положение игрового мира на экране (-SCR_WORLD_POS_Y)
                ;                                                                 ;  - смещение по вертикали гексагона 0,0 (+1)
                ;                                                                 ;  - половина гексагона (HEXTILE_BASE_SIZE_Y >> 1)

                EX AF, AF'
                LD C, A
                INC B           ; сброс B в ноль
                ADC HL, BC
                LD A, L

                JP M, .NegativeY

                ; деление на 32
                RLCA
                RLCA
                RLCA
                AND %00000111
                LD B, A
                LD A, L
                AND %00011111
.NegativeY      LD D, A         ; D - дельта Y от центрами гексагона
                                ; B - Y (гексагон)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                ADD A, B
                LD B, A

                ;
                LD A, D
                OR A
                JP M, .Up
                CP (HEXTILE_BASE_SIZE_Y >> 1) << 3
                JR NC, .Up_

                ; правая часть гексагона
                ; A - положительная дельта X от центра гексагона
                JR .X

.Up_            SUB HEXTILE_BASE_SIZE_Y << 3
                CP -((HEXTILE_BASE_SIZE_Y >> 2) << 3) + 1                       ; +1 т.к. отчёт от 8-16
                JP P, .NotDisputed      ; не оспариваемая грань гексагонов

                ; установка флаг необходимости дополнительной проверки
                EX AF, AF'
                LD A, #37                                                       ; OR A/SCF #B7/#37
                LD (.Flag), A
                EX AF, AF'
                JR $+3          ; необходима проверка, пока не понятно требуется или нет смещение!
.NotDisputed    INC B           ; +1 смещение по вертикали
.Up             ; верхняя часть гексагона
                ; A - отрицательная дельта X от центра гексагона
                ; NEG
                LD D, A

.X              ; расчёт горизонтальное положения мыши относительно центра гексагона (0,0)
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

                LD L, #00
                ; правая часть
                LD A, E
                OR A
                JP M, .Left
                CP (HEXTILE_SIZE_X >> 1) << 3
                JR NC, .Left_
                ; правая часть гексагона
                ; A - положительная дельта X от центра гексагона
                JR .Final

.Left_          SUB HEXTILE_SIZE_X << 3
                INC C           ; +1 смещение по горизонтали

.Left           ; левая часть гексагона
                ; A - отрицательная дельта X от центра гексагона
                ; NEG
                LD E, A
                DEC L           ; флаг левая сторона

.Final          ; флаг найденого перекрытия
.Flag           EQU $
                NOP
                RET NC                                                          ; выход, если не требуется дополнительная проверка

                INC L
                JR Z, .LeftSide

                ; правый нижний
                LD A, D
                NEG
                SUB 9
                JP P, $+4
                INC A
                LD D, A

                LD A, E
                CP (HEXTILE_SIZE_X >> 1) << 3
                JR C, $+3
                DEC A
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, D
                ADD A, LOW .TgTable
                LD L, A
                ADC A, HIGH .TgTable
                SUB L
                LD H, A
                
                LD A, (HL)
                CP 8*256/24
                RET NC

                BIT 0, B
                JR Z, $+3
                INC C

                INC B

                RET

.LeftSide       ; левый нижний
                LD A, D
                NEG
                SUB 9
                JP P, $+4
                INC A
                LD D, A

                LD A, E
                NEG
                CP (HEXTILE_SIZE_X >> 1) << 3
                JR C, $+3
                DEC A
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, D
                ADD A, LOW .TgTable
                LD L, A
                ADC A, HIGH .TgTable
                SUB L
                LD H, A
                
                LD A, (HL)
                CP 8*256/24
                RET NC

                BIT 0, B
                JR NZ, $+3
                DEC C
                INC B

                RET

                ; align 256
.TgTable        lua allpass
                for x = 1, 24 do
                    for y = 1, 8 do
                        local value = math.floor(y/x * 256)
                        if value ~= value then
                            value = 0
                        end
                        if value == math.huge then
                            value = 0
                        end
                        if value >= 256 then
                            value = 255
                        end
                        
                        -- print (x, y, value)
                        _pc("DB " .. value)
                    end
                end
                endlua

                endmodule

                endif ; ~_HEXAGON_POSITION_BY_MOUSE_CURSOR_

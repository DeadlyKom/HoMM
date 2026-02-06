
                ifndef _HEXAGON_POSITION_BY_MOUSE_CURSOR_
                define _HEXAGON_POSITION_BY_MOUSE_CURSOR_

                module Hexagon
; -----------------------------------------
; определение позиции гексагона под курсором мыши
; In:
; Out:
;   BC - координаты гексагона под крсором (D - y, E - x)
; Corrupt:
; Note:
; -----------------------------------------
GetPosByMouse:  ; сброс флага, необходимости дополнительной проверки
                LD A, #B7                                                       ; OR A/SCF #B7/#37
                LD (.Flag), A
                
                ; -----------------------------------------
                ; расчёт вертикального положения мыши относительно центра гексагона (0,0)
                ; -----------------------------------------

                ; приведение смещение карты в пиксели
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                EX AF, AF'
                
                ; расчёт положения курсора по вертикали относительно левого-верхнего "игрового мира"
                LD A, (Mouse.PositionY)
                LD L, A
                LD H, #00
                LD B, #FF
                ; учёт смещение положения игрового мира на экране
                LD C, -((SCR_WORLD_POS_Y + 1) << 3)                             ; где:
                                                                                ;  - положение "игрового мира" на экране (-SCR_WORLD_POS_Y)
                                                                                ;  - смещение по вертикали гексагона 0,0 (+1)
                ADD HL, BC

                ; добавить смещение карты
                EX AF, AF'
                LD C, A
                INC B           ; сброс B в ноль
                ADC HL, BC
                LD A, L
                JP M, .NegativeY                                                ; переход, если позиция курсора находится на грани левой/верхней границы

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

                ; определение положение по смещению
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

.X              ; -----------------------------------------
                ; расчёт горизонтальное положения мыши относительно центра гексагона (0,0)
                ; -----------------------------------------

                ; приведение смещение карты в пиксели
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                EX AF, AF'

                ; расчёт положения курсора по горизонтали относительно левого-верхнего "игрового мира"
                LD A, (Mouse.PositionX)
                ; проверка чётности строки, если чётная,
                ; сместить на половину гексагона по горизонтали влево
                BIT 0, B
                EXX
                LD L, A
                LD H, #00
                LD B, #FF
                JR Z, .Half
                LD C, -((HEXTILE_SIZE_X >> 1) << 3)                             ; где:
                                                                                ;  - смещение половины гексагона (HEXTILE_SIZE_X >> 1)
                ADD HL, BC
.Half           ; учёт смещение положения игрового мира на экране
                LD C, -(SCR_WORLD_POS_X << 3)                                   ; где:
                                                                                ;  - положение "игрового мира" на экране (-SCR_WORLD_POS_X)
                ADD HL, BC

                ; добавить смещение карты
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

.Final          ; флаг необходимости дополнительной проверки
.Flag           EQU $
                NOP
                JR NC, .SetPosition                                             ; переход, если не требуется дополнительная проверка

                INC L
                JR Z, .LeftSide

                ; -----------------------------------------
                ; правый нижний
                ; -----------------------------------------

                ; приведение дельты Y к положительному и значению от 0 до 7
                LD A, D
                NEG
                SUB 9
                JP P, $+4
                INC A
                LD D, A

                ; приведение дельты X к значению от 0 до 23
                LD A, E
                CP (HEXTILE_SIZE_X >> 1) << 3
                JR C, $+3
                DEC A

                ; расчёт адреса таблицы
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, D
                LD HL, .TgTable
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A
                
                ; сравнение угла с константным
                LD A, (HL)
                CP 8*256/24
                JR NC, .SetPosition                                             ; переход, если находимся за пределами константного угла
                                                                                ; т.е. принадлежим ранее расчитаным координатам и корректирвки не требуется
                ; проверка чётности строки
                BIT 0, B
                JR Z, $+3
                INC C       ; +1 смещение по горизонтали
                INC B       ; +1 смещение по вертикали
                JR .SetPosition

.LeftSide       ; -----------------------------------------
                ; левый нижний
                ; -----------------------------------------

                ; приведение дельты Y к положительному и значению от 0 до 7
                LD A, D
                NEG
                SUB 9
                JP P, $+4
                INC A
                LD D, A

                ; приведение дельты X к положительному и значению от 0 до 23
                LD A, E
                NEG
                CP (HEXTILE_SIZE_X >> 1) << 3
                JR C, $+3
                DEC A

                ; расчёт адреса таблицы
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, D
                LD HL, .TgTable
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A
                
                ; сравнение угла с константным
                LD A, (HL)
                CP 8*256/24
                JR NC, .SetPosition                                             ; переход, если находимся за пределами константного угла
                                                                                ; т.е. принадлежим ранее расчитаным координатам и корректирвки не требуется
                ; проверка чётности строки
                BIT 0, B
                JR NZ, $+3
                DEC C       ; -1 смещение по горизонтали
                INC B       ; +1 смещение по вертикали

.SetPosition    ; сохранение найденой позиции гексагона под курсором
                LD (GameSession + FGameSession.WorldInfo.Cursor), BC
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

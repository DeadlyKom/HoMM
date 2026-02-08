
                ifndef _WORLD_TILEMAP_UPDATE_MOVEMENT_
                define _WORLD_TILEMAP_UPDATE_MOVEMENT_
; -----------------------------------------
; обновление движения
; In:
; Out:
; Corrupt:
; Note:
;   находится в страницы "мир"
; -----------------------------------------
UpdateMovement: RES_INPUT_TIMER_FLAG SCROLL_MAP_BIT                             ; усброс новка флага разрешения обновления скрола карты

                ; проверить флаг установки положения карты по мини-карте
                CHECK_VIEW_FLAG SET_MAP_POSITION_ON_MINIMAP_BIT
                JR NZ, SetMapPosition                                           ; переход, если требуется установка положения карты по мини-карте

                ; установка задержки опроса скрола
                LD HL, GameSession.PeriodTick + FTick.Scroll
                LD A, (HL)
                OR A
                RET NZ                                                          ; выход, если задержка незакончилась
                LD (HL), DURATION.MAP_SCROLL+1                                  ; обновление задежки скрола
                ; -----------------------------------------
                ; определение вектора перемещения
                ; -----------------------------------------

                ; расчёт адреса хранения вектора
                LD A, (GameState.Input.Value)
                AND MOVEMENT_MASK
                RET Z

                ; расчёт адреса смещений
                LD HL, DirectionTable
                ADD A, A    ; x2
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A

                ; применение данных таблицы для осей
                LD A, (HL)
                OR A
                JR Z, .OnlyVertical
                PUSH HL
                CALL ApplyToX_Axis_
                POP HL
.OnlyVertical   INC HL
                CALL ApplyToY_Axis_

                ; сброс флагов ввода перемещения
                LD A, (GameState.Input.Value)
                AND ~MOVEMENT_MASK
                LD (GameState.Input.Value), A

.Genaration     ; инициализация 22 * 8 стобов гексагона
                LD HL, Adr.RenderBuffer + 80 + 176
                LD DE, #0101
                CALL SafeFill.b176
                JP Draw.HexDLGeneration
SetMapPosition  RES_VIEW_FLAG SET_MAP_POSITION_ON_MINIMAP_BIT                   ; сброс флага установления положения карты по мини-карте
                VIEW_FLAGS
                SET_FLAG UPDATE_TILEMAP_BUF_BIT                                 ; установка флага обновления Tilemap буфера
                SET_FLAG UPDATE_RENDER_BUF_BIT                                  ; установка флага обновления Render буфера
                JR UpdateMovement.Genaration
ApplyToX_Axis_  ; #000 - #2B5
                ; -----------------------------------------
                ; расчёт позиции карты по горизонтали в знакоместах (MapPosition * 6 + MapOffset)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                LD D, A
                ADD A, A    ; x2
                LD C, A
                ADD A, A    ; x4
                ADC A, C    ; x6
                LD C, A
                LD B, #00
                RL B
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)
                ADD A, C
                LD C, A
                JR NC, $+3
                INC B

                ; приведение к 16-битному значению
                LD L, (HL)  ; значение смещения
                LD A, L
                EX AF, AF'  ; сохранение смещения
                LD A, L
                ADD A, A    ; << 1
                SBC A, A
                LD H, A

                ; добавить направление
                OR A
                ADC HL, BC

                ; проверка достижения границ
                RET M       ; выход, если достигли левой границы
                JR Z, .Cal  ; пропуск проверкаи на правую границу, т.к. дточно на левой!
                LD BC, -((MAX_WORLD_HEX_X - 5) * 6 + 6)
                OR A
                ADC HL, BC
                RET Z       ; выход, если достигли правой границы
                SBC HL, BC

.Cal            ; деление на 6
                LD BC, HEXTILE_SIZE_X << 5
                LD E, #00
                OR A
                SBC HL, BC
                ADD HL, BC
                JR C, $+5
                INC E
                SBC HL, BC
                SLA E
                SRL C
                LD A, L
                rept 4
                CP C
                JR C, $+4
                INC E
                SUB C
                SLA E
                SRL C
                endr
                CP C
                JR C, $+4
                INC E
                SUB C

                LD (GameSession.WorldInfo + FWorldInfo.MapOffset.X), A
                LD (World.Shift_X), A                                           ; смещение внутри гексагона
                SET_VIEW_FLAG_A UPDATE_RENDER_BUF_BIT                           ; установка флага обновления Render буфера

                LD A, E
                CP D
                RET Z
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.X), A

                ; направление смещения
                EX AF, AF'  ; восстановление смещения
                OR A
                LD DE, 1                ; шаг смещения
                JP P, UpdateTilemap
                LD DE, -1               ; шаг смещения
                JR UpdateTilemap
ApplyToY_Axis_  ; #000 - #2A1
                ; -----------------------------------------
                ; расчёт позиции карты по вертикали в знакоместах (MapPosition * 4 + MapOffset)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                LD B, A
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, A
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)
                ADD A, C
                ADD A, (HL) ; добавить направление
                CP #FF
                RET Z       ; выход, если достигли верхней границы
                CP ((MAX_WORLD_HEX_Y - 6) << 2) + 2
                RET NC      ; выход, если достигли низжнюю границу

                LD C, A
                AND %00000011
                LD (GameSession.WorldInfo + FWorldInfo.MapOffset.Y), A
                LD (World.Shift_Y), A                                           ; смещение внутри гексагона
                SET_VIEW_FLAG_A UPDATE_RENDER_BUF_BIT                           ; установка флага обновления Render буфера

                LD A, C
                RRA
                RRA
                AND %00111111
                CP B
                RET Z
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.Y), A

                ; шаг смещения
                LD A, (GameSession.MapSize.Width)                               ; размер какрты по горизонтали
                LD E, A
                LD D, #00
                
                ; направление смещения
                LD A, (HL)
                OR A
                JP P, UpdateTilemap
                
                ; смена знака смещения 
                XOR A
                SUB E
                LD E, A
                DEC D
UpdateTilemap   ; -----------------------------------------
                LD HL, (GameSession.WorldInfo + FWorldInfo.Tilemap)
                ADD HL, DE
                LD (GameSession.WorldInfo + FWorldInfo.Tilemap), HL
                SET_VIEW_FLAG UPDATE_TILEMAP_BUF_BIT                            ; установка флага обновления Tilemap буфера
                RET
DirectionTable  ; -----------------------------------------
                lua allpass
                for i = 0, 15 do
                    local x = (((i >> 3) & 1) * -1.0) + (((i >> 2) & 1) * 1.0)
                    local y = (((i >> 1) & 1) * -1.0) + (((i >> 0) & 1) * 1.0)
                    if x == 0  and y == 0 then
                        _pc("DB " .. 0)
                        _pc("DB " .. 0)
                        -- print (i, x, y)
                    else
                        local angle = math.atan(y,x)
                        local cos = math.floor(math.cos(angle) + 0.5)
                        local sin = math.floor(math.sin(angle) + 0.5)
                        _pc("DB " .. cos)
                        _pc("DB " .. sin)
                        -- print (i, math.deg(angle), cos, sin)
                    end
                end
                endlua

                display " - Update movement tilemap:\t\t\t\t\t\t= busy [ ", /D, $-UpdateMovement, " byte(s) ]"

                endif ; ~_WORLD_TILEMAP_UPDATE_MOVEMENT_

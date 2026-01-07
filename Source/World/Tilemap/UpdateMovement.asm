
                ifndef _WORLD_TILEMAP_UPDATE_MOVEMENT_
                define _WORLD_TILEMAP_UPDATE_MOVEMENT_
; -----------------------------------------
; обновление движения
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
UpdateMovement: ; установка задержки опроса скрола
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
                ADD A, A    ; x2
                ADD A, LOW DirectionTable
                LD L, A
                ADC A, HIGH DirectionTable
                SUB L
                LD H, A

                ; применение данных таблицы для осей
                CALL ApplyToX_Axis_
                INC HL
                CALL ApplyToY_Axis_

                ; сброс флагов ввода перемещения
                LD A, (GameState.Input.Value)
                AND ~MOVEMENT_MASK
                LD (GameState.Input.Value), A
                RET
ApplyToX_Axis_  ; 0 - #2b5
                ; -----------------------------------------
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.X)
                ADD A, (HL)
                JP M, .IsNegative
                CP HEXTILE_SIZE_X
                JP NC, .IsPositive

.Set            LD (GameSession.WorldInfo + FWorldInfo.MapOffset.X), A
                LD (World.Shift_X), A                                           ; смещение внутри гексагона
                RET

.IsNegative     LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X) ; tile
                DEC A
                RET M
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.X), A ; tile

                LD DE, -1
                CALL UpdateTilemap

                LD A, HEXTILE_SIZE_X-1
                JR .Set

.IsPositive     LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X) ; tile
                INC A
                CP MAX_WORLD_HEX_X-3
                RET NC
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.X), A ; tile

                LD DE, 1
                CALL UpdateTilemap

                XOR A
                JR .Set
ApplyToY_Axis_  ; 0 - #2a1
                ; -----------------------------------------
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)
                ADD A, (HL)
                JP M, .IsNegative
                CP HEXTILE_BASE_SIZE_Y
                JP NC, .IsPositive

.Set            LD (GameSession.WorldInfo + FWorldInfo.MapOffset.Y), A
                LD (World.Shift_Y), A                                           ; смещение внутри гексагона
                RET

.IsNegative     LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y) ; tile
                DEC A
                RET M
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.Y), A ; tile

                LD DE, -MAX_WORLD_HEX_X
                CALL UpdateTilemap

                LD A, HEXTILE_BASE_SIZE_Y-1
                JR .Set

.IsPositive     LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y) ; tile
                INC A
                CP MAX_WORLD_HEX_Y-5
                RET NC
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.Y), A ; tile

                LD DE, MAX_WORLD_HEX_X
                CALL UpdateTilemap

                XOR A
                JR .Set
UpdateTilemap   ; -----------------------------------------
                PUSH HL
                LD HL, (GameSession.WorldInfo + FWorldInfo.Tilemap)
                ADD HL, DE
                LD (GameSession.WorldInfo + FWorldInfo.Tilemap), HL

                SET_VIEW_FLAG UPDATE_TILEMAP_RENDER_BUF_BIT                     ; установка флага обновления Tilemap и Render буфера
                POP HL
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

                display " - Update movement tilemap:\t\t\t\t", /A, UpdateMovement, "\t= busy [ ", /D, $-UpdateMovement, " byte(s)  ]"

                endif ; ~_WORLD_TILEMAP_UPDATE_MOVEMENT_

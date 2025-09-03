
                ifndef _WORLD_TILEMAP_UPDATE_MOVEMENT_
                define _WORLD_TILEMAP_UPDATE_MOVEMENT_
; -----------------------------------------
; обновление движения
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
UpdateMovement: ; -----------------------------------------
                ; определение вектора перемещения
                ; -----------------------------------------

                ; расчёт адреса хранения вектора
                LD A, (GameState.Input.Value)
                AND MOVEMENT_MASK
                ADD A, A    ; x2
                LD HL, .Table
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A

.ApplyX         ; смещение по горизонтали
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                ADD A, (HL)
                INC HL
                JP M, .ApplyY                                                   ; переход, если результат отрицательный
                CP (64 - SCR_WORLD_SIZE_X) * 2 + 2
                JR NC, .ApplyY                                                  ; переход, если результат больше или равен размеру карыт
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.X), A
                
.ApplyY         ; смещение по вертикали
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                ADD A, (HL)
                JP M, .Apply                                                    ; переход, если результат отрицательный
                CP (64 - SCR_WORLD_SIZE_Y) * 2 + 1
                JR NC, .Apply                                                   ; переход, если результат больше или равен размеру карыт
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.Y), A

.Apply          ; корректировка вывода
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                SRL A
                LD L, A
                ; #37 -> %00110111 (SCF)
                ; #B7 -> %10110111 (OR A)
                LD A, #37 << 1
                RRA
                LD (World.Shift_X), A

                LD H, #00
                LD D, HIGH Adr.MapBiome
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32
                ADD HL, HL  ; x64

                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                SRL A
                LD E, A

                SBC A, A
                AND #01
                LD (World.Shift_Y), A
                ADD HL, DE
                LD (GameSession.WorldInfo + FWorldInfo.Tilemap), HL

                LD A, (GameState.Input.Value)
                AND ~MOVEMENT_MASK
                LD (GameState.Input.Value), A

                RET

.Table          lua allpass
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


                ifndef _WORLD_TILEMAP_UPDATE_MOVEMENT_
                define _WORLD_TILEMAP_UPDATE_MOVEMENT_
; -----------------------------------------
; обновление положения карты
; In:
; Out:
; Corrupt:
; Note:
;   находится на странице "мир"
; -----------------------------------------
UpdateMovement: RES_INPUT_TIMER_FLAG SCROLL_MAP_BIT                             ; сброс флага разрешения обновления скролла карты

                ; проверка установки положения карты по мини-карте
                CHECK_VIEW_FLAG SET_MAP_POSITION_ON_MINIMAP_BIT
                JR NZ, SetMapPosition                                           ; переход, если требуется установка положения карты по мини-карте

                ; проверка периода обновления скролла карты
                LD HL, GameSession.PeriodTick + FTick.Scroll
                LD A, (HL)
                OR A
                RET NZ                                                          ; выход, если период ещё не завершён
                LD (HL), DURATION.MAP_SCROLL+1                                  ; перезапуск периода обновления скролла
                ; -----------------------------------------
                ; определение вектора перемещения
                ; -----------------------------------------

                ; чтение направления перемещения
                LD A, (GameState.Input.Value)
                AND MOVEMENT_MASK
                RET Z

                ; расчёт адреса вектора в таблице направлений
                LD HL, DirectionTable
                ADD A, A    ; x2
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A

                ; сохранение текущих смещений карты внутри гексагона
                ; для последующей проверки фактического перемещения по каждой оси
                LD A, (World.Shift_X)
                LD C, A
                LD A, (World.Shift_Y)
                LD B, A
                PUSH BC

                ; применение вектора перемещения независимо для каждой оси
                LD A, (HL)
                OR A
                JR Z, .OnlyVertical
                PUSH HL
                CALL ApplyToX_Axis_
                POP HL
.OnlyVertical   INC HL
                CALL ApplyToY_Axis_

                ; сброс обработанных битов направления перемещения
                LD A, (GameState.Input.Value)
                AND ~MOVEMENT_MASK
                LD (GameState.Input.Value), A

                POP BC

                ; проверка фактического перемещения карты по каждой оси
                ; обновление требуется при изменении хотя бы одного смещения
                LD A, (World.Shift_X)
                CP C
                JR NZ, .Changed

                LD A, (World.Shift_Y)
                CP B
                RET Z

.Changed        SET_VIEW_FLAG_A UPDATE_RENDER_BUF_BIT                           ; установка флага обновления буфера рендера

.Generation     ; установка признаков обновления для 22 * 8 столбцов гексагонов
                LD HL, Adr.RenderBuffer + 80 + 176
                LD DE, #0101
                CALL SafeFill.b176
                JP Draw.HexDLGeneration
SetMapPosition  RES_VIEW_FLAG SET_MAP_POSITION_ON_MINIMAP_BIT                   ; сброс флага установки положения карты по мини-карте
                VIEW_FLAGS
                SET_FLAG UPDATE_TILEMAP_BUF_BIT                                 ; установка флага обновления буфера тайлов
                SET_FLAG UPDATE_RENDER_BUF_BIT                                  ; установка флага обновления буфера рендера
                JR UpdateMovement.Generation
ApplyToX_Axis_  ; #000 - #2B5
                ; -----------------------------------------
                ; расчёт положения карты по горизонтали в знакоместах (MapPosition * 6 + MapOffset)
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

                ; знаковое расширение шага перемещения до 16 бит
                LD L, (HL)  ; значение смещения
                LD A, L
                EX AF, AF'  ; сохранение смещения
                LD A, L
                ADD A, A    ; << 1
                SBC A, A
                LD H, A

                ; применение шага к положению карты
                OR A
                ADC HL, BC

                ; проверка границ перемещения карты
                RET M                                                           ; выход при достижении левой границы
                JR Z, .Cal                                                      ; нулевое положение заведомо не достигает правой границы
                LD BC, -((MAX_WORLD_HEX_X - 5) * 6 + 6)
                OR A
                ADC HL, BC
                RET Z       ; выход при достижении правой границы
                SBC HL, BC

.Cal            ; разделение положения на номер гексагона и смещение внутри него
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

                LD A, E
                CP D
                RET Z
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.X), A

                ; выбор шага указателя тайловой карты по горизонтали
                EX AF, AF'  ; восстановление смещения
                OR A
                LD DE, 1                ; переход к следующему гексагону
                JP P, UpdateTilemap
                LD DE, -1               ; переход к предыдущему гексагону
                JR UpdateTilemap
ApplyToY_Axis_  ; #000 - #2A1
                ; -----------------------------------------
                ; расчёт положения карты по вертикали в знакоместах (MapPosition * 4 + MapOffset)
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                LD B, A
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, A
                LD A, (GameSession.WorldInfo + FWorldInfo.MapOffset.Y)
                ADD A, C
                ADD A, (HL) ; добавить направление
                CP #FF
                RET Z                                                           ; выход при достижении верхней границы
                CP ((MAX_WORLD_HEX_Y - 6) << 2) + 2
                RET NC                                                          ; выход при достижении нижней границы

                LD C, A
                AND %00000011
                LD (GameSession.WorldInfo + FWorldInfo.MapOffset.Y), A
                LD (World.Shift_Y), A                                           ; смещение внутри гексагона

                LD A, C
                RRA
                RRA
                AND %00111111
                CP B
                RET Z
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.Y), A

                ; шаг указателя тайловой карты по вертикали равен ширине карты
                LD A, (GameSession.MapSize.Width)                               ; размер карты по горизонтали
                LD E, A
                LD D, #00
                
                ; выбор направления перехода по тайловой карте
                LD A, (HL)
                OR A
                JP P, UpdateTilemap
                
                ; смена знака шага для перехода к предыдущей строке
                XOR A
                SUB E
                LD E, A
                DEC D
UpdateTilemap   ; обновление адреса левого верхнего гексагона видимой области
                LD HL, (GameSession.WorldInfo + FWorldInfo.Tilemap)
                ADD HL, DE
                LD (GameSession.WorldInfo + FWorldInfo.Tilemap), HL
                SET_VIEW_FLAG UPDATE_TILEMAP_BUF_BIT                            ; установка флага обновления буфера тайлов
                RET
DirectionTable  ; таблица единичных векторов для сочетаний битов направления
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

                ifndef _MODULE_WORLD_TILEMAP_CENTER_SMOOTH_
                define _MODULE_WORLD_TILEMAP_CENTER_SMOOTH_

                module Center

Const:          ; константные значения
.MaxTicks       EQU 255                                                          ; максимальная длительность в прерываниях, диапазон 1..255

                ; предельные координаты камеры в знакоместах
.MaxX           EQU (MAX_WORLD_HEX_X - 4) * HEXTILE_SIZE_X - 1
.MaxY           EQU (MAX_WORLD_HEX_Y - 6) * HEXTILE_BASE_SIZE_Y + 1

                ; выбор максимального расстояния по двум осям
                if Const.MaxX >= Const.MaxY
.MaxDistance    EQU Const.MaxX
                else
.MaxDistance    EQU Const.MaxY
                endif
; -----------------------------------------
; плавное центрирование на активном персонаже
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; Note:
;   код расположен в странице модуля мира
;   вызов выполняется после первичной инициализации мира
;   прерывания и переключение экранов должны быть разрешены
;   пауза и переход UI не должны быть запрошены
;   повторный вход до завершения функции не допускается
; -----------------------------------------
Smooth:         ; проверка наличия персонажей
                LD A, (GameSession.WorldInfo + FWorldInfo.HeroNum)
                OR A
                RET Z                                                           ; выход, если персонажи отсутствуют

                ; блокировка на время перемещения
                SET_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; блокировка новых запросов из обработчика ввода
                SET_UI_FLAG UI_UPDATE_DISABLE_BIT                               ; блокировка обновления UI

                ; сброс накопленного направления ручного скролла
                CALL World.Tilemap.ResetMapScroll

                ; завершение ранее подготовленного кадра
                CALL .WaitFrame

                ; получение общей цели центрирования
                CALL GetTarget
                CALL .ToCells

                ; сохранение цели в операндах интерполяции
                LD (.TargetX), HL
                LD (.TargetY), DE

                ; проверка режима мгновенного центрирования
                CHECK_CONFIG_OPTIONS_FLAG O_CENTER_INSTANT_BIT
                JP NZ, .Finish                                                  ; переход, если включено мгновенное центрирование

                ; получение текущей позиции камеры в знакоместах
                LD DE, (GameSession.WorldInfo + FWorldInfo.MapPosition)
                LD BC, (GameSession.WorldInfo + FWorldInfo.MapOffset)
                CALL .ToCells

                ; сохранение начальной позиции в операндах интерполяции
                LD (.StartX), HL
                LD (.StartY), DE
                PUSH DE

                ; расчёт горизонтального расстояния до цели
                LD DE, (.TargetX)
                OR A
                SBC HL, DE

                ; проверка знака горизонтального расстояния
                CALL C, .NegHL                                                  ; вызов, если разность координат отрицательна

                ; сохранение горизонтального расстояния
                POP DE
                EX DE, HL
                PUSH DE

                ; расчёт вертикального расстояния до цели
                LD DE, (.TargetY)
                OR A
                SBC HL, DE

                ; проверка знака вертикального расстояния
                CALL C, .NegHL                                                  ; вызов, если разность координат отрицательна

                ; выбор наибольшего расстояния по двум осям
                POP DE
                OR A
                SBC HL, DE
                JR C, .Distance                                                 ; переход, если горизонтальное расстояние больше вертикального
                ADD HL, DE
                EX DE, HL

.Distance       ; проверка совпадения текущей позиции с целью
                LD A, D
                OR E
                JP Z, .Finish                                                   ; переход, если камера уже находится в целевой позиции

                ; расчёт произведения расстояния на максимальную длительность
                LD A, Const.MaxTicks
                CALL Math.Mul16x8_24

                ; подготовка деления 24-битного произведения
                LD D, A
                LD E, #00
                LD BC, Const.MaxDistance

.CountTicks     ; расчёт длительности с округлением вверх
                INC E
                OR A
                SBC HL, BC
                LD A, D
                SBC A, #00
                LD D, A

                ; проверка достижения неполного последнего интервала
                JR C, .TimeReady                                                ; переход, если остаток был меньше максимального расстояния

                ; проверка наличия оставшейся части произведения
                OR H
                OR L
                JR NZ, .CountTicks                                              ; переход, если произведение ещё не исчерпано

.TimeReady      ; сохранение рассчитанной длительности
                LD A, E
                LD (.Duration), A

                ; сохранение начального значения счётчика прерываний
                LD HL, (TickCounterRef)
                LD (.StartTick), HL

.WaitTick       ; ожидание продвижения счётчика времени
                HALT

.Frame          ; расчёт времени, прошедшего с начала перемещения
                LD HL, (TickCounterRef)
.StartTick      EQU $+1
                LD DE, #0000
                OR A
                SBC HL, DE

                ; проверка превышения однобайтового диапазона времени
                LD A, H
                OR A
                JP NZ, .Finish                                                  ; переход, если прошло не менее 256 прерываний

                ; проверка продвижения времени после запуска
                LD A, L
                OR A
                JR Z, .WaitTick                                                 ; переход, если после запуска ещё не было прерываний

                ; проверка завершения рассчитанного времени перемещения
.Duration       EQU $+1
                LD E, #00
                CP E
                JP NC, .Finish                                                  ; переход, если длительность перемещения истекла

                ; расчёт коэффициента сглаживания по прошедшему времени
                CALL Math.NormalizeScal
                CALL Math.EaseOut   ; f(t) = 1 − (1 − t)²
                CALL Math.EaseOut   ; f(t) = 1 − (1 − t)⁴
                PUSH AF

                ; расчёт горизонтальной координаты камеры
.StartX         EQU $+1
                LD HL, #0000
.TargetX        EQU $+1
                LD DE, #0000
                CALL Math.Lerp16

                ; сохранение горизонтальной координаты и восстановление коэффициента
                POP AF
                PUSH HL

                ; расчёт вертикальной координаты камеры
.StartY         EQU $+1
                LD HL, #0000
.TargetY        EQU $+1
                LD DE, #0000
                CALL Math.Lerp16

                ; подготовка рассчитанных координат камеры
                EX DE, HL
                POP HL

                ; установка позиции и отображение завершённого кадра
                CALL .SetCells
                CALL .DrawFrame
                JP .Frame

.Finish         ; установка точной конечной позиции
                LD HL, (.TargetX)
                LD DE, (.TargetY)
                CALL .SetCells

                ; отображение конечной позиции и завершение переключения экранов
                CALL .DrawFrame

                ; снятие блокировок
                RES_INPUT_FLAG INPUT_SCAN_DISABLE_BIT                           ; сброс блокировки новых запросов из обработчика ввода
                RES_UI_FLAG UI_UPDATE_DISABLE_BIT                               ; сброс блокировки обновления UI
                RET
; -----------------------------------------
; преобразование позиции карты в знакоместа
; In:
;   DE - положение карты в гексагонах (D - y, E - x)
;   BC - смещения внутри гексагона (B - y, C - x)
; Out:
;   HL - координата X в знакоместах
;   DE - координата Y в знакоместах
; Corrupt:
;   BC, AF
; -----------------------------------------
.ToCells        ; сохранение вертикального смещения
                LD A, B
                LD B, #00
                PUSH DE

                ; расчёт горизонтальной координаты, X * 6 + смещение
                LD L, E
                LD H, B
                ADD HL, HL
                LD E, L
                LD D, H
                ADD HL, HL
                ADD HL, DE
                ADD HL, BC

                ; сохранение горизонтальной координаты
                POP DE
                PUSH HL

                ; расчёт вертикальной координаты, Y * 4 + смещение
                LD L, D
                LD H, #00
                ADD HL, HL
                ADD HL, HL
                LD E, A
                LD D, #00
                ADD HL, DE

                ; подготовка координат для возврата
                EX DE, HL
                POP HL
                RET
; -----------------------------------------
; установка позиции камеры из координат в знакоместах
; In:
;   HL - координата X в знакоместах
;   DE - координата Y в знакоместах
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; -----------------------------------------
.SetCells       ; сохранение вертикальной координаты
                PUSH DE

                ; расчёт горизонтальной позиции гексагона и смещения
                LD E, HEXTILE_SIZE_X
                CALL Math.Div16x8_16
                LD C, H
                LD D, L

                ; расчёт вертикальной позиции гексагона и смещения
                POP HL
                LD E, HEXTILE_BASE_SIZE_Y
                CALL Math.Div16x8_16
                LD B, H

                ; подготовка позиции для общей функции установки камеры
                LD E, D
                LD D, L
                JP SetPosition
; -----------------------------------------
; изменение знака 16-битного значения
; In:
;   HL - исходное значение
; Out:
;   HL - значение с противоположным знаком
; Corrupt:
;   AF
; -----------------------------------------
.NegHL          ; расчёт значения с противоположным знаком
                XOR A
                SUB L
                LD L, A
                SBC A, A
                SUB H
                LD H, A
                RET
; -----------------------------------------
; отображение кадра после изменения позиции камеры
; -----------------------------------------
.DrawFrame      ; подготовка обновления карты и маркера миникарты
                LD A, (Kernel.Modules.World.Page)
                CALL_IN_PAGE_A World.Tilemap.SetMapPosition

                ; обновление буферов для установленной позиции камеры
                CALL_IN_PAGE Page.Page1, World.SharedCode.Tilemap.Update.RenderBuffer
                CALL_IN_PAGE Page.Page1, World.SharedCode.Tilemap.Update.TileBuffer

                ; обновление анимации тумана
                CALL_IN_PAGE Page.Page1, Buffer.Fog.Make
                CALL_IN_PAGE Page.Page1, Buffer.Fog.Tick

                ; отображение карты и объектов существующим конвейером
                CALL_IN_PAGE Page.Page1, World.SharedCode.Render.PipelineHexagons

                ; завершение показа и копирования подготовленного кадра
                JP .WaitFrame
; -----------------------------------------
; ожидание полного завершения кадра
; -----------------------------------------
.WaitFrame      ; проверка необходимости копирования уже показанного кадра
                CHECK_RENDER_FLAG SWAPPED_PENDING_BIT
                JR NZ, .CopyFrame                                               ; переход, если основной экран уже показан

                ; проверка завершения переключения экранов
                CHECK_RENDER_FLAG FRAME_READY_BIT
                RET Z                                                           ; выход, если обработка кадра полностью завершена

                ; ожидание следующего этапа переключения экранов
                HALT
                JR .WaitFrame

.CopyFrame      ; копирование показанного кадра в теневой экран
                CALL_IN_PAGE Page.SharedScreen, World.SharedCode.Render.PipelineHexagons.MemcpyScreen
                JR .WaitFrame

                endmodule

                endif ; ~_MODULE_WORLD_TILEMAP_CENTER_SMOOTH_
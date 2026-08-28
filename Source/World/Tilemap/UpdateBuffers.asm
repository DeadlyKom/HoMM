
                ifndef _WORLD_UPDATE_BUFFERS_
                define _WORLD_UPDATE_BUFFERS_
; -----------------------------------------
; обновление Tilemap- и Render-буферов
; In:
; Out:
; Corrupt:
; Note:
;   * Tilemap-буфер копируется из тайловой карты на странице 1
;   * Render-буфер формируется для каждого тайла, где:
;
;          7    6    5    4    3    2    1    0
;       +----+----+----+----+----+----+----+----+
;       | HU | FG | .. | .. | A3 | A2 | A1 | A0 |
;       +----+----+----+----+----+----+----+----+
;   
;       HU      [7]         - флаг, принудительного обновления гексагона (частично или полностью)
;       FG      [6]         - флаг, тумана (0 - гексагон закрашен туманом целиком)
;       ⚠️ два флага HU и FG позволяют управлять процесом смены видимого гексагона на невидимый ⚠️
;       A3-A0   [3..0]      - номер анимации гексагона (локальный)
;
;     - выставляется флаг HU (принудительного обновления гексагона)
;     - копируется флаг FG (тумана, 0 — гексагон закрашен туманом целиком)
;       из буфера метаданных карты
;     - номер анимации гексагона устанавливается в ноль,
;       в последующих шагах он будет модифицирован
;
;       * Render-буфер для каждого столбца гексагона выставляется флаг CU
;           необходимости обновить столбец гексагона (0 - обновление столбца не требуется)
; -----------------------------------------
Update: 
.TileBuffer     RES_VIEW_FLAG UPDATE_TILEMAP_BUF_BIT                            ; сброс флага обновления Tiled буфера
                VIEW_FLAGS
                RES_FLAG UPDATE_TILEMAP_BUF_BIT                                 ; сброс флага обновления Tiled буфера
                SET_FLAG FORCED_FRAME_UPDATE_BIT                                ; установка флага принудительного обновления кадра
                CALL World.Base.Render.Reset

                JP Buffer.Memcpy.Tilemap
.RenderBuffer   CALL Convert.MapPosToSprFormat                                  ; преобразовать положение на карте в формату спрайта (достаточно один раз после пермещения карты)
                VIEW_FLAGS
                RES_FLAG UPDATE_RENDER_BUF_BIT                                  ; сброс флага обновления Render буфера
                SET_FLAG FORCED_FRAME_UPDATE_BIT                                ; установка флага принудительного обновления кадра
                CALL World.Base.Render.Reset
                JP Buffer.Render
; -----------------------------------------
; подготовка временной карты освещения перед обходом SortBuffer
; In:
; Out:
; Corrupt:
;   AF, BC, DE, HL
; Note:
;   Adr.SharedBuffer используется только до начала отрисовки объектов
; -----------------------------------------
.LightmapBegin  CALL .LightPaperTick                                            ; обновить базовый PAPER по аппаратному счётчику 1/50

                ; заполнение 132 байт временной карты тёмным уровнем 3
                LD HL, Adr.SharedBuffer
                LD DE, Adr.SharedBuffer + 1
                LD BC, 6 * SCR_WORLD_SIZE_Y - 1
                LD (HL), #FF
                LDIR
                RET
; -----------------------------------------
; применение временной карты освещения после обхода SortBuffer
; In:
; Out:
; Corrupt:
;   AF, BC, DE, HL
; Note:
;   неизменившаяся карта не вызывает перерисовку гексагонов
; -----------------------------------------
.LightmapFinish
                LD HL, Adr.SharedBuffer
                LD DE, Adr.TilemapBuffer + 80
                LD B, 6 * SCR_WORLD_SIZE_Y

.LightmapCompareLoop
                ; проверка изменения очередного упакованного байта освещения
                LD A, (DE)
                CP (HL)
                JR NZ, .LightmapChanged                                        ; применить карту, если найдено отличие
                INC HL
                INC DE
                DJNZ .LightmapCompareLoop                                      ; продолжить, если остались байты карты освещения
                RET

.LightmapChanged
                ; копирование изменившейся карты в постоянную область TilemapBuffer
                LD HL, Adr.SharedBuffer
                LD DE, Adr.TilemapBuffer + 80
                LD BC, 6 * SCR_WORLD_SIZE_Y
                LDIR
                JP .InvalidateLight                                             ; перерисовать весь свет после изменения карты

.InvalidateLight
                ; установка признака обновления для всех гексагонов Render-буфера
                LD HL, Adr.RenderBuffer
                LD B, TILEMAP_DATA_SIZE
.LightmapHexLoop
                SET RENDER_FLAG_HEX_UPDATE_BIT, (HL)
                INC L
                DJNZ .LightmapHexLoop                                           ; продолжить, если остался гексагон Render-буфера

                ; установка признаков обновления для всех 22 * 8 столбцов гексагонов
                LD HL, Adr.RenderBuffer + 80 + 176
                LD DE, #0101
                CALL SafeFill.b176
                RET

.LightPaperTick
                ; проверка режима остановки времени
                CHECK_TICK_CONTROL_FLAG GAME_SUSPEND_BIT
                JR Z, .LightPaperResume                                         ; перейти к таймеру, если остановка времени выключена

                ; проверка сохранения аппаратного тика начала остановки времени
                LD A, (.LightPaperSuspendActive)
                OR A
                RET NZ                                                          ; выйти, если начало текущей остановки времени уже сохранено

                ; сохранение аппаратного тика начала остановки времени
                LD HL, (TickCounterRef)
                LD (.LightPaperSuspendTick), HL
                INC A                                                           ; установить признак активной остановки времени
                LD (.LightPaperSuspendActive), A
                RET

.LightPaperResume
                ; проверка необходимости исключить завершившуюся остановку времени из интервала PAPER
                LD A, (.LightPaperSuspendActive)
                OR A
                JR Z, .LightPaperTickStart                                      ; перейти к таймеру, если остановка времени не прерывала интервал

                ; расчёт продолжительности завершившейся остановки времени в аппаратных тиках
                LD HL, (TickCounterRef)
                LD DE, (.LightPaperSuspendTick)
                OR A                                                            ; сброс Carry перед 16-битным вычитанием
                SBC HL, DE

                ; перенос начала интервала PAPER на продолжительность остановки времени
                LD DE, (.LightPaperLastTick)
                ADD HL, DE
                LD (.LightPaperLastTick), HL
                XOR A                                                           ; сброс признака завершившейся остановки времени
                LD (.LightPaperSuspendActive), A

.LightPaperTickStart
                ; проверка наличия начального значения аппаратного счётчика
                LD A, (.LightPaperTickValid)
                OR A
                JR NZ, .LightPaperTickCheck                                    ; проверить интервал, если начальный тик уже сохранён

                ; сохранение начального аппаратного тика для первого интервала
                LD HL, (TickCounterRef)
                LD (.LightPaperLastTick), HL
                LD A, #01
                LD (.LightPaperTickValid), A
                RET

.LightPaperTickCheck
                ; расчёт количества аппаратных тиков от последней смены PAPER
                LD HL, (TickCounterRef)
                LD DE, (.LightPaperLastTick)
                OR A                                                            ; сброс Carry перед 16-битным вычитанием
                SBC HL, DE

                ; проверка достижения интерва в 10 секунд по счётчику 1/50
                LD DE, 50 * 10
                OR A                                                            ; сброс Carry перед 16-битным сравнением
                SBC HL, DE
                RET C                                                           ; выйти, если с последней смены прошло меньше 500 тиков

.LightPaperTickElapsed
                ; обновление начала следующего интерва текущим аппаратным тиком
                LD HL, (TickCounterRef)
                LD (.LightPaperLastTick), HL

                ; расчёт следующей фазы по текущему направлению
                LD A, (.LightPaperPhase)
                LD B, A
                LD A, (.LightPaperDirection)
                ADD A, B

                ; проверка выхода выше фазы #03 при движении вверх
                CP #04
                JR Z, .LightPaperTurnDown                                      ; сменить направление и выбрать фазу #02 после #03

                ; проверка выхода ниже фазы #00 при движении вниз
                CP #FF
                JR Z, .LightPaperTurnUp                                        ; сменить направление и выбрать фазу #01 после #00
                JR .LightPaperPhaseReady

.LightPaperTurnDown
                ; установка шага -1 и следующей фазы после верхней границы
                LD A, #FF
                LD (.LightPaperDirection), A
                LD A, #02
                JR .LightPaperPhaseReady

.LightPaperTurnUp
                ; установка шага +1 и следующей фазы после нижней границы
                LD A, #01
                LD (.LightPaperDirection), A

.LightPaperPhaseReady
                ; обновление фазы и трёх операндов расчёта PAPER в рендере
                LD (.LightPaperPhase), A
                CALL Kernel.Hex.SetLightPaperBase
                JP .InvalidateLight                                             ; перерисовать все гексагоны после смены PAPER

.LightPaperLastTick   DW #0000
.LightPaperPhase      DB #00
.LightPaperDirection  DB #01
.LightPaperTickValid  DB #00
.LightPaperSuspendTick  DW #0000
.LightPaperSuspendActive DB #00

                endif ; ~_WORLD_UPDATE_BUFFERS_


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
; обновление карты освещения по экранному знакоместу выбранного героя
; In:
; Out:
; Corrupt:
;   AF, BC, DE, HL, IX, IY, AF'
; Note:
;   необходимо включить страницу 0
;   карта освещения перестраивается только при смене экранного знакоместа героя
; -----------------------------------------
.LightmapHero   CALL .LightPaperTick                                            ; обновить базовый PAPER по аппаратному счётчику 1/50

                ; получение объекта выбранного героя
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CALL Character.Utilities.GetAdr

                ; расчёт точного положения основания героя относительно экрана в формате 12.4
                CALL Utilities.TransformToScr

                ; расчёт горизонтального знакоместа делением экранной координаты 12.4 на 8 пикселей
                LD A, E
                ADD A, A                                                        ; перенос старшего дробного бита в Carry
                LD A, D
                RLA

                ; проверка отрицательного экранного знакоместа по горизонтали
                JR C, .LightmapCenterXNegative                                 ; перейти к левой границе, если экранная координата отрицательная

                ; проверка правой границы области влияния источника света
                CP SCR_WORLD_SIZE_X + 10
                JR NC, .LightmapCenterOutside                                  ; выбрать тёмную карту, если источник правее области влияния
                JR .LightmapCenterXReady

.LightmapCenterXNegative
                ; проверка левой границы области влияния источника света
                CP -10
                JR C, .LightmapCenterOutside                                   ; выбрать тёмную карту, если источник левее области влияния

.LightmapCenterXReady
                LD C, A                                                         ; экранное знакоместо по горизонтали

                ; расчёт вертикального знакоместа делением экранной координаты 12.4 на 8 пикселей
                LD A, L
                ADD A, A                                                        ; перенос старшего дробного бита в Carry
                LD A, H
                RLA

                ; проверка отрицательного экранного знакоместа по вертикали
                JR C, .LightmapCenterYNegative                                 ; перейти к верхней границе, если экранная координата отрицательная

                ; проверка нижней границы области влияния источника света
                CP SCR_WORLD_SIZE_Y + 8
                JR NC, .LightmapCenterOutside                                  ; выбрать тёмную карту, если источник ниже области влияния
                JR .LightmapCenterYReady

.LightmapCenterYNegative
                ; проверка верхней границы области влияния источника света
                CP -8
                JR C, .LightmapCenterOutside                                   ; выбрать тёмную карту, если источник выше области влияния

.LightmapCenterYReady
                LD B, A                                                         ; экранное знакоместо по вертикали
                JR .LightmapCenterCheck

.LightmapCenterOutside
                ; выбор заведомо далёкого центра для полностью тёмной карты освещения
                LD BC, #8080

.LightmapCenterCheck
                ; проверка наличия ранее рассчитанного центра освещения
                LD A, (.LightmapCenterValid)
                OR A
                JR Z, .LightmapCenterChanged                                   ; перестроить карту, если центр ещё не был рассчитан

                ; проверка изменения горизонтального знакоместа источника света
                LD A, (.LightmapCenterX)
                CP C
                JR NZ, .LightmapCenterChanged                                  ; перестроить карту, если герой сменил знакоместо по горизонтали

                ; проверка изменения вертикального знакоместа источника света
                LD A, (.LightmapCenterY)
                CP B
                RET Z                                                           ; выйти без перестроения, если знакоместо героя не изменилось

.LightmapCenterChanged
                ; сохранение нового экранного знакоместа источника света
                LD A, C
                LD (.LightmapCenterX), A
                LD A, B
                LD (.LightmapCenterY), A
                LD A, #01
                LD (.LightmapCenterValid), A

                CALL .LightmapTest                                               ; построение карты освещения вокруг нового центра
                JP .InvalidateLight                                              ; перерисовать весь свет после перестроения карты

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

.LightmapCenterX       DB #00
.LightmapCenterY       DB #00
.LightmapCenterValid   DB #00
; -----------------------------------------
; создание временной гексагональной карты освещения
; In:
; Out:
; Corrupt:
;   AF, BC, DE, HL, AF'
; Note:
;   центр задаётся экранным знакоместом выбранного героя
; -----------------------------------------
.LightmapTest   PUSH IX
                LD IX, Adr.TilemapBuffer + 80

                ; инициализация упакованного байта четырёх уровней освещения
                XOR A
                EX AF, AF'

                ; расчёт начальной вертикальной координаты относительно центра карты
                LD A, (.LightmapCenterY)
                NEG
                LD D, A
                LD B, SCR_WORLD_SIZE_Y

.LightmapRow    ; расчёт начальной горизонтальной координаты относительно центра карты
                LD A, (.LightmapCenterX)
                NEG
                LD E, A
                LD C, 6 * 4

.LightmapCell   PUSH BC                                                         ; сохранение счётчиков строк и знакомест
                PUSH DE                                                         ; сохранение координат знакоместа

                ; проверка знака горизонтальной координаты для расчёта модуля
                LD A, E
                OR A
                JP P, .LightmapAbsX                                             ; сохранить координату, если она неотрицательная
                NEG
.LightmapAbsX   LD E, A

                ; проверка выхода за горизонтальный радиус внешнего гексагона
                CP 11
                JR NC, .LightLevelDark                                          ; выбрать уровень 3, если горизонтальное расстояние не меньше 11 знакомест

                ; проверка знака вертикальной координаты для расчёта модуля
                LD A, D
                OR A
                JP P, .LightmapAbsY                                             ; сохранить координату, если она неотрицательная
                NEG
.LightmapAbsY   LD D, A

                ; проверка выхода за вертикальный радиус внешнего гексагона
                CP 9
                JR NC, .LightLevelDark                                          ; выбрать уровень 3, если вертикальное расстояние не меньше 9 знакомест

                ; расчёт вертикальной границы основания гексагона: 5 * |x|
                LD A, E
                ADD A, A
                ADD A, A
                ADD A, E
                LD L, A

                ; расчёт наклонной границы основания гексагона: 2 * |x| + 6 * |y|
                LD A, D
                ADD A, A
                LD H, A
                ADD A, A
                ADD A, H
                LD H, A
                LD A, E
                ADD A, A
                ADD A, H

                ; проверка выбора дальнейшей из вертикальной и наклонной границ
                CP L
                JR NC, .LightmapDistanceReady                                  ; сохранить наклонную границу, если она не меньше вертикальной
                LD A, L
.LightmapDistanceReady
                LD E, A

                ; проверка попадания во внутреннюю треть радиуса гексагона
                CP 18+6-8
                LD A, #00                                                       ; уровень 0 сохраняет исходный атрибут в центре
                JR C, .LightLevelReady                                          ; уровень 0, если гексагональное расстояние меньше 18

                ; проверка попадания во вторую треть радиуса гексагона
                LD A, E
                CP 35+13-8
                LD A, #01
                JR C, .LightLevelReady                                          ; уровень 1, если гексагональное расстояние меньше 35

                ; проверка попадания во внешнюю треть радиуса гексагона
                LD A, E
                CP 53+3
                LD A, #02
                JR C, .LightLevelReady                                          ; уровень 2, если гексагональное расстояние меньше 53

.LightLevelDark
                LD A, #03                                                       ; уровень 3 за пределами гексагона освещения

.LightLevelReady
                POP DE                                                          ; восстановление координат знакоместа
                POP BC                                                          ; восстановление счётчиков строк и знакомест

                ; упаковка очередного двухбитного уровня в старшие биты байта
                RRCA
                RRCA
                LD L, A
                EX AF, AF'
                SRL A
                SRL A
                OR L
                EX AF, AF'

                ; расчёт координаты следующего знакоместа
                INC E
                DEC C

                ; проверка заполнения очередной группы из четырёх знакомест
                LD A, C
                AND #03
                JR NZ, .LightmapCell                                            ; продолжить упаковку, если в группе осталось знакоместо

                EX AF, AF'                                                      ; восстановление готового упакованного байта
                LD (IX + 0), A
                INC IX

                ; проверка окончания текущей строки карты освещения
                LD A, C
                OR A
                JR NZ, .LightmapCell                                            ; продолжить строку, если остались знакоместа или выравнивание

                ; расчёт координаты следующей строки
                INC D
                DJNZ .LightmapRow                                               ; продолжить построение, если осталась строка карты

                POP IX
                RET

                endif ; ~_WORLD_UPDATE_BUFFERS_

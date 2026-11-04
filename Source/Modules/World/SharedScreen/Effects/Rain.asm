                ifndef _WORLD_SCREEN_EFFECTS_RAIN_
                define _WORLD_SCREEN_EFFECTS_RAIN_

                module Rain
; -----------------------------------------
; стирание прежнего дождя перед переносом мира
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   включена страница 7, при скролле прежняя фаза не стирается
; -----------------------------------------
Erase:                                                                          ; проверка изменения позиции карты и смещения внутри гексагона
                LD HL, Camera
                LD DE, GameSession.WorldInfo + FWorldInfo.MapPosition
                LD B, 4
.CameraLoop     LD A, (DE)
                CP (HL)
                JR NZ, .Moved                                                   ; переход, если положение карты изменилось

                INC HL
                INC DE
                DJNZ .CameraLoop

                ; стирание только действительно нарисованных фаз
                LD IX, Drops
                LD B, RAIN_DROP_COUNT
.Loop           PUSH BC
                LD A, (IX + FRainDrop.Shown)
                OR A
                CALL NZ, Shape                                                  ; вызов, если прежняя фаза была нарисована
                LD (IX + FRainDrop.Shown), 0
                LD DE, FRainDrop
                ADD IX, DE
                POP BC
                DJNZ .Loop
                RET

.Moved                                                                          ; сброс признаков прежнего рисунка без изменения экрана
                LD IX, Drops
                LD DE, FRainDrop
                LD B, RAIN_DROP_COUNT
.Forget         LD (IX + FRainDrop.Shown), 0
                ADD IX, DE
                DJNZ .Forget
                RET

; -----------------------------------------
; обновление и отображение дождя после переноса мира
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', BC', AF', IX
; Note:
;   включена страница 7, атрибуты и флаги обновления не изменяются
; -----------------------------------------
Tick:                                                                           ; сохранение положения карты для следующего стирания
                LD HL, GameSession.WorldInfo + FWorldInfo.MapPosition
                LD DE, Camera
                LD BC, 4
                LDIR

                ; плавное обновление ветра после стирания рисунка с прежним наклоном
                CALL Weather

                ; обновление фаз всех капель
                LD IX, Drops
                LD B, RAIN_DROP_COUNT
.Loop           PUSH BC
                ; проверка фазы, дробная скорость применяется только к падению
                LD A, (IX + FRainDrop.Phase)
                CP RAIN_FALL_PHASE
                JR NC, .Advance                                                 ; переход, если обрабатывается всплеск или новое появление

                ; расчёт продвижения фазы с дробной скоростью падения
                LD A, (Speed)
                ADD A, (IX + FRainDrop.FallFrac)
                LD (IX + FRainDrop.FallFrac), A
                JR NC, .Check                                                   ; переход, если накопленной скорости ещё недостаточно для следующей фазы

.Advance        INC (IX + FRainDrop.Phase)
                LD A, (IX + FRainDrop.Phase)
                CP RAIN_END_PHASE
                JR C, .Check                                                    ; переход, если цикл капли ещё не завершён

                ; выбор независимой точки появления по всей площади игрового окна
.RandomX        CALL Random
                DEC A
                CP RAIN_RANGE_X
                JR NC, .RandomX                                                 ; переход, если координата выходит за допустимую ширину

                ADD A, RAIN_MIN_X
                LD (IX + FRainDrop.X), A
.RandomY        CALL Random
                DEC A
                CP RAIN_RANGE_Y
                JR NC, .RandomY                                                 ; переход, если координата выходит за допустимую высоту

                ADD A, RAIN_MIN_Y
                LD (IX + FRainDrop.Y), A

                ; запуск падения из выбранной точки с независимым дробным остатком
                LD (IX + FRainDrop.Phase), 0
                CALL Random
                LD (IX + FRainDrop.FallFrac), A

.Check          ; расчёт положения капли или точки удара от случайной точки появления
                LD A, (IX + FRainDrop.Phase)
                CP RAIN_FALL_PHASE
                JR C, .Falling                                                  ; переход, если требуется положение падающей капли

                LD C, RAIN_FALL_PATH
                JR .Position

.Falling        ADD A, A
                ADD A, A
                LD C, A
.Position       CALL Position

                ; проверка выхода траектории из игрового окна
                CALL InView
                JR NC, .Inside                                                  ; переход, если положение капли находится в игровом окне

                ; удаление вышедшей капли без рисования всплеска
                LD (IX + FRainDrop.Phase), RAIN_END_PHASE
                JR .Next

.Inside         ; проверка перехода к всплеску после полного падения
                LD A, (IX + FRainDrop.Phase)
                CP RAIN_FALL_PHASE
                JR C, .Draw                                                     ; переход, если капля ещё падает

                ; определение видимости гексагона в точке удара
                CALL World.SharedCode.Render.RainVisible
                JR Z, .Next                                                     ; переход, если гексагон полностью скрыт или не найден

.Draw                                                                           ; отображение текущей фазы и запоминание наличия рисунка
                CALL Shape
                LD (IX + FRainDrop.Shown), 1
.Next           LD DE, FRainDrop
                ADD IX, DE
                POP BC
                DEC B
                JP NZ, .Loop                                                    ; переход, если остались необработанные капли

                RET

; -----------------------------------------
; XOR рисунка одной фазы капли
; In:
;   IX - запись FRainDrop
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Shape:                                                                          ; проверка типа текущей фазы
                LD A, (IX + FRainDrop.Phase)
                CP RAIN_FALL_PHASE
                JR NC, .Splash                                                  ; переход, если наступила фаза всплеска

                ; расчёт пройденного расстояния от точки появления
                ADD A, A
                ADD A, A
                LD C, A
                CALL Position

                ; выбор формы штриха один раз перед обходом его пикселей
                CALL StrokeRow
                LD C, #00
                LD B, RAIN_FALL_STEP
.Fall           PUSH HL
                PUSH BC
                PUSH DE

                ; чтение очередного смещения из выбранной строки формы
                LD A, (HL)
                ADD A, E
                LD E, A

                ; расчёт вертикального положения пикселя относительно начала штриха
                LD A, D
                ADD A, C
                LD D, A
                CALL Pixel
                POP DE
                POP BC
                POP HL

                ; переход к следующему смещению и строке пикселя штриха
                INC HL
                INC C
                DJNZ .Fall
                RET

.Splash         ; выбор двух последовательных фаз всплеска
                SUB RAIN_FALL_PHASE
                PUSH AF

                ; расчёт фактической точки удара с учётом ветра
                LD C, RAIN_FALL_PATH
                CALL Position
                POP AF

                ; проверка начальной фазы удара перед разлётом брызг
                OR A
                LD HL, .Impact
                JR Z, .SplashDraw                                               ; переход, если отображается компактный всплеск в точке удара

                LD HL, .Spray
.SplashDraw     ; чтение количества пикселей выбранной фазы
                LD B, (HL)
                INC HL
.SplashLoop     PUSH BC
                PUSH DE

                ; расчёт положения брызги относительно точки удара
                LD A, (HL)
                ADD A, E
                LD E, A
                INC HL
                LD A, (HL)
                ADD A, D
                LD D, A
                INC HL
                PUSH HL
                CALL Pixel
                POP HL
                POP DE
                POP BC
                DJNZ .SplashLoop
                RET

                ; компактная корона, число точек и пары смещений X, Y от точки удара
.Impact         DB 7                                                            ; количество пикселей начального всплеска
                DB -2, -2                                                       ; верхняя левая брызга
                DB  2, -2                                                       ; верхняя правая брызга
                DB -1, -1                                                       ; левый склон короны
                DB  1, -1                                                       ; правый склон короны
                DB -1,  0                                                       ; левый край основания
                DB  0,  0                                                       ; центр удара
                DB  1,  0                                                       ; правый край основания

                ; разлёт брызг в стороны и вниз, число точек и пары смещений X, Y
.Spray          DB 6                                                            ; количество пикселей расходящихся брызг
                DB -4, -1                                                       ; дальняя левая брызга
                DB  4, -1                                                       ; дальняя правая брызга
                DB -3,  0                                                       ; средняя левая брызга
                DB  3,  0                                                       ; средняя правая брызга
                DB -2,  1                                                       ; нижняя левая брызга
                DB  2,  1                                                       ; нижняя правая брызга
; -----------------------------------------
; выбор строки симметричной формы короткого штриха по текущему ветру
; In:
; Out:
;   HL - адрес четырёх знаковых горизонтальных смещений пикселей штриха
; Corrupt:
;   BC, AF
; -----------------------------------------
StrokeRow:      ; расчёт горизонтального смещения конца четырёхпиксельного штриха
                LD C, RAIN_FALL_STEP - 1
                CALL WindOffset

                ; выбор строки симметричной формы по смещению конца от -3 до 3
                ADD A, RAIN_FALL_STEP - 1
                ADD A, A
                ADD A, A
                LD HL, .Offsets
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A
                RET

                ; проверка соответствия таблицы длине штриха
                assert RAIN_FALL_STEP == 4
.Offsets        DB 0, -1, -2, -3                                                ; конец смещён на три пикселя влево
                DB 0, -1, -1, -2                                                ; конец смещён на два пикселя влево
                DB 0,  0, -1, -1                                                ; конец смещён на один пиксель влево
                DB 0,  0,  0,  0                                                ; вертикальный штрих
                DB 0,  0,  1,  1                                                ; конец смещён на один пиксель вправо
                DB 0,  1,  1,  2                                                ; конец смещён на два пикселя вправо
                DB 0,  1,  2,  3                                                ; конец смещён на три пикселя вправо
; -----------------------------------------
; положение на траектории от случайной точки появления
; In:
;   C - пройденное вертикальное расстояние в пикселях
;   IX - запись FRainDrop
; Out:
;   DE - экранная позиция, D - y, E - x в пикселях
; Corrupt:
;   BC, AF
; -----------------------------------------
Position:       ; расчёт вертикального положения от точки появления
                LD A, (IX + FRainDrop.Y)
                ADD A, C
                LD D, A

                ; расчёт бокового сноса от точки появления
                CALL WindOffset
                ADD A, (IX + FRainDrop.X)
                LD E, A
                RET

; -----------------------------------------
; проверка принадлежности пикселя игровому окну
; In:
;   DE - экранная позиция, D - y, E - x в пикселях
; Out:
;   C установлен, если пиксель находится за пределами окна
; Corrupt:
;   AF
; -----------------------------------------
InView:         ; проверка горизонтальных границ игрового окна
                LD A, E
                SUB RAIN_MIN_X
                CP RAIN_RANGE_X
                CCF
                RET C                                                           ; выход, если пиксель находится вне горизонтальных границ

                ; проверка вертикальных границ игрового окна
                LD A, D
                SUB RAIN_MIN_Y
                CP RAIN_RANGE_Y
                CCF
                RET

; -----------------------------------------
; горизонтальное отклонение пикселя от точки появления
; In:
;   C - вертикальное расстояние в пикселях
; Out:
;   A - знаковое отклонение, расстояние умножается на Wind и делится на 8 с округлением
; Corrupt:
;   BC, AF
; -----------------------------------------
WindOffset:     ; проверка отсутствия бокового ветра
                LD A, (Wind)
                OR A
                RET Z                                                           ; выход, если дождь вертикальный

                ; расчёт абсолютной силы ветра
                JP P, .Magnitude                                                ; переход, если ветер направлен вправо

                NEG
.Magnitude      LD B, A
                XOR A

                ; расчёт произведения расстояния и абсолютной силы ветра
.Multiply       ADD A, C
                DJNZ .Multiply

                ; округление абсолютного отклонения к ближайшему пикселю перед делением на 8
                ADD A, #04
                SRL A
                SRL A
                SRL A

                ; восстановление знака горизонтального отклонения
                LD B, A
                LD A, (Wind)
                OR A
                LD A, B
                RET P                                                           ; выход, если ветер направлен вправо

                NEG
                RET

; -----------------------------------------
; плавное изменение ветра и скорости с выдержкой достигнутых целей
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   Wind и TargetWind имеют диапазон -8..8, знак задаёт направление падения
;   при RAIN_WIND_AUTO = 0 цели TargetWind и TargetSpeed задаются извне
; -----------------------------------------
Weather:        ; проверка периода плавного изменения погоды
                LD HL, WindClock
                DEC (HL)
                RET NZ                                                          ; выход, если период изменения ещё не завершён

                LD (HL), RAIN_WIND_TICK

                ; сравнение текущего ветра с целевым знаковым значением
                LD A, (TargetWind)
                LD C, A
                LD HL, Wind
                LD A, (HL)
                CP C
                JR Z, .Speed                                                    ; переход, если целевой ветер уже достигнут

                ; определение направления изменения силы ветра
                SUB C
                JP M, .WindUp                                                   ; переход, если текущая сила ветра меньше целевой

                DEC (HL)
                JR .Speed

.WindUp         INC (HL)
.Speed          ; сравнение текущей скорости с целевым значением
                LD A, (TargetSpeed)
                LD C, A
                LD HL, Speed
                LD A, (HL)
                CP C
                JR Z, .Hold                                                     ; переход, если целевая скорость уже достигнута

                JR C, .SpeedUp                                                  ; переход, если текущая скорость меньше целевой

                DEC (HL)
                JR .Hold

.SpeedUp        INC (HL)
.Hold           ; проверка разрешения автоматического выбора целей
                if RAIN_WIND_AUTO
                ; проверка достижения обеих целей перед отсчётом выдержки
                LD A, (TargetWind)
                LD HL, Wind
                CP (HL)
                RET NZ                                                          ; выход, если переход к целевому ветру ещё продолжается

                LD A, (TargetSpeed)
                LD HL, Speed
                CP (HL)
                RET NZ                                                          ; выход, если переход к целевой скорости ещё продолжается

                ; проверка завершения выдержки устойчивого дождя
                LD HL, Hold
                DEC (HL)
                RET NZ                                                          ; выход, если время выдержки ещё не закончилось

                ; выбор новой силы и направления ветра, включая вертикальное падение
.ChooseWind     CALL Random
                DEC A
                CP RAIN_WIND_MAX * 2 + 1
                JR NC, .ChooseWind                                              ; переход, если случайное значение выходит за диапазон силы ветра

                SUB RAIN_WIND_MAX
                LD (TargetWind), A

                ; выбор новой скорости в заданных пределах
.ChooseSpeed    CALL Random
                DEC A
                CP RAIN_SPEED_MAX - RAIN_SPEED_MIN + 1
                JR NC, .ChooseSpeed                                             ; переход, если случайное значение выходит за диапазон скорости

                ADD A, RAIN_SPEED_MIN
                LD (TargetSpeed), A

                ; выбор длительности следующей выдержки после достижения целей
                CALL Random
                AND RAIN_HOLD_MASK
                ADD A, RAIN_HOLD_MIN
                LD (Hold), A
                endif
                RET

; -----------------------------------------
; XOR одного пикселя теневого экрана по готовым таблицам
; In:
;   DE - экранная позиция, D - y, E - x в пикселях
; Out:
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
Pixel:          ; отсечение и XOR пикселя теневого экрана
                ; проверка границ перед обращением к таблицам и записи пикселя
                CALL InView
                RET C                                                           ; выход, если пиксель находится за пределами игрового окна

                ; получение адреса строки и байта по пиксельным координатам
                LD H, HIGH Adr.ScrAdrTable
                LD L, D
                LD A, (HL)
                INC H
                LD D, (HL)
                INC H
                LD L, E
                OR (HL)
                LD E, A
                INC H

                ; отображение пикселя через XOR готовой маски
                LD A, (DE)
                XOR (HL)
                LD (DE), A
                RET

; -----------------------------------------
; следующий байт псевдослучайной последовательности
; In:
; Out:
;   A - очередное значение
; Corrupt:
;   AF
; -----------------------------------------
Random:                                                                         ; продвижение ненулевого восьмибитного регистра с обратной связью
                LD A, (Seed)
                ADD A, A
                JR NC, .Store                                                   ; переход, если старший бит прежнего значения был сброшен

                XOR #1D
.Store          LD (Seed), A
                RET

                ; состояние эксперимента входит в развёртываемый код страницы 7
Seed            DB #A7                                                          ; ненулевое начальное состояние генератора
Wind            DB 0                                                            ; текущий ветер, отрицательный влево, нулевой вниз, положительный вправо
TargetWind      DB 0                                                            ; целевой ветер в диапазоне -8..8
Speed           DB RAIN_SPEED_DEF                                               ; текущая дробная скорость продвижения фазы падения
TargetSpeed     DB RAIN_SPEED_DEF                                               ; целевая дробная скорость продвижения фазы падения
WindClock       DB RAIN_WIND_TICK                                               ; остаток периода плавного изменения ветра и скорости
Hold            DB RAIN_HOLD_MIN                                                ; остаток выдержки устойчивого дождя
Camera          DB #FF, #FF, #FF, #FF                                           ; прежние MapPosition.X, Y и MapOffset.X, Y
Drops           FRainDrop {0, 0, 8, 0, 0}                                       ; точка появления X, Y, фаза нового появления, рисунок и дробный остаток отсутствуют
                dup RAIN_DROP_COUNT - 1
                FRainDrop {0, 0, 8, 0, 0}
                edup

                endmodule
                endif                                                           ; ~_WORLD_SCREEN_EFFECTS_RAIN_

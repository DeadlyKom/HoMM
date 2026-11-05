                ifndef _WORLD_SCREEN_EFFECTS_SNOW_
                define _WORLD_SCREEN_EFFECTS_SNOW_
                module Snow
; -----------------------------------------
; сброс состояния снега перед первым кадром нового или восстановленного мира
; In:
; Out:
; Corrupt:
;   AF
; -----------------------------------------
Reset:          XOR A
                LD (Ready), A
                LD (BaseShown), A
                RET
; -----------------------------------------
; снятие временной накладки с основного экрана перед рисованием карты
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   основной экран скрыт, теневой снег и сохранённый фон курсора не меняются
; -----------------------------------------
EraseBase:      ; проверка наличия временной накладки в основном экране
                LD A, (BaseShown)
                OR A
                RET Z                                                           ; выход, если временная накладка отсутствует

                LD IX, Flakes
                LD B, SNOW_COUNT
.Loop           PUSH BC

                ; чтение снимка, теневые позиции могли измениться после копирования
                LD E, (IX + FSnowFlake.BasePosition.X)
                LD D, (IX + FSnowFlake.BasePosition.Y)
                CALL ShapeAt.Base
                LD DE, FSnowFlake
                ADD IX, DE
                POP BC
                DJNZ .Loop

                XOR A
                LD (BaseShown), A
                RET
; -----------------------------------------
; нанесение текущего теневого снега на готовую карту основного экрана
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   вызов до FRAME_READY, снимок сохраняется до следующего EraseBase
; -----------------------------------------
DrawBase:       ; проверка наличия начального рисунка в теневом экране
                LD A, (Ready)
                OR A
                RET Z                                                           ; выход, если теневой снег ещё не создан

                ; проверка отсутствия уже нанесённой накладки
                LD A, (BaseShown)
                OR A
                RET NZ                                                          ; выход, если повторный XOR стёр бы готовую накладку

                LD IX, Flakes
                LD B, SNOW_COUNT
.Loop           PUSH BC

                ; сохранение координат для последующего снятия с основного экрана
                LD E, (IX + FSnowFlake.Position.X)
                LD D, (IX + FSnowFlake.Position.Y)
                LD (IX + FSnowFlake.BasePosition.X), E
                LD (IX + FSnowFlake.BasePosition.Y), D
                CALL ShapeAt.Base
                LD DE, FSnowFlake
                ADD IX, DE
                POP BC
                DJNZ .Loop

                LD A, 1
                LD (BaseShown), A
                RET
; -----------------------------------------
; снятие прежнего теневого снега после копирования и восстановления курсора
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   вызов при закрытом CursorMemcpyGate, копирование и восстановление курсора завершены
; -----------------------------------------
Erase:          ; проверка начального распределения снежинок
                LD A, (Ready)
                OR A
                RET Z                                                           ; выход, если снежинки ещё не созданы

                LD IX, Flakes
                LD B, SNOW_COUNT
.Loop           PUSH BC

                ; проверка наличия прежней формы в теневом экране
                BIT 7, (IX + FSnowFlake.Shown)
                JR Z, .Next                                                     ; переход, если форма ещё не нарисована

                CALL Shape
                RES 7, (IX + FSnowFlake.Shown)
.Next           LD DE, FSnowFlake
                ADD IX, DE
                POP BC
                DJNZ .Loop
                RET
; -----------------------------------------
; расчёт движения и вывод снега после копирования и восстановления курсора
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX
; Note:
;   включена страница 7, IY сохраняется, за вызов не более одного шага движения
; -----------------------------------------
Tick:           PUSH IY

                ; проверка первого включения снега
                LD A, (Ready)
                OR A
                CALL Z, Initialize                                              ; вызов, если снежинки ещё не созданы

                ; расчёт интервала после предыдущего шага движения
                LD HL, (TickCounterRef)
                LD DE, (LastTick)
                PUSH HL
                OR A
                SBC HL, DE
                LD A, H
                OR A
                JR NZ, .Step                                                    ; переход, если прошло не менее 256 прерываний

                ; проверка завершения периода обновления движения
                LD A, L
                CP SNOW_PERIOD
                JR NC, .Step                                                    ; переход, если пора обновить движение

                POP HL
                JR .Draw

.Step           POP HL
                LD (LastTick), HL
                CALL MoveCenters
                CALL Update
.Draw           CALL Draw
                POP IY
                RET
; -----------------------------------------
; начальное распределение свободных снежинок по всему игровому окну
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
Initialize:     ; установка центров внутри игрового окна в формате 8.8
                LD HL, (RAIN_MIN_X + RAIN_RANGE_X / 3) << 8
                LD (Centers + FVector16.X), HL
                LD HL, (RAIN_MIN_Y + RAIN_RANGE_Y / 3) << 8
                LD (Centers + FVector16.Y), HL
                LD HL, (RAIN_MIN_X + RAIN_RANGE_X * 2 / 3) << 8
                LD (Centers + FVector16 + FVector16.X), HL
                LD HL, (RAIN_MIN_Y + RAIN_RANGE_Y * 2 / 3) << 8
                LD (Centers + FVector16 + FVector16.Y), HL

                ; создание свободных позиций и независимых форм снежинок
                LD IX, Flakes
                LD B, SNOW_COUNT
.Loop           PUSH BC
                CALL RandomX
                LD (IX + FSnowFlake.Position.X), A
.RandomY        CALL World.SharedScreen.Effects.Rain.Random
                DEC A
                CP RAIN_RANGE_Y
                JR NC, .RandomY                                                 ; переход, если случайная высота находится вне окна

                ADD A, RAIN_MIN_Y
                LD (IX + FSnowFlake.Position.Y), A
                XOR A
                LD (IX + FSnowFlake.Fraction.X), A
                LD (IX + FSnowFlake.Fraction.Y), A
                LD (IX + FSnowFlake.Velocity.X), A
                LD (IX + FSnowFlake.Shown), A
                LD (IX + FSnowFlake.Velocity.Y), SNOW_FALL_BASE
.Type           CALL World.SharedScreen.Effects.Rain.Random
                AND 3
                CP 3
                JR Z, .Type                                                     ; переход, если выбран несуществующий номер формы

                LD (IX + FSnowFlake.Shape), A
                LD DE, FSnowFlake
                ADD IX, DE
                POP BC
                DJNZ .Loop

                ; сохранение исходного времени и признака готовности
                LD HL, (TickCounterRef)
                LD (LastTick), HL
                LD A, 1
                LD (Ready), A
                RET
; -----------------------------------------
; снос центров общим ветром дождя и их медленное оседание
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; -----------------------------------------
MoveCenters:    ; преобразование знакового ветра дождя в дробное смещение
                LD A, (World.SharedScreen.Effects.Rain.Wind)
                LD L, A
                LD H, 0
                BIT 7, L
                JR Z, .Scale                                                    ; переход, если ветер неотрицательный

                LD H, #FF
.Scale          dup SNOW_WIND_SHIFT
                ADD HL, HL
                edup
                EX DE, HL
                LD IX, Centers
                LD B, 2
.Loop           ; расчёт нового горизонтального положения центра
                LD L, (IX + FVector16.X.Low)
                LD H, (IX + FVector16.X.High)
                ADD HL, DE

                ; проверка выхода центра через левый край окна
                LD A, H
                CP RAIN_MIN_X
                JR NC, .Right                                                   ; переход, если центр не вышел за левый край

                LD H, RAIN_MIN_X + RAIN_RANGE_X - 1
                JR .StoreX

.Right          ; проверка выхода центра через правый край окна
                CP RAIN_MIN_X + RAIN_RANGE_X
                JR C, .StoreX                                                   ; переход, если центр остаётся внутри правого края

                LD H, RAIN_MIN_X
.StoreX         LD (IX + FVector16.X.Low), L
                LD (IX + FVector16.X.High), H

                ; расчёт медленного оседания центра вихря
                LD L, (IX + FVector16.Y.Low)
                LD H, (IX + FVector16.Y.High)
                LD A, L
                ADD A, SNOW_FALL_FRAC
                LD L, A
                JR NC, .Bottom                                                  ; переход, если целая часть высоты не изменилась

                INC H
.Bottom         ; проверка выхода центра через нижнюю границу окна
                LD A, H
                CP RAIN_MIN_Y + RAIN_RANGE_Y
                JR C, .StoreY                                                   ; переход, если центр остаётся внутри нижнего края

                LD H, RAIN_MIN_Y
.StoreY         LD (IX + FVector16.Y.Low), L
                LD (IX + FVector16.Y.High), H

                ; переход к следующему центру с сохранением общего бокового сноса
                PUSH DE
                LD DE, FVector16
                ADD IX, DE
                POP DE
                DJNZ .Loop
                RET
; -----------------------------------------
; свободное движение общей массы снега с инерцией и местным влиянием вихрей
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; -----------------------------------------
Update:         LD IX, Flakes
                LD B, SNOW_COUNT
.Loop           PUSH BC

                ; расчёт основного потока по общему ветру и форме снежинки
                LD A, (World.SharedScreen.Effects.Rain.Wind)
                ADD A, A
                ADD A, A
                LD E, A
                LD A, (IX + FSnowFlake.Shape)
                ADD A, A
                ADD A, SNOW_FALL_BASE
                LD D, A

                ; добавление касательной скорости первого локального вихря
                LD IY, Centers
                CALL Vortex

                ; добавление противоположного вращения второго вихря
                LD A, E
                NEG
                LD E, A
                LD A, D
                NEG
                LD D, A
                LD IY, Centers + FVector16
                CALL Vortex
                LD A, E
                NEG
                LD E, A
                LD A, D
                NEG
                LD D, A

                ; плавное приближение индивидуальной скорости к скорости потока
                LD A, E
                LD B, (IX + FSnowFlake.Velocity.X)
                CALL Relax
                LD (IX + FSnowFlake.Velocity.X), A
                LD A, D
                LD B, (IX + FSnowFlake.Velocity.Y)
                CALL Relax
                LD (IX + FSnowFlake.Velocity.Y), A

                ; расчёт свободной горизонтальной позиции с дробным остатком
                LD H, (IX + FSnowFlake.Position.X)
                LD L, (IX + FSnowFlake.Fraction.X)
                LD A, (IX + FSnowFlake.Velocity.X)
                CALL Integrate

                ; проверка выхода через левый край окна
                LD A, H
                CP RAIN_MIN_X
                JR NC, .Right                                                   ; переход, если снежинка не вышла через левый край

                ADD A, RAIN_RANGE_X
                JR .StoreX

.Right          ; проверка выхода через правый край окна
                CP RAIN_MIN_X + RAIN_RANGE_X
                JR C, .StoreX                                                   ; переход, если снежинка остаётся левее правого края

                SUB RAIN_RANGE_X
.StoreX         LD (IX + FSnowFlake.Position.X), A
                LD (IX + FSnowFlake.Fraction.X), L

                ; расчёт свободной вертикальной позиции с дробным остатком
                LD H, (IX + FSnowFlake.Position.Y)
                LD L, (IX + FSnowFlake.Fraction.Y)
                LD A, (IX + FSnowFlake.Velocity.Y)
                CALL Integrate

                ; проверка выхода через верхнюю границу окна
                LD A, H
                CP RAIN_MIN_Y
                JR NC, .Bottom                                                  ; переход, если снежинка не вышла через верхнюю границу

                ADD A, RAIN_RANGE_Y
                JR .WrapY

.Bottom         ; проверка выхода через нижнюю границу окна
                CP RAIN_MIN_Y + RAIN_RANGE_Y
                JR C, .StoreY                                                   ; переход, если снежинка остаётся выше нижней границы

                SUB RAIN_RANGE_Y
.WrapY          LD (IX + FSnowFlake.Position.Y), A
                CALL RandomX
                LD (IX + FSnowFlake.Position.X), A
                LD A, (IX + FSnowFlake.Position.Y)
.StoreY         LD (IX + FSnowFlake.Position.Y), A
                LD (IX + FSnowFlake.Fraction.Y), L

.Next           LD DE, FSnowFlake
                ADD IX, DE
                POP BC
                DEC B
                JP NZ, .Loop                                                    ; переход, если остались снежинки для перемещения

                RET
; -----------------------------------------
; местное отклонение потока, снежинка не привязывается к центру вихря
; In:
;   DE - целевая скорость, D по Y, E по X, знаковые доли с делителем 16
;   IX - запись FSnowFlake
;   IY - центр вихря FVector16
; Out:
;   DE - целевая скорость с добавленным вращением
; Corrupt:
;   BC, AF
; -----------------------------------------
Vortex:         ; расчёт расстояния до центра по горизонтали
                LD A, (IX + FSnowFlake.Position.X)
                SUB (IY + FVector16.X.High)
                LD B, A

                ; проверка горизонтальной дальности влияния вихря
                ADD A, SNOW_VORT_RANGE
                CP SNOW_VORT_RANGE * 2 + 1
                RET NC                                                          ; выход, если снежинка вне горизонтальной зоны влияния

                ; расчёт расстояния до центра по вертикали
                LD A, (IX + FSnowFlake.Position.Y)
                SUB (IY + FVector16.Y.High)
                LD C, A

                ; проверка вертикальной дальности влияния вихря
                ADD A, SNOW_VORT_RANGE
                CP SNOW_VORT_RANGE * 2 + 1
                RET NC                                                          ; выход, если снежинка вне вертикальной зоны влияния

                ; проверка принадлежности сильной внутренней области
                LD A, B
                ADD A, SNOW_VORT_CORE
                CP SNOW_VORT_CORE * 2 + 1
                JR NC, .Weaken                                                  ; переход, если горизонтальное расстояние превышает радиус ядра

                LD A, C
                ADD A, SNOW_VORT_CORE
                CP SNOW_VORT_CORE * 2 + 1
                JR C, .Tangent                                                  ; переход, если снежинка находится внутри ядра по обеим осям

.Weaken         ; ослабление вращения во внешней области вихря
                SRA B
                SRA C
.Tangent        ; расчёт касательной скорости по перпендикуляру к направлению на центр
                LD A, E
                SUB C
                LD E, A
                LD A, D
                ADD A, B
                LD D, A
                RET
; -----------------------------------------
; инерционное приближение скорости к потоку, не более двух долей за шаг
; In:
;   B - текущая знаковая скорость
;   A - целевая знаковая скорость
; Out:
;   A - обновлённая скорость
; Corrupt:
;   BC, AF
; -----------------------------------------
Relax:          ; сравнение знаковых скоростей через смещённый диапазон
                XOR #80
                LD C, A
                LD A, B
                XOR #80
                CP C
                JR Z, .Done                                                     ; переход, если текущая скорость уже равна целевой

                JR C, .Increase                                                 ; переход, если текущую скорость нужно увеличить

                ; уменьшение скорости с проверкой достижения цели после первой доли
                DEC B
                LD A, B
                XOR #80
                CP C
                JR Z, .Done                                                     ; переход, если целевая скорость достигнута после уменьшения на одну долю

                DEC B
                JR .Done

.Increase       ; увеличение скорости с проверкой достижения цели после первой доли
                INC B
                LD A, B
                XOR #80
                CP C
                JR Z, .Done                                                     ; переход, если целевая скорость достигнута после увеличения на одну долю

                INC B
.Done           LD A, B
                RET
; -----------------------------------------
; перенос свободной координаты на знаковую скорость
; In:
;   HL - позиция в формате 8.8
;   A - скорость в долях пикселя с делителем 16
; Out:
;   HL - новая позиция в формате 8.8
; Corrupt:
;   DE, AF
; -----------------------------------------
Integrate:      ; расширение знака скорости перед переводом из формата 4.4 в 8.8
                LD E, A
                LD D, 0
                OR A
                JP P, .Scale                                                    ; переход, если скорость неотрицательная

                DEC D
.Scale          ; расчёт смещения в единицах дробной координаты
                dup 4
                SLA E
                RL D
                edup
                ADD HL, DE
                RET
; -----------------------------------------
; случайная горизонтальная позиция для появления снега по всей ширине окна
; In:
; Out:
;   A - экранная координата X
; Corrupt:
;   AF
; -----------------------------------------
RandomX:        CALL World.SharedScreen.Effects.Rain.Random
                DEC A
                CP RAIN_RANGE_X
                JR NC, RandomX                                                  ; переход, если случайная координата находится вне окна

                ADD A, RAIN_MIN_X
                RET
; -----------------------------------------
; вывод всех отсутствующих форм только в теневой экран
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   вызов после восстановления скопированного курсора при закрытом CursorMemcpyGate
; -----------------------------------------
Draw:           LD IX, Flakes
                LD B, SNOW_COUNT
.Loop           PUSH BC

                ; проверка отсутствия формы перед повторным XOR
                BIT 7, (IX + FSnowFlake.Shown)
                JR NZ, .Next                                                    ; переход, если форма уже нарисована

                CALL Shape
                SET 7, (IX + FSnowFlake.Shown)
.Next           LD DE, FSnowFlake
                ADD IX, DE
                POP BC
                DJNZ .Loop
                RET
; -----------------------------------------
; XOR формы снежинки в теневом экране по сохранённой позиции
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   IX указывает на FSnowFlake, центр находится внутри игрового окна
; -----------------------------------------
Shape:          ; чтение сохранённых экранных координат снежинки
                LD E, (IX + FSnowFlake.Position.X)
                LD D, (IX + FSnowFlake.Position.Y)

; -----------------------------------------
; XOR формы по явно переданным координатам в выбранном экране
; In:
;   DE - экранная позиция, D по Y, E по X
;   IX - запись FSnowFlake с выбранной формой
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   центр DE находится внутри игрового окна, края многопиксельных форм отсекаются
; -----------------------------------------
ShapeAt:        ; выбор быстрого вывода формы только в теневой экран
                LD A, (IX + FSnowFlake.Shape)
                OR A
                JP Z, World.SharedScreen.Effects.Rain.PixelFast                  ; переход, если форма состоит из одной точки с центром внутри окна

                LD B, A
                JR .Bounds

.Base           ; выбор вывода формы в основной экран
                LD A, (IX + FSnowFlake.Shape)
                OR A
                JP Z, PixelBaseFast                                             ; переход, если форма состоит из одной точки внутри окна

                OR #80
                LD B, A
.Bounds         ; проверка полного размещения формы с запасом по одному пикселю
                LD A, E
                SUB RAIN_MIN_X + 1
                CP RAIN_RANGE_X - 2
                JP NC, .Generic                                                 ; переход, если форма касается горизонтальной границы окна

                LD A, D
                SUB RAIN_MIN_Y + 1
                CP RAIN_RANGE_Y - 2
                JP NC, .Generic                                                 ; переход, если форма касается вертикальной границы окна

                ; проверка пересечения правой границы пиксельного байта
                LD A, E
                AND 7
                CP 7
                JP Z, .Generic                                                  ; переход, если форма пересекает правую границу байта

                OR A
                JR NZ, .Address                                                 ; переход, если центр не находится на левой границе байта

                ; проверка левого выступа плюсика на границе байта
                LD A, B
                AND #7F
                DEC A
                JP Z, .Generic                                                  ; переход, если левый выступ плюсика находится в соседнем байте

.Address        CALL World.SharedScreen.Effects.Rain.PixelAddress
                LD A, (HL)
                LD C, A

                ; проверка выбора основного экрана для временной накладки
                BIT 7, B
                JR Z, .Type                                                     ; переход, если адрес уже указывает на теневой экран

                RES 7, D
.Type           LD A, B
                AND #7F
                DEC A
                JR NZ, .CubeFast                                                ; переход, если выбрана квадратная форма

                ; объединение трёх средних пикселей плюсика в одну маску байта
                PUSH BC
                LD A, C
                RLCA
                LD B, A
                LD A, C
                RRCA
                OR B
                OR C
                LD C, A
                CALL .Pair
                POP BC

                ; вывод верхнего и нижнего пикселей с повторным использованием адреса
                PUSH DE
                CALL .Up
                CALL .Pair
                POP DE
                CALL .Down
                JP .Pair

.CubeFast       ; объединение соседних пикселей в двух строках квадрата
                LD A, C
                RRCA
                OR C
                LD C, A
                CALL .Pair
                CALL .Down
                JP .Pair

.Pair           ; XOR объединённой маски в выбранном экране
                LD A, (DE)
                XOR C
                LD (DE), A
                RET

.Up             ; расчёт адреса предыдущей пиксельной строки Spectrum
                DEC D
                LD A, D
                AND 7
                CP 7
                RET NZ                                                          ; выход, если адрес остаётся в пределах восьми пиксельных строк

                LD A, E
                SUB #20
                LD E, A
                RET C                                                           ; выход, если переход пересёк границу трети экрана

                LD A, D
                ADD A, 8
                LD D, A
                RET

.Down           ; расчёт адреса следующей пиксельной строки Spectrum
                INC D
                LD A, D
                AND 7
                RET NZ                                                          ; выход, если адрес остаётся в пределах восьми пиксельных строк

                LD A, E
                ADD A, #20
                LD E, A
                RET C                                                           ; выход, если переход пересёк границу трети экрана

                LD A, D
                SUB 8
                LD D, A
                RET

.Generic        ; универсальный вывод с отсечением на границах окна и байта
                LD A, (IX + FSnowFlake.Shape)
                OR A
                LD HL, .Dot
                JR Z, .Draw                                                     ; переход, если снежинка рисуется точкой

                DEC A
                LD HL, .Plus
                JR Z, .Draw                                                     ; переход, если снежинка рисуется плюсиком

                LD HL, .Cube
.Draw           ; проверка выбранного экрана для шаблона на границе байта или окна
                BIT 7, B
                JP Z, World.SharedScreen.Effects.Rain.DrawPattern               ; переход, если шаблон рисуется в теневом экране

                JP PatternBase

.Dot            DB 1, 0, 0                                                      ; точка, число пикселей и пара X, Y
.Plus           DB 5, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1                            ; плюсик 3 на 3, число пикселей и пары X, Y
.Cube           DB 4, 0, 0, 1, 0, 0, 1, 1, 1                                    ; квадрат 2 на 2, число пикселей и пары X, Y

; -----------------------------------------
; XOR шаблона в основном экране с отсечением каждого пикселя
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   HL указывает на число точек и пары смещений, DE содержит центр
; -----------------------------------------
PatternBase:    LD B, (HL)
                INC HL
.Loop           PUSH BC
                PUSH DE

                ; расчёт положения очередной точки относительно центра снежинки
                LD A, (HL)
                ADD A, E
                LD E, A
                INC HL
                LD A, (HL)
                ADD A, D
                LD D, A
                INC HL
                PUSH HL
                CALL PixelBase
                POP HL
                POP DE
                POP BC
                DJNZ .Loop
                RET
; -----------------------------------------
; XOR одной точки основного экрана с отсечением по игровому окну
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   DE содержит экранные координаты, D по Y, E по X
; -----------------------------------------
PixelBase:      ; проверка размещения точки внутри игрового окна
                CALL World.SharedScreen.Effects.Rain.InView
                RET C                                                           ; выход, если точка находится за пределами игрового окна

; -----------------------------------------
; XOR точки основного экрана без отсечения по существующим таблицам
; In:
; Out:
; Corrupt:
;   HL, DE, AF
; Note:
;   DE содержит координаты внутри окна, D по Y, E по X
; -----------------------------------------
PixelBaseFast:  CALL World.SharedScreen.Effects.Rain.PixelAddress
                RES 7, D
                LD A, (DE)
                XOR (HL)
                LD (DE), A
                RET
BaseShown       DB 0                                                            ; флаг, временная накладка нанесена на основной экран
Ready           DB 0                                                            ; признак начального распределения снежинок
LastTick        DW 0                                                            ; время последнего шага движения в прерываниях
Centers         FVector16 {{0, 0}, {0, 0}}                                      ; первый центр, дробные координаты X, Y
                FVector16 {{0, 0}, {0, 0}}                                      ; второй центр
Flakes          FSnowFlake                                                      ; первая снежинка с полями по умолчанию
                dup SNOW_COUNT - 1
                FSnowFlake
                edup

                endmodule
                endif                                                           ; ~_WORLD_SCREEN_EFFECTS_SNOW_

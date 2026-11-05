                ifndef _WORLD_EFFECTS_TORNADO_
                define _WORLD_EFFECTS_TORNADO_
                module Tornado
; -----------------------------------------
; сброс единственного смерча при входе в мир
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   состояние находится в прежней области эффектов страницы 7
; -----------------------------------------
Reset:          XOR A
                LD (Ready), A
                LD (Phase), A
                LD (BaseShown), A
                LD (ShadowShown), A
                LD (World.SharedCode.Render.TornadoRequest), A

                ; очистка признаков рисунка перед первым кадром мира
                LD IX, Particles
                LD DE, FTornadoParticle
                LD B, TORNADO_PARTICLES
.Loop           LD (IX + FTornadoParticle.Shown), A
                ADD IX, DE
                DJNZ .Loop
                RET
; -----------------------------------------
; снятие основной накладки после возврата к теневому экрану
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   основной экран скрыт, фон курсора в теневом экране не меняется
; -----------------------------------------
EraseBase:      ; проверка наличия временной накладки
                LD A, (BaseShown)
                OR A
                RET Z                                                           ; выход, если основной экран уже чист

                XOR A
                LD (BaseShown), A
                LD IX, Particles
                LD B, TORNADO_PARTICLES
.Loop           PUSH BC

                ; проверка наличия именно сохранённого основного рисунка
                BIT 6, (IX + FTornadoParticle.Shown)
                JR Z, .Next                                                     ; переход, если частица в основном экране отсутствует

                LD E, (IX + FTornadoParticle.BasePosition.X)
                LD D, (IX + FTornadoParticle.BasePosition.Y)
                CALL World.SharedScreen.Effects.ParticleDraw.ShapeAt.Base
                RES 6, (IX + FTornadoParticle.Shown)
.Next           LD DE, FTornadoParticle
                ADD IX, DE
                POP BC
                DJNZ .Loop
                RET
; -----------------------------------------
; нанесение временной накладки перед готовностью основного кадра
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   во время копирования позиции и состав частиц на двух экранах одинаковы
; -----------------------------------------
DrawBase:       ; проверка наличия теневого рисунка
                LD A, (ShadowShown)
                OR A
                RET Z                                                           ; выход, если в теневом экране нет смерча

                ; проверка отсутствия повторного XOR готовой накладки
                LD A, (BaseShown)
                OR A
                RET NZ                                                          ; выход, если основная накладка уже нанесена

                LD A, 1
                LD (BaseShown), A
                LD IX, Particles
                LD B, TORNADO_PARTICLES
.Loop           PUSH BC

                ; копирование только фактически нарисованных частиц
                BIT 7, (IX + FTornadoParticle.Shown)
                JR Z, .Next                                                     ; переход, если частица в теневом экране отсутствует

                LD E, (IX + FTornadoParticle.Position.X)
                LD D, (IX + FTornadoParticle.Position.Y)
                LD (IX + FTornadoParticle.BasePosition.X), E
                LD (IX + FTornadoParticle.BasePosition.Y), D
                CALL World.SharedScreen.Effects.ParticleDraw.ShapeAt.Base
                SET 6, (IX + FTornadoParticle.Shown)
.Next           LD DE, FTornadoParticle
                ADD IX, DE
                POP BC
                DJNZ .Loop
                RET
; -----------------------------------------
; снятие прежних частиц после переноса блоков и восстановления курсора
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   CursorMemcpyGate уже закрыт штатным конвейером
; -----------------------------------------
Erase:          ; проверка наличия прежнего теневого рисунка
                LD A, (ShadowShown)
                OR A
                RET Z                                                           ; выход, если в теневом экране нечего снимать

                XOR A
                LD (ShadowShown), A
                LD IX, Particles
                LD B, TORNADO_PARTICLES
.Loop           PUSH BC

                ; проверка теневой видимости независимо от основного снимка
                BIT 7, (IX + FTornadoParticle.Shown)
                JR Z, .Next                                                     ; переход, если частица ранее не рисовалась

                CALL World.SharedScreen.Effects.ParticleDraw.Shape
                RES 7, (IX + FTornadoParticle.Shown)
.Next           LD DE, FTornadoParticle
                ADD IX, DE
                POP BC
                DJNZ .Loop
                RET
; -----------------------------------------
; обновление единственного смерча и вывод в скрытый теневой экран
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   вызывается после Erase, IY сохраняется, ожиданий прерывания нет
; -----------------------------------------
Tick:           PUSH IY

                ; проверка одноразового запроса повторного запуска
                LD A, (World.SharedCode.Render.TornadoRequest)
                OR A
                JR Z, .Ready                                                    ; переход, если новый запуск не запрошен

                XOR A
                LD (World.SharedCode.Render.TornadoRequest), A
                CALL Initialize
                JR .Life

.Ready          ; проверка первого запуска при входе в мир
                LD A, (Ready)
                OR A
                CALL Z, Initialize                                              ; вызов, если смерч ещё не запускался

.Life           ; проверка завершённого эффекта без автоматического повтора
                LD A, (Phase)
                OR A
                JR Z, .Done                                                     ; переход, если прежний смерч рассеялся

                ; расчёт возраста по штатному шестнадцатибитному счётчику IRQ
                LD HL, (TickCounterRef)
                LD DE, (StartTick)
                OR A
                SBC HL, DE
                LD DE, TORNADO_LIFE_TICKS
                OR A
                SBC HL, DE
                JR NC, .Stop                                                    ; переход, если время жизни истекло

                ADD HL, DE
                CALL Envelope
                CALL Steps
                OR A
                JR Z, .Paint                                                    ; переход, если следующая позиция ещё не требуется

                LD (StepCount), A
                CALL Motion
.Paint          CALL Draw
.Done           POP IY
                RET

.Stop           XOR A
                LD (Phase), A
                LD (Density), A
                JR .Done
; -----------------------------------------
; начальная настройка головок, шлейфов и свободных частиц
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   сохраняются позиции и флаги снимка основного экрана до следующего EraseBase
; -----------------------------------------
Initialize:     ; сброс времени и плотности для нового одиночного запуска
                LD HL, (TickCounterRef)
                LD (StartTick), HL
                LD (LastTick), HL
                XOR A
                LD (Density), A
                LD A, 1
                LD (Ready), A
                LD (Phase), A
                ; начальные фазы гармоник центра из прототипа при travelTime = 1.7
                LD HL, 14853
                LD (CenterPhaseX), HL
                LD HL, 27088
                LD (CenterPhase2), HL
                LD HL, 33187
                LD (CenterPhaseY), HL

                ; начальные фазы, высоты и индивидуальные пороги рассеивания
                LD IX, Particles
                LD B, TORNADO_PARTICLES
.Loop           PUSH BC
                CALL World.SharedScreen.Effects.ParticleDraw.Random
                LD (IX + FTornadoParticle.Phase), A
                CALL World.SharedScreen.Effects.ParticleDraw.Random
                LD (IX + FTornadoParticle.Height), A
                CALL World.SharedScreen.Effects.ParticleDraw.Random
                AND #1E
                LD C, A
                LD A, (IX + FTornadoParticle.Shown)
                AND #40
                OR C
                LD (IX + FTornadoParticle.Shown), A
                LD (IX + FTornadoParticle.Position.X), 0
                LD (IX + FTornadoParticle.Position.Y), 0
                LD DE, FTornadoParticle
                ADD IX, DE
                POP BC
                DJNZ .Loop

                ; выделение головок, записи шлейфа появятся из истории движения
                LD IX, Particles
                LD DE, FTornadoParticle * TORNADO_GROUP
                LD B, TORNADO_CORE_COUNT
.Heads          SET 5, (IX + FTornadoParticle.Shown)
                SET 0, (IX + FTornadoParticle.Shown)
                ADD IX, DE
                DJNZ .Heads

                ; включение самостоятельных точек силуэта
                LD DE, FTornadoParticle
                LD B, TORNADO_SMALL_COUNT
.Small          SET 0, (IX + FTornadoParticle.Shown)
                ADD IX, DE
                DJNZ .Small
                RET
; -----------------------------------------
; плотность появления и рассеивания по возрасту эффекта
; In:
;   HL - прошедшие прерывания, меньше TORNADO_LIFE_TICKS
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Envelope:       ; проверка начала второй фазы
                LD DE, TORNADO_RELEASE_TICKS
                OR A
                SBC HL, DE
                JR NC, .Release                                                 ; переход, если началось рассеивание

                ADD HL, DE
                LD A, 1
                LD (Phase), A

                ; проверка завершения нарастания плотности
                LD DE, TORNADO_FORM_TICKS
                OR A
                SBC HL, DE
                LD A, #FF
                JR NC, .Store                                                   ; переход, если достигнута полная плотность

                ADD HL, DE
                CALL Ramp
                JR .Scale

.Release        LD A, 2
                LD (Phase), A
                LD DE, TORNADO_LIFE_TICKS - TORNADO_RELEASE_TICKS
                CALL Ramp
                XOR 31
.Scale          ADD A, A
                ADD A, A
                ADD A, A
.Store          LD (Density), A
                RET
; -----------------------------------------
; расчёт уровня 0..31 по доле прошедшего интервала
; In:
;   HL - время внутри интервала
;   DE - длительность интервала
; Out:
;   A - уровень
; Corrupt:
;   HL, BC, AF
; -----------------------------------------
Ramp:           LD B, 5
.Scale          ADD HL, HL
                DJNZ .Scale
                LD C, 0
.Loop           OR A
                SBC HL, DE
                JR C, .Done                                                     ; переход, если вычислен полный уровень

                INC C
                LD A, C
                CP 31
                JR C, .Loop                                                     ; переход, если уровень ещё ниже предельного

.Done           LD A, C
                RET
; -----------------------------------------
; расчёт количества шагов движения и сохранение остатка времени
; In:
; Out:
;   A - число шагов, от 0 до 4
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Steps:          LD HL, (TickCounterRef)
                LD DE, (LastTick)
                OR A
                SBC HL, DE
                LD A, H
                OR A
                LD B, 4
                JR NZ, .Advance                                                 ; переход, если требуется предельное число шагов

                LD A, L
                LD B, 0
.Count          SUB TORNADO_PERIOD
                JR C, .Check                                                    ; переход, если остатка времени не хватает на шаг

                INC B
                LD C, A
                LD A, B
                CP 4
                JR NC, .Advance                                                 ; переход, если достигнут предел работы за кадр

                LD A, C
                JR .Count

.Check          LD A, B
                OR A
                RET Z                                                           ; выход, если шагов движения нет

.Advance        ; перенос последнего времени на полные шаги
                LD C, B
                LD HL, (LastTick)
                LD DE, TORNADO_PERIOD
.Add            ADD HL, DE
                DJNZ .Add
                LD (LastTick), HL
                LD A, C
                RET
; -----------------------------------------
; обновление центра, головок и независимых частиц
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
Motion:         ; расчёт углового шага с учётом текущей силы вихря
                LD A, (Density)
                RLCA
                RLCA
                RLCA
                AND 7
                LD HL, SpinRamp
                CALL Lookup
                CALL ScaleSteps
                LD (SpinStep), A

                ; расчёт подъёма и перемещения за прошедшие шаги
                LD A, TORNADO_RISE_STEP
                CALL ScaleSteps
                LD (RiseStep), A
                LD HL, CenterPhaseX
                LD DE, TORNADO_MOVE_X
                CALL MovePhase
                LD C, A
                LD A, 31
                CALL ScaleRadius
                LD A, C
                PUSH AF
                LD HL, CenterPhase2
                LD DE, TORNADO_MOVE_X2
                CALL MovePhase
                SRA A
                SRA A
                LD C, A
                POP AF
                ADD A, C
                ADD A, TORNADO_X
                LD (Center + FVector8.X), A
                LD HL, CenterPhaseY
                LD DE, TORNADO_MOVE_Y
                CALL MovePhase
                LD C, A
                LD A, 13
                CALL ScaleRadius
                LD A, C
                ADD A, TORNADO_Y
                LD (Center + FVector8.Y), A

                ; расчёт горизонтального расхождения в фазе рассеивания
                LD A, (Phase)
                CP 2
                LD A, 0
                JR NZ, .Spread                                                  ; переход, если вихрь ещё собирается

                LD A, (Density)
                CPL
                RRCA
                RRCA
                RRCA
                RRCA
                AND 15
.Spread         LD (Spread), A

                ; сохранение прежних путей и обновление головок
                LD IX, Particles
                LD B, TORNADO_CORE_COUNT
.Heads          PUSH BC
                CALL ShiftTrail
                CALL Advance
                LD DE, FTornadoParticle * TORNADO_GROUP
                ADD IX, DE
                POP BC
                DJNZ .Heads

                ; обновление самостоятельных точек с разной скоростью подъёма
                LD B, TORNADO_SMALL_COUNT
.Small          PUSH BC
                CALL Advance
                LD DE, FTornadoParticle
                ADD IX, DE
                POP BC
                DJNZ .Small
                RET
; -----------------------------------------
; умножение малого шага на число прошедших периодов
; In:
;   A - шаг за один период
; Out:
;   A - суммарный шаг
; Corrupt:
;   BC, AF
; -----------------------------------------
ScaleSteps:     LD C, A
                LD A, (StepCount)
                LD B, A
                XOR A
.Loop           ADD A, C
                DJNZ .Loop
                RET
; -----------------------------------------
; сдвиг записанных позиций головки вдоль её шлейфа
; In:
; Out:
; Corrupt:
;   DE, BC, AF, IY
; Note:
;   IX указывает на головку и сохраняется, основной снимок не меняется
; -----------------------------------------
ShiftTrail:     PUSH IX
                LD DE, FTornadoParticle * (TORNADO_TAIL_COUNT - 1)
                ADD IX, DE
                PUSH IX
                POP IY
                LD DE, FTornadoParticle
                ADD IY, DE
                LD B, TORNADO_TAIL_COUNT
.Loop           ; перенос прежней позиции и высоты в следующую запись
                LD A, (IX + FTornadoParticle.Position.X)
                LD (IY + FTornadoParticle.Position.X), A
                LD A, (IX + FTornadoParticle.Position.Y)
                LD (IY + FTornadoParticle.Position.Y), A
                LD A, (IX + FTornadoParticle.Height)
                LD (IY + FTornadoParticle.Height), A
                LD A, (IX + FTornadoParticle.Shown)
                AND 1
                LD C, A
                LD A, (IY + FTornadoParticle.Shown)
                AND #7E
                OR C
                LD (IY + FTornadoParticle.Shown), A
                LD DE, -FTornadoParticle
                ADD IX, DE
                ADD IY, DE
                DJNZ .Loop
                POP IX
                RET
; -----------------------------------------
; подъём, вращение и расчёт экранной позиции одной частицы
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   IX указывает на головку или самостоятельную точку
; -----------------------------------------
Advance:        ; проверка существования частицы
                BIT 0, (IX + FTornadoParticle.Shown)
                RET Z                                                           ; выход, если частица уже рассеялась

                ; расчёт подъёма с небольшим разбросом для мелких точек
                LD A, (RiseStep)
                LD C, A
                BIT 5, (IX + FTornadoParticle.Shown)
                JR NZ, .Rise                                                    ; переход, если используется скорость головки

                BIT 1, (IX + FTornadoParticle.Shown)
                JR Z, .Rise                                                     ; переход, если точке назначена обычная скорость

                SLA C
.Rise           LD A, (IX + FTornadoParticle.Height)
                ADD A, C
                JR NC, .Height                                                  ; переход, если частица ещё не достигла вершины

                ; проверка разрешения нового подъёма после выхода наверху
                LD C, A
                LD A, (Phase)
                CP 2
                LD A, C
                JR NZ, .Height                                                  ; переход, если в первой фазе частица возвращается к основанию

                RES 0, (IX + FTornadoParticle.Shown)
                RET

.Height         LD (IX + FTornadoParticle.Height), A

                ; поправка углового шага по производной turns из прототипа
                LD HL, TurnRate
                CALL Profile
                LD C, A
                LD A, (SpinStep)
                CALL Product
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD A, (IX + FTornadoParticle.Phase)
                ADD A, H
                LD (IX + FTornadoParticle.Phase), A

                ; интерполяция радиуса между узлами профиля
                LD A, (IX + FTornadoParticle.Height)
                LD HL, Radius
                CALL Profile
                LD (RadiusValue), A

                ; расчёт горизонтальной координаты с расхождением от оси
                LD A, (IX + FTornadoParticle.Phase)
                CALL Sine
                LD C, A
                LD A, (RadiusValue)
                CALL ScaleRadius
                LD A, (Spread)
                BIT 4, (IX + FTornadoParticle.Shown)
                JR Z, .X                                                        ; переход, если частица рассеивается вправо

                NEG
.X              ADD A, C
                LD C, A
                LD A, (Center + FVector8.X)
                ADD A, C
                LD (IX + FTornadoParticle.Position.X), A

                ; расчёт экранной высоты и глубины спирального витка
                LD A, (IX + FTornadoParticle.Height)
                LD HL, Lift
                CALL Profile
                LD B, A
                LD A, (IX + FTornadoParticle.Phase)
                ADD A, 64
                CALL Sine
                LD C, A
                LD A, (RadiusValue)
                SRL A
                SRL A
                CALL ScaleRadius
                LD A, (Center + FVector8.Y)
                SUB B
                ADD A, C
                LD (IX + FTornadoParticle.Position.Y), A
                RET
; -----------------------------------------
; масштабирование синуса с амплитудой 32 до радиуса в пикселях
; In:
;   C - знаковый синус
;   A - радиус
; Out:
;   C - знаковое смещение
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
ScaleRadius:    CALL Product
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD C, H
                RET
; -----------------------------------------
; умножение беззнакового множителя на знаковый байт
; In:
;   C - знаковый множитель
;   A - беззнаковый множитель
; Out:
;   HL - произведение
; Corrupt:
;   DE, AF
; -----------------------------------------
Product:        LD E, C
                LD D, 0
                BIT 7, E
                JR Z, .Start                                                    ; переход, если множитель неотрицателен

                DEC D
.Start          LD HL, 0
.Loop           SRL A
                JR NC, .Next                                                    ; переход, если очередной бит множителя равен нулю

                ADD HL, DE
.Next           RET Z                                                           ; выход, если все значащие биты обработаны

                SLA E
                RL D
                JR .Loop
; -----------------------------------------
; линейная интерполяция профиля из 17 узлов
; In:
;   HL - адрес профиля
;   A - фаза подъёма
; Out:
;   A - значение профиля
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Profile:        LD B, A
                AND 15
                LD C, A
                LD A, B
                RRCA
                RRCA
                RRCA
                RRCA
                AND 15
                CALL Lookup
                LD B, A
                INC HL
                LD A, (HL)
                SUB B
                LD E, B
                PUSH DE
                LD B, C
                LD C, A
                LD A, B
                CALL Product
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                POP DE
                LD A, H
                ADD A, E
                RET
; -----------------------------------------
; продвижение 16-битной фазы гармоники центра и чтение синуса
; In:
;   HL - адрес фазы
;   DE - прирост фазы за период
; Out:
;   A - синус
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
MovePhase:      PUSH HL
                LD C, (HL)
                INC HL
                LD H, (HL)
                LD L, C
                LD A, (StepCount)
                LD B, A
.Loop           ADD HL, DE
                DJNZ .Loop
                EX DE, HL
                POP HL
                LD (HL), E
                INC HL
                LD (HL), D
                LD A, D
                JP Sine
; -----------------------------------------
; чтение синуса и общая адресация байтовой таблицы
; In:
;   HL - таблица для Lookup
;   A - индекс или угол для Sine
; Out:
;   A - байт таблицы
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
Sine:           ; расчёт индекса четверти синуса по полному углу
                LD E, A
                AND #3F
                BIT 6, E
                JR Z, .Index                                                    ; переход, если четверть читается в прямом порядке

                NEG
                ADD A, 64
.Index          LD HL, SinTable

                ; восстановление знака второй половины оборота
                BIT 7, E
                JP Z, Lookup                                                    ; переход, если синус неотрицателен

                CALL Lookup
                NEG
                RET

Lookup:         LD E, A
                LD D, 0
                ADD HL, DE
                LD A, (HL)
                RET
; -----------------------------------------
; XOR текущего набора частиц в теневом экране
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   основной снимок остаётся неизменным, флаги видимости устанавливаются после вывода
; -----------------------------------------
Draw:           ; проверка ненулевой плотности эффекта
                LD A, (Density)
                OR A
                RET Z                                                           ; выход, если эффект ещё не появился или уже рассеялся

                LD A, 1
                LD (ShadowShown), A
                LD IX, Particles
                LD B, TORNADO_PARTICLES
.Loop           PUSH BC

                ; проверка наличия частицы в истории
                BIT 0, (IX + FTornadoParticle.Shown)
                JR Z, .Next                                                     ; переход, если запись ещё пуста или рассеялась

                ; проверка постоянного порога видимости частицы
                LD A, (IX + FTornadoParticle.Shown)
                AND #1E
                RLCA
                RLCA
                RLCA
                LD C, A
                LD A, (Density)
                CP C
                JR C, .Next                                                     ; переход, если плотность ниже порога частицы

                ; постепенное заполнение высоты при появлении
                LD A, (Phase)
                CP 2
                JR Z, .Top                                                      ; переход, если в фазе рассеивания высота не ограничивает появление

                LD A, (Density)
                CP (IX + FTornadoParticle.Height)
                JR C, .Next                                                     ; переход, если верхняя область ещё не заполнилась

.Top            ; проверка рассеивания отдельной частицы в конце подъёма
                LD A, (IX + FTornadoParticle.Height)
                CP 224
                JR C, .Plot                                                     ; переход, если частица находится ниже зоны рассеивания

                CPL
                ADD A, A
                ADD A, A
                ADD A, A
                CP C
                JR C, .Next                                                     ; переход, если частица растворилась у вершины

.Plot           ; отсечение позиции до быстрого расчёта адреса
                LD E, (IX + FTornadoParticle.Position.X)
                LD D, (IX + FTornadoParticle.Position.Y)
                CALL World.SharedScreen.Effects.ParticleDraw.InView
                JR C, .Next                                                     ; переход, если частица за пределами игрового окна

                CALL World.SharedScreen.Effects.ParticleDraw.ShapeAt
                SET 7, (IX + FTornadoParticle.Shown)
.Next           LD DE, FTornadoParticle
                ADD IX, DE
                POP BC
                DJNZ .Loop
                RET
                ; амплитуда углового шага в зависимости от плотности
SpinRamp        DB 0, TORNADO_SPIN_STEP/7, TORNADO_SPIN_STEP*2/7, TORNADO_SPIN_STEP*3/7
                DB TORNADO_SPIN_STEP*4/7, TORNADO_SPIN_STEP*5/7, TORNADO_SPIN_STEP*6/7, TORNADO_SPIN_STEP
                ; узлы radiusProfile, lift и производной turns из браузерного прототипа
Radius          DB 20, 13, 9, 7, 7, 6, 6, 6, 6, 6, 6, 7, 10, 15, 20, 24, 26
Lift            DB 0, 0, 0, 1, 4, 7, 11, 15, 20, 25, 30, 35, 39, 43, 45, 47, 48
TurnRate        DB 8, 10, 13, 17, 19, 21, 22, 23, 22, 22, 20, 18, 15, 12, 8, 8, 8
                ; четверть синуса с амплитудой 32 пикселя, остальные четверти отражаются
SinTable        DB 0, 1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 9, 9, 10, 11, 12
                DB 12, 13, 14, 14, 15, 16, 16, 17, 18, 18, 19, 20, 20, 21, 21, 22
                DB 23, 23, 24, 24, 25, 25, 26, 26, 27, 27, 27, 28, 28, 29, 29, 29
                DB 30, 30, 30, 30, 31, 31, 31, 31, 31, 32, 32, 32, 32, 32, 32, 32
                DB 32
                ; состояние единственного активного смерча
Ready           DB 0                                                            ; флаг, первый запуск выполнен
Phase           DB 0                                                            ; 0 завершён, 1 завихрение, 2 рассеивание
BaseShown       DB 0                                                            ; флаг, основной снимок нанесён
ShadowShown     DB 0                                                            ; флаг, теневой рисунок нанесён
StartTick       DW 0                                                            ; время запуска по счётчику IRQ
LastTick        DW 0                                                            ; время последнего шага движения
Density         DB 0                                                            ; текущая плотность от 0 до 255
StepCount       DB 0                                                            ; число полных периодов, учтённых за кадр
SpinStep        DB 0                                                            ; угловое смещение за прошедшие шаги
RiseStep        DB 0                                                            ; подъём головки за прошедшие шаги
CenterPhaseX    DW 0                                                            ; первая гармоника горизонтального движения
CenterPhase2    DW 0                                                            ; вторая гармоника горизонтального движения
CenterPhaseY    DW 0                                                            ; гармоника вертикального движения
Center          FVector8                                                        ; координаты основания смерча
Spread          DB 0                                                            ; разлёт в фазе рассеивания
RadiusValue     DB 0                                                            ; текущий радиус витка в пикселях
Particles       FTornadoParticle                                                ; головки со шлейфами, затем самостоятельные точки
                dup TORNADO_PARTICLES - 1
                FTornadoParticle
                edup
                endmodule
                endif                                                           ; ~_WORLD_EFFECTS_TORNADO_

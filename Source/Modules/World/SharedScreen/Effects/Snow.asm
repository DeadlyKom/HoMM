                ifndef _WORLD_SCREEN_EFFECTS_SNOW_
                define _WORLD_SCREEN_EFFECTS_SNOW_
                module Snow
; -----------------------------------------
; подготовка снега по общей маске обновляемых экранных блоков
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX
; Note:
;   включена страница 7, IY сохраняется, маска хранится в регистрах и стеке
;   список гексов обходится один раз, флаги RenderBuffer не изменяются
; -----------------------------------------
Prepare:        ; проверка наличия ранее созданного снега
                LD A, (Ready)
                OR A
                RET Z                                                           ; выход, если снежинки ещё не созданы

                PUSH IY
                CALL DirtyMask

                ; проверка наличия обновляемых блоков перед обходом снежинок
                LD A, D
                OR E
                JR Z, .Done                                                     ; переход, если обновляемые блоки отсутствуют

                LD IX, Flakes
                LD B, SNOW_COUNT
.Loop           PUSH BC

                ; проверка наличия рисунка перед проверкой его блоков
                BIT 7, (IX + FSnowFlake.Shown)
                JR Z, .Next                                                     ; переход, если снежинка уже отсутствует на экранах

                CALL TouchesMask
                JR NC, .Next                                                    ; переход, если блоки снежинки не будут обновлены

                ; снятие формы с обновлением сохранённого фона курсора
                PUSH DE
                CALL World.SharedCode.Render.PipelineHexagons.RemoveSnow
                POP DE
                RES 7, (IX + FSnowFlake.Shown)
.Next           LD BC, FSnowFlake
                ADD IX, BC
                POP BC
                DJNZ .Loop
.Done           POP IY
                RET
; -----------------------------------------
; однократный сбор маски блоков по обновляемым гексам списка отображения
; In:
; Out:
;   DE - маска 16 блоков, бит равен номеру строки блока * 4 + номеру столбца
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IY
; Note:
;   высота гекса берётся с запасом 8 знакомест, маска накапливается в HL'
; -----------------------------------------
DirtyMask:      ; начальное пустое значение маски в альтернативных регистрах
                LD HL, 0
                EXX

                ; проверка наличия строк списка отображения
                LD A, (GameState.DisplayListLen)
                OR A
                JR Z, .Finish                                                   ; переход, если список отображения пуст

                LD B, A
                LD IY, (GameState.DisplayList)
.Row            PUSH BC

                ; чтение очередной строки штатного списка отображения
                LD DE, -Size.DisplayList.ElementSize
                ADD IY, DE

                ; расчёт исходной нижней строки гекса с учётом отсечения снизу
                LD A, (IY + 4)
                ADD A, A
                ADD A, A
                ADD A, A
                ADD A, (IY + 3)
                LD D, A

                ; расчёт левой границы и числа столбцов с учётом отсечения слева
                LD A, (IY + 0)
                AND #7F
                LD C, A
                ADD A, A
                ADD A, A
                ADD A, A
                NEG
                ADD A, RAIN_MIN_X
                LD E, A
                LD A, C
                ADD A, SCR_WORLD_SIZE_X
                LD B, A
                LD L, (IY + 1)
                LD H, HIGH Adr.RenderBuffer
.Hex            ; проверка необходимости рисования текущего гекса
                BIT RENDER_FLAG_HEX_UPDATE_BIT, (HL)
                JR Z, .NextHex                                                  ; переход, если гекс не будет перерисован

                PUSH BC
                PUSH DE
                PUSH HL
                CALL HexMask

                ; объединение маски гекса с общей маской обновляемых блоков
                PUSH HL
                EXX
                POP DE
                LD A, H
                OR D
                LD H, A
                LD A, L
                OR E
                LD L, A
                EXX
                POP HL
                POP DE
                POP BC
.NextHex        ; переход к следующему гексу текущей строки
                INC L
                LD A, E
                ADD A, HEXTILE_SIZE_X * 8
                LD E, A
                LD A, B
                SUB HEXTILE_SIZE_X
                LD B, A
                JR C, .NextRow                                                  ; переход, если последняя видимая часть гекса обработана

                JR Z, .NextRow                                                  ; переход, если строка закончилась на границе гекса

                JR .Hex

.NextRow        POP BC
                DJNZ .Row
.Finish         EXX
                EX DE, HL
                RET
; -----------------------------------------
; маска блоков, пересекаемых прямоугольником гекса с максимальной высотой
; In:
;   DE - нижняя строка D и левая граница E в пикселях, отрицательный X упакован
; Out:
;   HL - маска блоков гекса внутри игрового окна
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
HexMask:        ; проверка нахождения нижней строки ниже верхнего края окна
                LD HL, 0
                LD A, D
                CP RAIN_MIN_Y
                RET C                                                           ; выход, если весь гекс находится выше игрового окна

                ; проверка выхода верхней строки гекса ниже игрового окна
                CP RAIN_MIN_Y + RAIN_RANGE_Y + 8 * 8 - 1
                RET NC                                                          ; выход, если весь гекс находится ниже игрового окна

                ; расчёт первого столбца блоков с отсечением отрицательной границы
                LD A, E
                CP RAIN_MIN_X + RAIN_RANGE_X
                JR C, .Left                                                     ; переход, если левая граница находится внутри окна

                LD A, RAIN_MIN_X
.Left           SUB RAIN_MIN_X
                CALL BlockIndex
                LD B, A

                ; расчёт последнего столбца блоков с отсечением справа
                LD A, E
                ADD A, HEXTILE_SIZE_X * 8 - 1
                CP RAIN_MIN_X + RAIN_RANGE_X
                JR C, .Right                                                    ; переход, если правая граница находится внутри окна

                LD A, RAIN_MIN_X + RAIN_RANGE_X - 1
.Right          SUB RAIN_MIN_X
                CALL BlockIndex
                LD C, A

                ; расчёт первой строки блоков с отсечением сверху
                LD A, D
                SUB 8 * 8 - 1
                JR C, .ClampTop                                                 ; переход, если верхняя граница гекса отрицательная

                CP RAIN_MIN_Y
                JR NC, .Top                                                     ; переход, если верхняя граница не выходит выше окна

.ClampTop       LD A, RAIN_MIN_Y
.Top            SUB RAIN_MIN_Y
                CALL BlockIndex
                LD E, A

                ; расчёт последней строки блоков с отсечением снизу
                LD A, D
                CP RAIN_MIN_Y + RAIN_RANGE_Y
                JR C, .Bottom                                                   ; переход, если нижняя граница находится внутри окна

                LD A, RAIN_MIN_Y + RAIN_RANGE_Y - 1
.Bottom         SUB RAIN_MIN_Y
                CALL BlockIndex
                LD D, A
                JP BlockMask
; -----------------------------------------
; пересечение кешированных блоков снежинки с общей маской обновления
; In:
;   DE - маска обновляемых блоков
;   IX - запись FSnowFlake с кешем в Shown
; Out:
;   C - флаг, пересечение найдено
; Corrupt:
;   BC, AF
; -----------------------------------------
TouchesMask:    ; проверка быстрого случая обновления всего игрового окна
                LD A, D
                AND E
                CP #FF
                JR NZ, .Cached                                                  ; переход, если обновляется только часть блоков

                SCF
                RET

.Cached         ; чтение готовых столбцов и номера первой строки блоков
                LD A, (IX + FSnowFlake.Shown)
                LD B, A
                AND #0F
                LD C, A

                ; выбор пары строк блоков из старшего или младшего байта общей маски
                BIT 5, B
                LD A, E
                JR Z, .RowByte                                                  ; переход, если первая строка блоков равна 0 или 1

                LD A, D
.RowByte        ; выбор младшей или старшей тетрады с четырьмя столбцами строки
                BIT 4, B
                JR Z, .CheckRow                                                 ; переход, если первая строка блоков чётная

                RRCA
                RRCA
                RRCA
                RRCA
.CheckRow       ; проверка пересечения первой строки формы с обновляемыми блоками
                AND C
                JR NZ, .Found                                                   ; переход, если общие блоки найдены в первой строке формы

                ; проверка наличия второй строки блоков у формы
                BIT 6, B
                RET Z                                                           ; выход, если второй строки нет, флаг переноса сброшен предыдущим AND

                ; выбор второй строки без повторного расчёта координат
                LD A, D
                BIT 4, B
                JR NZ, .CheckNext                                               ; переход, если после строки 1 проверяется строка 2

                LD A, E
                BIT 5, B
                JR Z, .NextHigh                                                 ; переход, если после строки 0 проверяется строка 1

                LD A, D
.NextHigh       RRCA
                RRCA
                RRCA
                RRCA
.CheckNext      AND C
                RET Z                                                           ; выход, если общие блоки отсутствуют, флаг переноса сброшен

.Found          SCF
                RET
; -----------------------------------------
; кеширование блоков формы только после изменения пиксельной позиции
; In:
;   IX - запись FSnowFlake
; Out:
;   Shown - кеш блоков с сохранённым флагом наличия рисунка
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
CacheBlocks:    ; расчёт границ формы с отсечением по игровому окну
                ; расчёт первого столбца блоков с запасом по краю формы
                LD A, (IX + FSnowFlake.Position.X)
                SUB RAIN_MIN_X
                OR A
                JR Z, .Left                                                     ; переход, если центр уже находится на левой границе

                DEC A
.Left           CALL BlockIndex
                LD B, A

                ; расчёт последнего столбца блоков с отсечением справа
                LD A, (IX + FSnowFlake.Position.X)
                SUB RAIN_MIN_X
                INC A
                CP RAIN_RANGE_X
                JR C, .Right                                                    ; переход, если край формы остаётся внутри окна

                LD A, RAIN_RANGE_X - 1
.Right          CALL BlockIndex
                LD C, A

                ; расчёт первой строки блоков с запасом по краю формы
                LD A, (IX + FSnowFlake.Position.Y)
                SUB RAIN_MIN_Y
                OR A
                JR Z, .Top                                                      ; переход, если центр уже находится на верхней границе

                DEC A
.Top            CALL BlockIndex
                LD E, A

                ; расчёт последней строки блоков с отсечением снизу
                LD A, (IX + FSnowFlake.Position.Y)
                SUB RAIN_MIN_Y
                INC A
                CP RAIN_RANGE_Y
                JR C, .Bottom                                                   ; переход, если край формы остаётся внутри окна

                LD A, RAIN_RANGE_Y - 1
.Bottom         CALL BlockIndex
                LD D, A
                CALL ColumnMask

                ; упаковка столбцов и номера первой строки в прежний байт состояния
                LD A, E
                RLCA
                RLCA
                RLCA
                RLCA
                OR L
                LD L, A

                ; проверка пересечения границы двух строк блоков
                LD A, D
                CP E
                JR Z, .Store                                                    ; переход, если форма занимает одну строку блоков

                SET 6, L
.Store          ; сохранение кеша без изменения наличия прежнего рисунка
                LD A, (IX + FSnowFlake.Shown)
                AND #80
                OR L
                LD (IX + FSnowFlake.Shown), A
                RET
; -----------------------------------------
; маска прямоугольника из одного или двух столбцов и не более трёх строк блоков
; In:
;   DE - последняя строка D и первая строка E, номера 0..3
;   BC - первый столбец B и последний столбец C, номера 0..3
; Out:
;   HL - маска прямоугольника
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
BlockMask:      CALL ColumnMask
.RowShift       ; расчёт смещения первой строки блоков внутри 16-битной маски
                LD A, E
                ADD A, A
                ADD A, A
                OR A
                JR Z, .Rows                                                     ; переход, если первая строка блоков нулевая

.ShiftRow       ADD HL, HL
                DEC A
                JR NZ, .ShiftRow                                                ; переход, если первая строка блоков ещё не достигнута

.Rows           ; расчёт числа дополнительных строк прямоугольника
                LD A, D
                SUB E
                LD B, A
                LD D, H
                LD E, L
                OR A
                RET Z                                                           ; выход, если прямоугольник занимает одну строку блоков

.MoreRows       ; добавление следующей строки с теми же столбцами
                dup 4
                SLA E
                RL D
                edup
                LD A, H
                OR D
                LD H, A
                LD A, L
                OR E
                LD L, A
                DJNZ .MoreRows
                RET
; -----------------------------------------
; маска одного или двух соседних столбцов блоков
; In:
;   BC - первый столбец B и последний столбец C, номера 0..3
; Out:
;   HL - маска столбцов, значение 1..15
; Corrupt:
;   HL, BC, AF
; -----------------------------------------
ColumnMask:     ; расчёт бита первого столбца внутри одной строки блоков
                LD HL, 1
                LD A, B
                OR A
                JR Z, .Columns                                                  ; переход, если первый блок находится в нулевом столбце

.ShiftColumn    ADD HL, HL
                DEC A
                JR NZ, .ShiftColumn                                             ; переход, если номер первого столбца ещё не достигнут

.Columns        ; проверка пересечения границы двух соседних столбцов
                LD A, C
                CP B
                JR Z, .Done                                                     ; переход, если прямоугольник занимает один столбец

                LD B, H
                LD C, L
                ADD HL, HL
                LD A, H
                OR B
                LD H, A
                LD A, L
                OR C
                LD L, A
.Done           RET
; -----------------------------------------
; номер блока по координате относительно начала игрового окна
; In:
;   A - координата 0..175 в пикселях
; Out:
;   A - номер блока 0..3
; Corrupt:
;   AF
; -----------------------------------------
BlockIndex:     ; проверка первой полосы блоков шириной 48 пикселей
                CP HEXTILE_SIZE_X * 8
                JR C, .Zero                                                     ; переход, если координата находится в первом блоке

                ; проверка второй полосы блоков
                CP HEXTILE_SIZE_X * 8 * 2
                JR C, .One                                                      ; переход, если координата находится во втором блоке

                ; проверка третьей полосы блоков
                CP HEXTILE_SIZE_X * 8 * 3
                LD A, 2
                RET C                                                           ; выход, если координата находится в третьем блоке

                INC A
                RET

.Zero           XOR A
                RET

.One            LD A, 1
                RET
; -----------------------------------------
; движение по счётчику прерываний с немедленной заменой каждой снежинки
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
                POP IY
                RET

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
                CALL CacheBlocks
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

                ; сохранение прежней позиции до расчёта движения этой снежинки
                LD E, (IX + FSnowFlake.Position.X)
                LD D, (IX + FSnowFlake.Position.Y)
                PUSH DE

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

                ; проверка изменения целых координат перед пересчётом кеша блоков
                POP DE
                LD A, (IX + FSnowFlake.Position.X)
                CP E
                JR NZ, .Recache                                                 ; переход, если снежинка сдвинулась по горизонтали

                LD A, (IX + FSnowFlake.Position.Y)
                CP D
                JR NZ, .Recache                                                 ; переход, если снежинка сдвинулась по вертикали

                ; проверка наличия рисунка при неизменной пиксельной позиции
                BIT 7, (IX + FSnowFlake.Shown)
                JR NZ, .Next                                                    ; переход, если прежний рисунок уже отображается в той же позиции

                JR .DrawNew

.Recache        ; обновление кеша с сохранением координат прежней формы
                PUSH DE
                CALL CacheBlocks
                POP DE
.DrawNew        CALL World.SharedCode.Render.PipelineHexagons.ReplaceSnow
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
; первый показ отсутствующих снежинок без повторного XOR уже показанных
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX
; -----------------------------------------
Draw:           LD IX, Flakes
                LD B, SNOW_COUNT
.Loop           PUSH BC
                ; проверка необходимости первого показа или восстановления после обновления карты
                BIT 7, (IX + FSnowFlake.Shown)
                CALL Z, World.SharedCode.Render.PipelineHexagons.ReplaceSnow     ; вызов, если снежинка ещё не нарисована
                LD DE, FSnowFlake
                ADD IX, DE
                POP BC
                DJNZ .Loop
                RET
; -----------------------------------------
; XOR формы снежинки существующим рисованием точек дождя
; In:
;   IX - запись FSnowFlake
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
Shape:          ; чтение сохранённых экранных координат снежинки
                LD E, (IX + FSnowFlake.Position.X)
                LD D, (IX + FSnowFlake.Position.Y)

; -----------------------------------------
; XOR формы по явно переданным координатам для стирания прежнего положения
; In:
;   DE - экранная позиция, D по Y, E по X
;   IX - запись FSnowFlake с выбранной формой
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
ShapeAt:        ; выбор одной из трёх форм без полосок
                LD A, (IX + FSnowFlake.Shape)
                OR A
                LD HL, .Dot
                JR Z, .Draw                                                     ; переход, если снежинка рисуется точкой

                DEC A
                LD HL, .Plus
                JR Z, .Draw                                                     ; переход, если снежинка рисуется плюсиком

                LD HL, .Cube
.Draw           JP World.SharedScreen.Effects.Rain.DrawPattern

.Dot            DB 1, 0, 0                                                      ; точка, число пикселей и пара X, Y
.Plus           DB 5, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1                            ; плюсик 3 на 3, число пикселей и пары X, Y
.Cube           DB 4, 0, 0, 1, 0, 0, 1, 1, 1                                    ; квадрат 2 на 2, число пикселей и пары X, Y

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

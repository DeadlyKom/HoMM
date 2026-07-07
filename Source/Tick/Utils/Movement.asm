
                ifndef _TICK_UTILS_MOVEMENT_
                define _TICK_UTILS_MOVEMENT_
; -----------------------------------------
; подготовить DDA для движения на заданное расстояние
; In:
;   HL - знаковое расстояние по вертикали, в четвертях пикселя
;   DE - знаковое расстояние по горизонтали, в четвертях пикселя
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   поля DDA структуры FObjectCharacter подготовлены для движения к заданной точке
; Corrupt:
;   HL, DE, AF
; Note:
;   знаки расстояний сохраняются во флагах направлений, а длины хранятся положительными;
;   при равных длинах главной считается горизонтальная ось
; -----------------------------------------
SetLine:        XOR A
                LD (IX + FObjectCharacter.MovementFlags), A

                BIT 7, D
                JR Z, .PositiveX
                SET MOVEMENT_STEP_X_NEG_BIT, (IX + FObjectCharacter.MovementFlags)

                ; NEG DE
                XOR A
                SUB E
                LD E, A
                SBC A, A
                SUB D
                LD D, A

.PositiveX      BIT 7, H
                JR Z, .PositiveY
                SET MOVEMENT_STEP_Y_NEG_BIT, (IX + FObjectCharacter.MovementFlags)

                ; NEG HL
                XOR A
                SUB L
                LD L, A
                SBC A, A
                SUB H
                LD H, A

.PositiveY      PUSH HL
                OR A
                SBC HL, DE
                POP HL
                JR C, .MajorX
                JR Z, .MajorX

                SET MOVEMENT_MAJOR_Y_BIT, (IX + FObjectCharacter.MovementFlags)
                LD (IX + FObjectCharacter.MajorRemaining), HL
                LD (IX + FObjectCharacter.MajorLength), HL
                SRL H
                RR L
                LD (IX + FObjectCharacter.LineError), HL
                LD (IX + FObjectCharacter.MinorLength), DE
                RET

.MajorX         LD (IX + FObjectCharacter.MajorRemaining), DE
                LD (IX + FObjectCharacter.MajorLength), DE
                SRL D
                RR E
                LD (IX + FObjectCharacter.LineError), DE
                LD (IX + FObjectCharacter.MinorLength), HL
                RET
; -----------------------------------------
; повернуть персонажа на один шаг в направлении точки пути
; In:
;   HL - адрес FPath
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   Zero установлен, если персонаж уже смотрит в направлении пути;
;   Zero сброшен, если выполнен шаг поворота;
;   FObject.Sprite - обновлены направление и состояние поворота
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   функция выполняет не более одного шага поворота за вызов;
;   поворот является визуальным и не расходует бюджет движения
; -----------------------------------------
FacePath:       LD E, (IX + FObject.Position.X.High)
                LD D, (IX + FObject.Position.Y.High)
                CALL Character.DirectionPath
                LD B, (HL)
                LD C, (IX + FObjectCharacter.Super.Sprite)

                LD A, C
                RRA
                RRA
                RRA
                AND DIR_MASK
                SUB B
                RET Z

                CCF
                LD B, #00   ; NOP
                JR C, .Clockwise
                LD B, #3F   ; CCF
                NEG

.Clockwise      SUB #04
                JR NZ, .NotEqual
                SCF
.NotEqual       LD A, B
                LD (.Direction), A
.Direction      NOP                     ; NOP/CCF

                SBC A, A
                CCF
                ADC A, #00
                ADD A, A
                ADD A, A
                ADD A, A
                ADD A, C
                XOR C
                AND %00111000
                XOR C
                AND %00111111
                OR ANIM_STATE_TURN

                LD (IX + FObjectCharacter.Super.Sprite), A
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)
                LD A, #01
                OR A
                RET
; -----------------------------------------
; получить бюджет движения персонажа за один "мировой тик"
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   DE - бюджет движения за один "мировой тик"
; Corrupt:
;   DE
; Note:
;   функция должна сохранить IX, т.к. tick-код продолжает работать
;   с исходным FObjectCharacter после получения бюджета
; -----------------------------------------
GetCharacterMovementBudget:
                ; ToDo: временная реализация возвращает базовое значение MOVEMENT_DEFAULT_SPEED
                ;       в дальнейшем здесь должна появиться формула:
                ;           CharacterMovementBudget =
                ;               MOVEMENT_DEFAULT_SPEED
                ;             * CharacterSpeedScale
                ;             * SkillSpeedScale
                ;             * BuffSpeedScale
                ;             * DebuffSpeedScale

                LD DE, MOVEMENT_DEFAULT_SPEED
                RET
; -----------------------------------------
; добавить бюджет движения за пакет "мировых тиков" текущей cadence-эпохи
; In:
;   DE - бюджет движения персонажа за один "мировой тик"
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   FObjectCharacter.MovementPending - добавлен бюджет текущей cadence-эпохи
; Corrupt:
;   HL, DE, AF
; Note:
;   значение DE должно быть получено через GetCharacterMovementBudget
;   начисляемый бюджет масштабируется значением PlaybackScale
;   при переполнении MovementPending насыщается значением #FFFF
; -----------------------------------------
AddBudget:      LD A, (GameSession.WorldTimeCtrl + FWorldTimeControl.PlaybackScale)

                ; -----------------------------------------
                ; умножение DE на A
                ; In :
                ;   DE - множимое
                ;   A  - множитель
                ; Out :
                ;   HL - результат умножения DE * A
                ; Corrupt :
                ;   HL, F
                ; -----------------------------------------
                CALL Math.Mul16x8_16    ; (MUL_16x8_16)

                LD DE, (IX + FObjectCharacter.MovementPending)
                ADD HL, DE
                JR NC, .Store

                LD HL, #FFFF

.Store          LD (IX + FObjectCharacter.MovementPending), HL
                RET
; -----------------------------------------
; передать движению долю временного бюджета текущего cadence-прохода
; In:
;   A  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   DE - бюджет движения персонажа за один "мировой тик"
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   FObjectCharacter.MovementPending - уменьшен на переданную долю;
;   FObjectCharacter.MovementBudget - увеличен на переданную долю
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   значение DE должно быть получено через GetCharacterMovementBudget
;   передача выполняется, пока MovementPending содержит ранее начисленный бюджет
;   состояние активной фазы не проверяется, чтобы распределить бюджет по всей cadence-эпохе
;   дополнительные "мировые тики" при передаче бюджета не создаются
;   если доля превышает MovementPending, передаётся весь оставшийся бюджет
;   при переполнении MovementBudget насыщается значением #FFFF
; -----------------------------------------
TransferBudget: LD B, A                                                         ; сохранение относительного временного шага

                ; проверка наличия ранее начисленного бюджета движения
                LD HL, (IX + FObjectCharacter.MovementPending)
                LD A, H
                OR L
                RET Z                                                           ; выход, если нераспределённый бюджет отсутствует

                ; рассчитать долю бюджета для частоты текущего cadence-диапазона:
                ;   CadenceShare = (CharacterMovementSpeed * PlaybackScale) >> (2 - RelativeCadence),
                ;   где RelativeCadence: 0 - четверть, 1 - половина, 2 - весь бюджет cadence-эпохи
                EX DE, HL                                                       ; HL - скорость персонажа
                SRL H
                RR L
                SRL H
                RR L                                                            ; HL - четверть скорости персонажа
                INC B                                                           ; инкремент (отсчёт каденции начинается с нуля)
.ScaleCadence   DEC B
                JR Z, .ScaleTime
                ADD HL, HL                                                      ; умножение на два
                JR .ScaleCadence

.ScaleTime      LD A, (GameSession.WorldTimeCtrl + FWorldTimeControl.PlaybackScale)
                ifdef _DEBUG
                OR A
                DEBUG_BREAK_POINT_Z                                             ; произошла ошибка!
                endif

                EX DE, HL
                ; -----------------------------------------
                ; умножение DE на A
                ; In :
                ;   DE - множимое
                ;   A  - множитель
                ; Out :
                ;   HL - результат умножения DE * A
                ; Corrupt :
                ;   HL, F
                ; -----------------------------------------
                CALL Math.Mul16x8_16    ; (MUL_16x8_16)

                LD DE, (IX + FObjectCharacter.MovementPending)
                EX DE, HL
                OR A
                SBC HL, DE
                JR NC, .ShareFits

                ADD HL, DE
                EX DE, HL
                XOR A
                LD (IX + FObjectCharacter.MovementPending.High), A
                LD (IX + FObjectCharacter.MovementPending.Low), A
                JR .AddBudget

.ShareFits      LD (IX + FObjectCharacter.MovementPending), HL
.AddBudget      LD HL, (IX + FObjectCharacter.MovementBudget)
                ADD HL, DE
                JR NC, .Store
                LD HL, #FFFF
.Store          LD (IX + FObjectCharacter.MovementBudget), HL
                RET
; -----------------------------------------
; обновить стоимость DDA-шага по текущим координатам объекта
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   FObjectCharacter.EffectiveStepCost - итоговая стоимость одного DDA-шага
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   HextileID получается временно по координатам и не хранится в объекте
;   базовая стоимость поверхности получается со страницы карты
;   Pathfinding берётся из FCharacter владельца объекта
;
;   EffectiveStepCost =
;       ceil(SurfaceStepCost * PathfindingScale / 16)
;
;   ToDo:
;     добавить к формуле профиль проходимости, экипировку, бафы и дебафы
; -----------------------------------------
UpdateEffectiveStepCost:
                LD E, (IX + FObject.Position.X.High)
                LD D, (IX + FObject.Position.Y.High)
                EXX
                LD A, Page.Page1
                LD HL, BufferUtilities.GetSurfaceStepCostByCoord.Wrap
                ; получить базовую стоимость поверхности по координатам объекта
                CALL Func.CallAnotherPage
                EX AF, AF'

                PUSH IX                                                         ; сохранить адрес объекта
                LD E, A
                LD D, #00
                PUSH DE                                                         ; сохранить SurfaceStepCost

                ; получить уровень Pathfinding персонажа-владельца
                LD A, (IX + FObjectCharacter.CharacterID)
                CALL Character.Utilities.GetAdr.IX
                LD A, (IX + FCharacter.Skills.SecondarySkill.Pathfinding)

                ifdef _DEBUG
                ; проверка диапазона Pathfinding
                CP SKILL_LEVEL_MAX
                DEBUG_BREAK_POINT_NC                                            ; произошла ошибка!
                endif

                ; расчёт адреса таблице множителей
                LD HL, .ScaleTable
                ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A
                LD A, (HL)                                                      ; A - множитель PathfindingScale

                ; расчёт EffectiveStepCost = ceil(SurfaceStepCost * PathfindingScale / 16)
                POP DE                                                          ; DE - SurfaceStepCost
                CALL Math.Mul16x8_16
                LD DE, #000F
                ADD HL, DE                                                      ; добавить 15 для округления вверх при делении на 16
                SRL H
                RR L
                SRL H
                RR L
                SRL H
                RR L
                SRL H
                RR L

                POP IX                                                          ; восстановить адрес объекта
                LD A, L
                LD (IX + FObjectCharacter.EffectiveStepCost), A
                RET
.ScaleTable     ; таблица множителей стоимости шага от уровня Pathfinding       ; значения fixed point 4.4
                DB PATHFINDING_SCALE_NONE                                      ; SKILL_LEVEL_NONE
                DB PATHFINDING_SCALE_BASIC                                     ; SKILL_LEVEL_BASIC
                DB PATHFINDING_SCALE_ADVANCED                                  ; SKILL_LEVEL_ADVANCED
                DB PATHFINDING_SCALE_EXPERT                                    ; SKILL_LEVEL_EXPERT
; -----------------------------------------
; выполнить один шаг DDA, равный четверти пикселя по главной оси
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   FObject.Position - координаты смещены на один DDA-шаг
;   Carry сброшен, если движение продолжается;
;   Carry установлен, если заданная точка достигнута
; Corrupt:
;   HL, DE, AF, AF'
; Note:
;   за один вызов всегда выполняется шаг по главной оси;
;   шаг по вторичной оси выполняется при достижении порога ошибки DDA
; -----------------------------------------
Step:           ; проверка наличия оставшихся DDA-шагов до заданной точки
                LD HL, (IX + FObjectCharacter.MajorRemaining)
                LD A, L
                OR H
                JR Z, .Complete_                                                ; переход, если заданная точка уже достигнута
                DEC HL                                                          ; учёт выполняемого шага по главной оси
                LD (IX + FObjectCharacter.MajorRemaining), HL

                PUSH BC                                                         ; сохранение BC вызывающей функции

                ; проверка главной оси DDA и выполнение шага по ней
                BIT MOVEMENT_MAJOR_Y_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .MajorY                                                  ; переход, если главная ось Y
                CALL StepX                                                      ; выполнение шага по главной оси X
                JR .UpdateError                                                 ; переход к обновлению ошибки DDA
.MajorY         CALL StepY                                                      ; выполнение шага по главной оси Y
.UpdateError    ; определить необходимость шага по вторичной оси
                LD HL, (IX + FObjectCharacter.LineError)
                LD DE, (IX + FObjectCharacter.MinorLength)
                OR A                                                            ; сброс Carry перед вычитанием
                SBC HL, DE
                JR NC, .StoreError                                              ; переход, если накопленной ошибки недостаточно для шага по вторичной оси

                ; корректировка ошибки DDA
                LD DE, (IX + FObjectCharacter.MajorLength)
                ADD HL, DE
                LD (IX + FObjectCharacter.LineError), HL

                ; проверка вторичной оси DDA и выполнение шага по ней
                BIT MOVEMENT_MAJOR_Y_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .MinorX                                                  ; переход, если вторичная ось X
                CALL StepY                                                      ; выполнение шага по вторичной оси Y
                JR .CheckRemaining                                              ; переход к проверке завершения движения
.MinorX         CALL StepX                                                      ; выполнение шага по вторичной оси X
                JR .CheckRemaining                                              ; переход к проверке завершения движения

.StoreError     ; сохранение ошибки DDA без шага по вторичной оси
                LD (IX + FObjectCharacter.LineError), HL

.CheckRemaining ; проверить завершение движения после выполненного DDA-шага
                LD A, (IX + FObjectCharacter.MajorRemaining.Low)
                OR (IX + FObjectCharacter.MajorRemaining.High)
                JR Z, .Complete                                                 ; переход, если выполнен последний DDA-шаг
                POP BC
                OR A                                                            ; сброс Carry, движение продолжается
                RET
.Complete       POP BC                                                          ; восстановление регистра после последнего шага
.Complete_      SCF                                                             ; установка Carry, заданная точка достигнута
                RET
; -----------------------------------------
; выполнить один четвертьпиксельный шаг по горизонтали
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   FObject.Position.X - координата смещена на четверть пикселя в заданном направлении
;   FObjectCharacter.EffectiveStepCost - обновлена при переходе в соседний гекс
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   Position.X.Low хранит локальное положение в четвертях пикселя;
;   при пересечении границы изменяется Position.X.High и обновляется стоимость DDA-шага
; -----------------------------------------
StepX:          ; проверка направления движения по горизонтали
                BIT MOVEMENT_STEP_X_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .Negative                                                ; переход, если движение направлено влево

                ; шаг вправо внутри текущей горизонтальной координаты гекса
                LD A, (IX + FObject.Position.X.Low)
                INC A

                ; проверка перехода через правую границу гекса
                CP HEXTILE_SIZE_X << 5
                JR C, .Store                                                    ; переход, если граница гекса не пересечена

                ; переход через правую границу в соседнюю координату гекса
                XOR A
                LD (IX + FObject.Position.X.Low), A
                INC (IX + FObject.Position.X.High)
                JP UpdateEffectiveStepCost                                      ; обновить стоимость шага после перехода

.Store          LD (IX + FObject.Position.X.Low), A                             ; сохранить положение внутри текущего гекса
                RET

.Negative       ; шаг влево внутри текущей горизонтальной координаты гекса
                LD A, (IX + FObject.Position.X.Low)

                ; проверка перехода через левую границу гекса
                OR A
                JR NZ, .Decrement                                               ; переход, если граница гекса не пересечена

                ; переход через левую границу в соседнюю координату гекса
                DEC (IX + FObject.Position.X.High)
                LD A, (HEXTILE_SIZE_X << 5) - 1
                LD (IX + FObject.Position.X.Low), A
                JP UpdateEffectiveStepCost                                      ; обновить стоимость шага после перехода

.Decrement      DEC A                                                           ; сместить локальную координату влево
                LD (IX + FObject.Position.X.Low), A
                RET

; -----------------------------------------
; выполнить один четвертьпиксельный шаг по вертикали
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   FObject.Position.Y - координата смещена на четверть пикселя в заданном направлении
;   FObject.Position.X - скорректирована при переходе между смещёнными строками гексов
;   FObjectCharacter.EffectiveStepCost - обновлена при переходе в соседнюю строку гексов
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   Position.Y.Low хранит локальное положение в четвертях пикселя;
;   при смене строки локальная координата X смещается на половину ширины гекса
; -----------------------------------------
StepY:          ; проверка направления движения по вертикали
                BIT MOVEMENT_STEP_Y_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .Negative                                               ; переход, если движение направлено вверх

                ; шаг вниз внутри текущей строки гекса
                LD A, (IX + FObject.Position.Y.Low)
                INC A

                ; проверка перехода в следующую строку гексов
                CP (HEXTILE_SIZE_Y - 1) << 5
                JR C, .Store                                                    ; переход, если граница строки не пересечена

                ; переход в следующую строку гексов
                XOR A
                LD (IX + FObject.Position.Y.Low), A
                INC (IX + FObject.Position.Y.High)

                ; проверка чётности новой строки для компенсации её горизонтального смещения
                BIT 0, (IX + FObject.Position.Y.High)
                JR NZ, .DownOddRow                                              ; переход, если новая строка нечётная
                CALL AddHalfX                                                   ; чётная строка смещена вправо
                JP UpdateEffectiveStepCost                                      ; обновить стоимость шага после перехода
.DownOddRow     CALL SubHalfX                                                   ; нечётная строка смещена влево
                JP UpdateEffectiveStepCost                                      ; обновить стоимость шага после перехода

.Store          LD (IX + FObject.Position.Y.Low), A                            ; сохранить положение внутри текущей строки
                RET

.Negative       ; шаг вверх внутри текущей строки гекса
                LD A, (IX + FObject.Position.Y.Low)

                ; проверка перехода в предыдущую строку гексов
                OR A
                JR NZ, .Decrement                                               ; переход, если граница строки не пересечена

                ; переход в предыдущую строку гексов
                DEC (IX + FObject.Position.Y.High)
                LD A, ((HEXTILE_SIZE_Y - 1) << 5) - 1
                LD (IX + FObject.Position.Y.Low), A

                ; проверка чётности новой строки для компенсации её горизонтального смещения
                BIT 0, (IX + FObject.Position.Y.High)
                JR NZ, .UpOddRow                                                ; переход, если новая строка нечётная
                CALL AddHalfX                                                   ; чётная строка смещена вправо
                JP UpdateEffectiveStepCost                                      ; обновить стоимость шага после перехода
.UpOddRow       CALL SubHalfX                                                   ; нечётная строка смещена влево
                JP UpdateEffectiveStepCost                                      ; обновить стоимость шага после перехода

.Decrement      DEC A                                                           ; сместить локальную координату вверх
                LD (IX + FObject.Position.Y.Low), A
                RET

; -----------------------------------------
; сместить локальную координату X вправо на половину ширины гекса
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   FObject.Position.X - локальная координата смещена вправо на половину ширины гекса
; Corrupt:
;   AF
; Note:
;   используется для компенсации горизонтального положения при смене строки гексов;
;   при пересечении правой границы увеличивается Position.X.High
; -----------------------------------------
AddHalfX:       LD A, (IX + FObject.Position.X.Low)
                ADD A, HEXTILE_SIZE_X << 4

                ; проверка перехода через правую границу гекса
                CP HEXTILE_SIZE_X << 5
                JR C, .Store                                                    ; переход, если смещение осталось внутри текущей координаты X

                ; перенос половины ширины через правую границу гекса
                SUB HEXTILE_SIZE_X << 5
                INC (IX + FObject.Position.X.High)
.Store          LD (IX + FObject.Position.X.Low), A
                RET

; -----------------------------------------
; сместить локальную координату X влево на половину ширины гекса
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   FObject.Position.X - локальная координата смещена влево на половину ширины гекса
; Corrupt:
;   AF
; Note:
;   используется для компенсации горизонтального положения при смене строки гексов;
;   при пересечении левой границы уменьшается Position.X.High
; -----------------------------------------
SubHalfX:       LD A, (IX + FObject.Position.X.Low)

                ; проверка перехода через левую границу гекса после смещения
                SUB HEXTILE_SIZE_X << 4
                JR NC, .Store                                                   ; переход, если смещение осталось внутри текущей координаты X

                ; перенос половины ширины через левую границу гекса
                ADD A, HEXTILE_SIZE_X << 5
                DEC (IX + FObject.Position.X.High)
.Store          LD (IX + FObject.Position.X.Low), A
                RET

                endif ; ~_TICK_UTILS_MOVEMENT_

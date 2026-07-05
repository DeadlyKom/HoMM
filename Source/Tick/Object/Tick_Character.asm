
                ifndef _TICK_OBJECT_HERO_
                define _TICK_OBJECT_HERO_
; -----------------------------------------
; обработчик тика объекта "персонаж"
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
;   C  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   F' - Carry установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   все регистры, кроме IX
; Note:
;   анимация должна меняться после готовности предыдущего кадра
;   код расположен в странице 0
; ----------------------------------------
Character:      ; сохранить параметры текущего cadence-прохода
                LD A, C
                LD (Move.TransferMovementBudget.RelativeCadence), A
                EX AF, AF'
                LD A, #00
                ADC A, A                                                       ; 0 - обычный cadence-проход, 1 - доставлен "мировой тик"
                LD (Move.WorldTickFlag), A

                ; LD A, (GameSession.PeriodTick + FTick.Hero)
                ; CP DURATION.CHARACTER_TICK
                ; RET NZ                                                          ; выход, если счётчик не обнулён

                ; проверка перемещения героя
                LD C, (IX + FObjectCharacter.Super.Sprite)
                BIT ANIM_STATE_BIT, C
                JR NZ, Move                                                     ; переход, если герой движется

                ; проверка наличия пути
                LD A, (IX + FObjectCharacter.PathID)
                CP PATH_ID_NONE
                RET Z                                                           ; выход, если нет пути

                ; расчёт адреса текущей FPath
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD L, A
                SET 7, L    ; Adr.HeroPath начинается с 0x80
                LD H, HIGH Adr.HeroPath

                ; определение направление спрайта
                PUSH HL
                LD E, (IX + FObject.Position.X.High)
                LD D, (IX + FObject.Position.Y.High)
                CALL Character.DirectionPath
                LD B, (HL)                                                      ; направление
                ; определение расстояние пути
                POP DE
                
                ; --------------------------------------------------------------
                ; проверка необходимости поворота в направление движения
                LD C, (IX + FObjectCharacter.Super.Sprite)

                ; направление спрайта
                LD A, C
                RRA
                RRA
                RRA
                AND DIR_MASK

                ; сравнение напрвлений
                SUB B
                JR Z, Move.Init                                                     ; перехд, если направление совподает, поворот не требуется
                
                ; требуется поворот в направлдение движения
                CCF                                                             ; меняем знак

                LD B, #00   ; NOP
                JR C, .Clockwise                                                ; переход, если поворот против часовой стрелке

                ; вращение по часовой стрелке
                LD B, #3F   ; CCF
                NEG

.Clockwise      ; проверка на кратчайший путь поворота
                SUB #04
                JR NZ, .NotEqual                                                ; переход, если путь поворота не одинаковый

                ; путь поворота по часовой и против равнозначный
                SCF                                                             ; выбираем поворот против часовой стрелке
.NotEqual       LD A, B
                LD (.Direction), A
.Direction      NOP                     ; NOP/CCF

.Rotation       ; шаг поворота (-1 или 1), в зависимости от флага переполнения
                SBC A, A
                CCF
                ADC A, #00
Turn:           ; --------------------------------------------------------------
                ; расчёт направления вращения
                ; положительная по часовой стрелка, иначе против часовой стрелке

                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8

                ADD A, C
                XOR C
                AND %00111000
                XOR C
                AND %00111111
                OR ANIM_STATE_TURN

                LD (IX + FObjectCharacter.Super.Sprite), A
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)                      ; установить флаг, объект требуется обновиться
                RET                                                             ; поворот не расходует и не запрашивает "мировые тики"
Move.Init       CALL SetDistance
                CALL Move.UpdateHextileID                                      ; определить поверхность начального гекса
Move            ; --------------------------------------------------------------
                ; перемещение

.WorldTickFlag  EQU $+1
                LD A, #00
                OR A
                CALL NZ, Move.AddMovementBudget                                 ; временной бюджет начисляется один раз за cadence-эпоху
                CALL Move.TransferMovementBudget                                ; передать движению долю пакета текущего cadence-прохода

.StepLoop       ; стоимость всегда читается из таблицы по текущему типу поверхности
                LD L, (IX + FObjectCharacter.HextileID)
                LD H, HIGH Adr.SurfPass
                LD E, (HL)
                LD D, #00
                LD A, E
                OR A
                JR Z, .Animation                                                ; нулевая стоимость запрещает движение по поверхности

                LD HL, (IX + FObjectCharacter.MovementBudget)
                OR A
                SBC HL, DE
                JR C, .Animation                                                ; бюджета недостаточно для четвертьпиксельного шага
                LD (IX + FObjectCharacter.MovementBudget), HL

                CALL Move.Step
                JR C, .Animation                                                ; точка назначения достигнута
                JR .StepLoop                                                    ; стоимость могла измениться после перехода в новый гекс

                ; ToDo: после перемещения пересчитать номер чанка объекта;
                ;       при смене чанка перенести объект через ChunkArray.Move,
                ;       затем установить CadencePassID диапазона нового чанка (смотри спавн объекта)

.Animation      ; --------------------------------------------------------------
                ; установить состояние перемещения героя,
                ; изменить кадр спрайта
                LD C, (IX + FObjectCharacter.Super.Sprite)
                LD A, C
                INC A
                XOR C
                AND %00000111
                XOR C
                AND %00111111
                OR ANIM_STATE_MOVE
                LD (IX + FObjectCharacter.Super.Sprite), A
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)                      ; установить флаг, объект требуется обновиться
                ; --------------------------------------------------------------
                ; проверка достижения заданной точки
                LD A, (IX + FObjectCharacter.MajorRemaining.Low)
                OR (IX + FObjectCharacter.MajorRemaining.High)

                JP NZ, RequestNextWorldTick                                     ; продолжить перемещение на следующем "мировом тике"

                ; герой достиг точки назначения, принудительно назначим ему конечную точку пути

                ; расчёт адреса текущей FPath
                LD A, (IX + FObjectCharacter.PathID)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD E, A
                SET 7, E    ; Adr.HeroPath начинается с 0x80
                LD D, HIGH Adr.HeroPath
                LD A, (DE) ; FPath.HexCoord.X
                LD (IX + FObject.Position.X.High), A
                LD (IX + FObject.Position.X.Low), HEXTILE_SIZE_X << 4           ; середина гексагона
                INC E
                LD A, (DE) ; FPath.HexCoord.Y
                LD (IX + FObject.Position.Y.High), A
                LD (IX + FObject.Position.Y.Low), HEXTILE_SIZE_Y << 4           ; середина гексагона

                ; следующая точка пути
                DEC (IX + FObjectCharacter.PathID)
                RES ANIM_STATE_BIT, (IX + FObjectCharacter.Super.Sprite)

                ; проверка завершения пути
                LD A, (IX + FObjectCharacter.PathID)
                CP PATH_ID_NONE
                JR NZ, .NextPath                                                ; переход, если путь не закончился

                ; завершить действие только для выбранного игроком персонажа
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CP (IX + FObjectCharacter.CharacterID)
                RET NZ

                LD A, (GameState.PlayerActions + FPlayerActions.Action)
                CP PLAYER_ACTION_HERO_MOVEMENT
                RET NZ

                CALL WorldTime.StopAdvance                                     ; удалить следующий "мировой тик", заранее запрошенный во время движения

                ; сброс действия игрока
                XOR A                                                           ; PLAYER_ACTION_NONE
                LD (GameState.PlayerActions + FPlayerActions.Action), A
                RET

.NextPath       ; расчёт адреса текущей FPath
                LD A, (IX + FObjectCharacter.PathID)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD E, A
                SET 7, E    ; Adr.HeroPath начинается с 0x80
                LD D, HIGH Adr.HeroPath
                CALL SetDistance
                JP RequestNextWorldTick

SetDistance:    ; рассчитать расстояние от объекта до центра точки пути
                ;   DE - адрес хранения FPath
                ;   IX - адрес структуры объекта (FObjectCharacter)
                ; Out:
                ;   HL - знаковое расстояние по вертикали, в четвертях пикселя
                ;   DE - знаковое расстояние по горизонтали, в четвертях пикселя
                CALL Character.DistancePath

; -----------------------------------------
; подготовить DDA для движения на заданное расстояние
; In:
;   HL - знаковое расстояние по вертикали, в четвертях пикселя
;   DE - знаковое расстояние по горизонтали, в четвертях пикселя
;   IX - адрес структуры объекта (FObjectCharacter)
; Note:
;   источник конечной точки не имеет значения: центр гекса, WayPoint или
;   произвольная локальная точка используют одно и то же состояние DDA
; -----------------------------------------
SetMovementLine:
                RES_FLAG_MODIFY RequestEvent.Flag                              ; сброс запроса события от предыдущего сегмента
                XOR A
                LD (IX + FObjectCharacter.MovementFlags), A

                ; модуль расстояния по X и направление шага
                BIT 7, D
                JR Z, .PositiveX
                SET MOVEMENT_STEP_X_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
                XOR A
                SUB E
                LD E, A
                SBC A, A
                SUB D
                LD D, A

.PositiveX      ; модуль расстояния по Y и направление шага
                BIT 7, H
                JR Z, .PositiveY
                SET MOVEMENT_STEP_Y_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
                XOR A
                SUB L
                LD L, A
                SBC A, A
                SUB H
                LD H, A

.PositiveY      ; выбор главной оси: при равных расстояниях используется X
                PUSH HL
                OR A
                SBC HL, DE
                POP HL
                JR C, .MajorX
                JR Z, .MajorX

                ; Y - главная ось, X - вторичная
                SET MOVEMENT_MAJOR_Y_BIT, (IX + FObjectCharacter.MovementFlags)
                LD (IX + FObjectCharacter.MajorRemaining), HL
                LD (IX + FObjectCharacter.MajorLength), HL
                SRL H
                RR L
                LD (IX + FObjectCharacter.LineError), HL
                PUSH DE
                POP HL
                LD (IX + FObjectCharacter.MinorLength), HL
                RET

.MajorX         ; X - главная ось, Y - вторичная
                PUSH HL
                PUSH DE
                POP HL
                LD (IX + FObjectCharacter.MajorRemaining), HL
                LD (IX + FObjectCharacter.MajorLength), HL
                SRL H
                RR L
                LD (IX + FObjectCharacter.LineError), HL
                POP HL
                LD (IX + FObjectCharacter.MinorLength), HL
                RET

; -----------------------------------------
; запрос следующего "мирового тика" для продолжающегося действия игрока
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
; Corrupt:
;   HL, AF
; Note:
;   объекты AI не управляют течением времени, но перемещаются во время
;   "мировых тиков", запрошенных действиями игрока или другими системами
; -----------------------------------------
RequestNextWorldTick:
                LD A, (GameState.PlayerActions + FPlayerActions.Action)
                CP PLAYER_ACTION_HERO_MOVEMENT
                RET NZ                                                          ; выход, если игрок не выполняет перемещение

                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CP (IX + FObjectCharacter.CharacterID)
                RET NZ                                                          ; выход, если это не выбранный игроком персонаж

                LD HL, WORLD_TICK_PLAYBACK_SPEED
                JP WorldTime.RequestAdvance

; -----------------------------------------
; добавить бюджет движения за пакет "мировых тиков" текущей cadence-эпохи
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
; Corrupt:
;   HL, DE, AF
; Note:
;   базовая поверхность даёт два четвертьпиксельных шага на единицу SpeedHero
; -----------------------------------------
Move.AddMovementBudget:
                LD A, (GameConfig.SpeedHero)
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8 = MOVEMENT_DEFAULT_COST * 2
                PUSH HL
                POP DE
                LD A, (GameSession.WorldTimeCtrl + FWorldTimeControl.Delta)
                CALL Math.Mul16x8_16
                LD DE, (IX + FObjectCharacter.MovementPending)
                ADD HL, DE
                JR NC, .Store
                LD HL, #FFFF                                                    ; защита от переполнения накопленного бюджета
.Store          LD (IX + FObjectCharacter.MovementPending), HL
                RET

; -----------------------------------------
; передать движению долю временного бюджета текущего cadence-прохода
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   четыре доли x1, две доли x2 и одна доля x4 передают одинаковый суммарный
;   бюджет за cadence-эпоху; остаток меньше стоимости шага сохраняется
; -----------------------------------------
Move.TransferMovementBudget:
                LD A, (GameConfig.SpeedHero)
                LD L, A
                LD H, #00
                ADD HL, HL                                                    ; x2, четверть полного бюджета обычной поверхности
.RelativeCadence EQU $+1
                LD B, #00                                                       ; 0 - x1, 1 - x2, 2 - x4
                INC B
.ScaleCadence   DEC B
                JR Z, .ScaleTime
                ADD HL, HL
                JR .ScaleCadence

.ScaleTime      PUSH HL
                POP DE
                LD A, (GameSession.WorldTimeCtrl + FWorldTimeControl.Delta)
                OR A
                RET Z
                CALL Math.Mul16x8_16                                            ; доля бюджета с учётом скорости игрового времени
                PUSH HL
                POP BC                                                          ; BC - максимальная передаваемая доля

                LD HL, (IX + FObjectCharacter.MovementPending)
                OR A
                SBC HL, BC
                JR NC, .ShareFits

                ; ожидающий бюджет меньше расчётной доли - передать его целиком
                ADD HL, BC                                                      ; восстановить исходный MovementPending
                PUSH HL
                POP DE                                                          ; DE - передаваемый бюджет
                LD HL, #0000
                LD (IX + FObjectCharacter.MovementPending), HL
                JR .AddBudget

.ShareFits      LD (IX + FObjectCharacter.MovementPending), HL
                PUSH BC
                POP DE                                                          ; DE - передаваемая доля

.AddBudget      LD HL, (IX + FObjectCharacter.MovementBudget)
                ADD HL, DE
                JR NC, .Store
                LD HL, #FFFF
.Store          LD (IX + FObjectCharacter.MovementBudget), HL
                RET

; -----------------------------------------
; обновить тип поверхности по текущим координатам объекта
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
; Corrupt:
;   HL, DE, AF, AF'
; Note:
;   карта читается со страницы 1, стоимость остаётся в таблице страницы 0
; -----------------------------------------
Move.UpdateHextileID:
                LD E, (IX + FObject.Position.X.High)
                LD D, (IX + FObject.Position.Y.High)
                EXX
                LD A, Page.Page1
                LD HL, BufferUtilities.GetHextileIDByCoord.Wrap
                CALL Func.CallAnotherPage
                EX AF, AF'
                LD (IX + FObjectCharacter.HextileID), A
                RET

; -----------------------------------------
; выполнить один шаг DDA, равный четверти пикселя по главной оси
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   Carry установлен, если заданная точка достигнута
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
Move.Step:      PUSH BC
                LD HL, (IX + FObjectCharacter.MajorRemaining)
                LD A, L
                OR H
                JR Z, .Complete

                DEC HL
                LD (IX + FObjectCharacter.MajorRemaining), HL

                ; шаг по главной оси
                BIT MOVEMENT_MAJOR_Y_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .MajorY
                CALL Move.StepX
                JR .UpdateError
.MajorY         CALL Move.StepY

.UpdateError    ; определить необходимость шага по вторичной оси
                LD HL, (IX + FObjectCharacter.LineError)
                LD DE, (IX + FObjectCharacter.MinorLength)
                OR A
                SBC HL, DE
                JR NC, .StoreError

                LD DE, (IX + FObjectCharacter.MajorLength)
                ADD HL, DE
                LD (IX + FObjectCharacter.LineError), HL

                BIT MOVEMENT_MAJOR_Y_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .MinorX
                CALL Move.StepY
                JR .CheckRemaining
.MinorX         CALL Move.StepX
                JR .CheckRemaining

.StoreError     LD (IX + FObjectCharacter.LineError), HL

.CheckRemaining LD A, (IX + FObjectCharacter.MajorRemaining.Low)
                OR (IX + FObjectCharacter.MajorRemaining.High)
                JR Z, .Complete
                POP BC
                OR A                                                            ; сброс Carry
                RET

.Complete       POP BC
                SCF
                RET

; -----------------------------------------
; выполнить один четвертьпиксельный шаг по горизонтали
; -----------------------------------------
Move.StepX:     BIT MOVEMENT_STEP_X_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .Negative

                LD A, (IX + FObject.Position.X.Low)
                INC A
                CP HEXTILE_SIZE_X << 5
                JR C, .Store
                XOR A
                LD (IX + FObject.Position.X.Low), A
                INC (IX + FObject.Position.X.High)
                CALL Move.UpdateHextileID
                JP RequestEvent

.Store          LD (IX + FObject.Position.X.Low), A
                RET

.Negative       LD A, (IX + FObject.Position.X.Low)
                OR A
                JR NZ, .Decrement
                DEC (IX + FObject.Position.X.High)
                LD A, (HEXTILE_SIZE_X << 5) - 1
                LD (IX + FObject.Position.X.Low), A
                CALL Move.UpdateHextileID
                JP RequestEvent

.Decrement      DEC A
                LD (IX + FObject.Position.X.Low), A
                RET

; -----------------------------------------
; выполнить один четвертьпиксельный шаг по вертикали
; -----------------------------------------
Move.StepY:     BIT MOVEMENT_STEP_Y_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .Negative

                ; смещение вниз
                LD A, (IX + FObject.Position.Y.Low)
                INC A
                CP (HEXTILE_SIZE_Y - 1) << 5
                JR C, .Store

                XOR A
                LD (IX + FObject.Position.Y.Low), A
                INC (IX + FObject.Position.Y.High)

                ; при смене строки сохранить глобальную координату X
                BIT 0, (IX + FObject.Position.Y.High)
                JR NZ, .DownOddRow
                CALL Move.AddHalfX
                CALL Move.UpdateHextileID
                JP RequestEvent
.DownOddRow     CALL Move.SubHalfX
                CALL Move.UpdateHextileID
                JP RequestEvent

.Store          LD (IX + FObject.Position.Y.Low), A
                RET

.Negative       ; смещение вверх
                LD A, (IX + FObject.Position.Y.Low)
                OR A
                JR NZ, .Decrement

                DEC (IX + FObject.Position.Y.High)
                LD A, ((HEXTILE_SIZE_Y - 1) << 5) - 1
                LD (IX + FObject.Position.Y.Low), A

                ; при смене строки сохранить глобальную координату X
                BIT 0, (IX + FObject.Position.Y.High)
                JR NZ, .UpOddRow
                CALL Move.AddHalfX
                CALL Move.UpdateHextileID
                JP RequestEvent
.UpOddRow       CALL Move.SubHalfX
                CALL Move.UpdateHextileID
                JP RequestEvent

.Decrement      DEC A
                LD (IX + FObject.Position.Y.Low), A
                RET

; -----------------------------------------
; сместить локальную координату X вправо на половину ширины гекса
; -----------------------------------------
Move.AddHalfX:  LD A, (IX + FObject.Position.X.Low)
                ADD A, HEXTILE_SIZE_X << 4
                CP HEXTILE_SIZE_X << 5
                JR C, .Store
                SUB HEXTILE_SIZE_X << 5
                INC (IX + FObject.Position.X.High)
.Store          LD (IX + FObject.Position.X.Low), A
                RET

; -----------------------------------------
; сместить локальную координату X влево на половину ширины гекса
; -----------------------------------------
Move.SubHalfX:  LD A, (IX + FObject.Position.X.Low)
                SUB HEXTILE_SIZE_X << 4
                JR NC, .Store
                ADD A, HEXTILE_SIZE_X << 5
                DEC (IX + FObject.Position.X.High)
.Store          LD (IX + FObject.Position.X.Low), A
                RET
RequestEvent    ; запрос на создание ивента
.Flag           FLAG_MODIFY 0
                RET C                                                           ; выход, если ивент активирован
                SET_FLAG_MODIFY RequestEvent.Flag                               ; установка флага создания ивента

                ; инициализация события
                LD IY, Adr.EventBuffer
                LD (IY + FEventReconnaissance.Super.Flags), EVENT_BEFORE_RENDER | EVENT_LIFETIME_CONDITION
                LD (IY + FEventReconnaissance.Super.Page), Page.Page1
                LD (IY + FEventReconnaissance.Super.Function + 0), LOW BufferUtilities.Reconnaissance.Event
                LD (IY + FEventReconnaissance.Super.Function + 1), HIGH BufferUtilities.Reconnaissance.Event
                LD A, (IX + FObjectCharacter.CharacterID)
                LD (IY + FEventReconnaissance.CharacterID), A

                ; расчёт адреса текущей FPath
                LD A, (IX + FObjectCharacter.PathID)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, A
                SET 7, C    ; Adr.HeroPath начинается с 0x80
                LD B, HIGH Adr.HeroPath
                LD A, (BC)
                LD (IY + FEventReconnaissance.Position.X), A
                INC C
                LD A, (BC)
                LD (IY + FEventReconnaissance.Position.Y), A
                JP Event.Add

                endif ; ~_TICK_OBJECT_HERO_

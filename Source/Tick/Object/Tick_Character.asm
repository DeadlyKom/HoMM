
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
                LD (Move.RelativeCadence), A
                EX AF, AF'
                LD A, #00
                ADC A, A                                                       ; 0 - обычный cadence-проход, 1 - доставлен "мировой тик"
                LD (Move.WorldTickFlag), A

                ; проверка перемещения героя
                LD C, (IX + FObjectCharacter.Super.Sprite)
                BIT ANIM_STATE_BIT, C
                JR NZ, Move                                                     ; переход, если герой движется

                ; проверка наличия пути
                LD A, (IX + FObjectCharacter.PathID)
                CP PATH_ID_NONE
                RET Z                                                           ; выход, если путь отсутствует

                ; расчёт адреса текущей FPath
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD L, A
                SET 7, L    ; Adr.HeroPath начинается с 0x80
                LD H, HIGH Adr.HeroPath

                ; бесплатный поворот к точке пути
                PUSH HL
                CALL Tick.Utils.Movement.FacePath
                POP DE
                RET NZ

                ; после поворота выбранный игроком персонаж запрашивает первый пакет времени
                LD A, (Move.WorldTickFlag)
                OR A
                JP NZ, Move.Init
                JP RequestNextWorldTick
Move.Init       CALL SetDistance
                CALL Tick.Utils.Movement.UpdateHextileID                        ; определить поверхность начального гекса
Move            ; --------------------------------------------------------------
                ; перемещение

.WorldTickFlag  EQU $+1
                LD A, #00
                OR A
                CALL NZ, Tick.Utils.Movement.AddBudget                          ; временной бюджет начисляется один раз за cadence-эпоху
.RelativeCadence EQU $+1
                LD A, #00
                CALL Tick.Utils.Movement.TransferBudget                        ; передать движению долю пакета текущего cadence-прохода

                LD A, (IX + FObject.Position.X.High)
                LD (.PreviousHexX), A
                LD A, (IX + FObject.Position.Y.High)
                LD (.PreviousHexY), A

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

                CALL Tick.Utils.Movement.Step
                JR C, .Animation                                                ; точка назначения достигнута
                JR .StepLoop                                                    ; стоимость могла измениться после перехода в новый гекс

                ; ToDo: после перемещения пересчитать номер чанка объекта;
                ;       при смене чанка перенести объект через ChunkArray.Move,
                ;       затем установить CadencePassID диапазона нового чанка (смотри спавн объекта)

.Animation      ; --------------------------------------------------------------
                LD A, (IX + FObject.Position.X.High)
.PreviousHexX   EQU $+1
                CP #00
                JR NZ, .RequestEvent
                LD A, (IX + FObject.Position.Y.High)
.PreviousHexY   EQU $+1
                CP #00
                JR Z, .AnimationState
.RequestEvent   CALL RequestEvent                                               ; игрок перешёл в другой гекс

.AnimationState ; установить состояние перемещения героя,
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
                RES_FLAG_MODIFY RequestEvent.Flag                              ; сброс запроса события предыдущего сегмента
                JP Tick.Utils.Movement.SetLine

; запрос следующего "мирового тика" для продолжающегося действия игрока
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
; Corrupt:
;   HL, AF
; -----------------------------------------
RequestNextWorldTick:
                LD A, (GameState.PlayerActions + FPlayerActions.Action)
                CP PLAYER_ACTION_HERO_MOVEMENT
                RET NZ                                                          ; выход, если игрок не выполняет перемещение

                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CP (IX + FObjectCharacter.CharacterID)
                RET NZ                                                          ; выход, если это не выбранный игроком персонаж

                LD A, (GameConfig.PlaybackSpeed)
                ifdef _DEBUG
                OR A
                DEBUG_BREAK_POINT_Z                                             ; произошла ошибка!
                endif
                LD L, A
                LD H, #00
                JP WorldTime.RequestAdvance

RequestEvent    ; запрос на создание ивента
.Flag           FLAG_MODIFY 0
                RET C                                                           ; выход, если ивент активирован
                SET_FLAG_MODIFY RequestEvent.Flag                               ; установка флага создания ивента

                ; расчёт адреса текущей FPath
                LD A, (IX + FObjectCharacter.PathID)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD C, A
                SET 7, C    ; Adr.HeroPath начинается с 0x80
                LD B, HIGH Adr.HeroPath
                LD A, (BC)
                LD E, A
                INC C
                LD A, (BC)
                LD D, A
                JP Tick.Utils.Reconnaissance.Request

                endif ; ~_TICK_OBJECT_HERO_

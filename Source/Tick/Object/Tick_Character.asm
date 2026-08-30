                ifndef _TICK_OBJECT_HERO_
                define _TICK_OBJECT_HERO_
; -----------------------------------------
; обработчик тика объекта "персонаж"
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
;   C  - диапазон cadence: 0 - 1/2, 1 - 1/4, 2 - 1/8
;   F' - флаг переполнения установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   все регистры, кроме IX
; Note:
;   анимация должна меняться после готовности предыдущего кадра
;   ℹ️ код расположен в странице 0
; ----------------------------------------
Character:      ; сохранить параметры текущего cadence-прохода
                LD A, C
                LD (Move.RelativeCadence), A
                EX AF, AF'
                CALC_INV_FLAG_MODIFY                                            ; определение флага
                                                                                ; 0 - активная фаза "мирового тика", 1 - обычный cadence-проход
                APPLY_FLAG_MODIFY Character.WorldTickFlag                       ; применить флаг
                APPLY_FLAG_MODIFY Move.WorldTickFlag_                           ; применить флаг

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

                ; начать движение только в активной фазе "мирового тика"
.WorldTickFlag  FLAG_INV_MODIFY 0
                RET C                                                           ; выход, если активная фаза "мирового тика" отсутствует

Move.Init       CALL SetDistance
                CALL Tick.Utils.Movement.UpdateEffectiveStepCost                ; рассчитать стоимость шага начального гекса

Move            ; --------------------------------------------------------------
                ; перемещение

                CALL Tick.Utils.Movement.GetCharacterMovementBudget             ; получить бюджет движения за один "мировой тик"

.WorldTickFlag_ FLAG_INV_MODIFY 0
                CALL NC, Tick.Utils.Movement.AddBudget                          ; временной бюджет начисляется один раз за cadence-эпоху

                CALL Tick.Utils.Movement.GetCharacterMovementBudget             ; получить бюджет движения за один "мировой тик"

.RelativeCadence EQU $+1
                LD A, #00
                CALL Tick.Utils.Movement.TransferBudget                         ; передать движению долю пакета текущего cadence-прохода

                LD A, (IX + FObject.Position.X.High)
                LD (.PreviousHexX), A
                LD A, (IX + FObject.Position.Y.High)
                LD (.PreviousHexY), A

.StepLoop       ; чтение рассчитанной стоимости DDA-шага для текущего участка маршрута
                LD A, (IX + FObjectCharacter.Movement.Flags)
                AND MOVEMENT_STEP_COST_MASK

                ; проверка возможности движения по текущему участку маршрута
                JR Z, .Animation                                                ; нулевая стоимость запрещает движение по поверхности
                
                ; стоимость шага
                LD E, A
                LD D, #00

                LD HL, (IX + FObjectCharacter.MovementBudget)
                SBC HL, DE
                JR C, .Animation                                                ; бюджета недостаточно для четвертьпиксельного шага
                LD (IX + FObjectCharacter.MovementBudget), HL

                CALL Tick.Utils.Movement.Step
                JR C, .Animation                                                ; точка назначения достигнута
                JR .StepLoop                                                    ; стоимость могла измениться после перехода в новый гекс

.Animation      ; --------------------------------------------------------------
                CALL Object.Utilities.UpdateChunkByPosition                     ; синхронизация чанка объекта после фактического движения

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
                SET OBJECT_DIRTY_BIT, (IX + FObject.FastFlags)                  ; установить флаг, объект требуется обновить

                ; проверка достижения заданной точки
                LD A, (IX + FObjectCharacter.Movement.RemainingSteps.Low)
                OR (IX + FObjectCharacter.Movement.RemainingSteps.High)
                RET NZ                                                          ; выход, если продолжить перемещение в следующем cadence-проходе

                ; герой достиг точки назначения,
                ; принудительно назначить ему конечную точку пути

                ; расчёт адреса текущей FPath
                LD A, (IX + FObjectCharacter.PathID)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD E, A
                SET 7, E    ; Adr.HeroPath начинается с 0x80
                LD D, HIGH Adr.HeroPath

                LD A, (DE)                                                      ; FPath.HexCoord.X
                LD (IX + FObject.Position.X.High), A
                LD (IX + FObject.Position.X.Low), HEXTILE_SIZE_X << 4           ; середина гексагона

                INC E
                LD A, (DE)                                                      ; FPath.HexCoord.Y
                LD (IX + FObject.Position.Y.High), A
                LD (IX + FObject.Position.Y.Low), HEXTILE_SIZE_Y << 4           ; середина гексагона

                CALL Object.Utilities.UpdateChunkByPosition                     ; синхронизация чанка после фиксации в конечной точке сегмента

                ; завершить текущую точку пути
                RES ANIM_STATE_BIT, (IX + FObjectCharacter.Super.Sprite)

                ; локальный нулевой элемент является последним в каждом слоте
                LD A, (IX + FObjectCharacter.PathID)
                AND HERO_PATH_SLOT_INDEX_MASK
                JR Z, .PathComplete                                             ; переход, если достигнут последний элемент текущего слота

                ; перейти к предыдущему элементу внутри текущего слота
                DEC (IX + FObjectCharacter.PathID)
                JR .NextPath                                                    ; перейти к следующей точке того же слота

.PathComplete   ; установить признак отсутствия активного пути
                LD (IX + FObjectCharacter.PathID), PATH_ID_NONE
                RES CHARACTER_ACTION_BIT, (IX + FObjectCharacter.CharacterID)   ; сброс флага, выполнение действия завершённо
                RET

.NextPath       ; расчёт адреса текущей FPath
                LD A, (IX + FObjectCharacter.PathID)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD E, A
                SET 7, E    ; Adr.HeroPath начинается с 0x80
                LD D, HIGH Adr.HeroPath
                JP SetDistance
; -----------------------------------------
; рассчитать DDA-линию от объекта до текущей точки пути
; In:
;   DE - адрес структуры FPath
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   FObjectCharacter - подготовлены поля DDA для движения к точке пути
; Corrupt:
;   HL, DE, AF
; Note:
;   Character.DistancePath рассчитывает знаковое расстояние до центра точки пути
;   в четвертях пикселя
;   Tick.Utils.Movement.SetLine преобразует расстояние в состояние DDA объекта
;   сброс RequestEvent.Flag запрещает переносить запрос события между сегментами пути
; -----------------------------------------
SetDistance:    CALL Character.DistancePath
                RES_FLAG_MODIFY RequestEvent.Flag                               ; сброс флага запроса события предыдущего сегмента
                JP Tick.Utils.Movement.SetLine

RequestEvent    ; запрос на создание ивента

.Flag           FLAG_MODIFY 0
                RET C                                                           ; выход, если ивент активирован
                SET_FLAG_MODIFY RequestEvent.Flag                               ; установка флага создания ивента

                ; текущая позиция героя в гексагонах
                LD E, (IX + FObject.Position.X.High)
                LD D, (IX + FObject.Position.Y.High)
                JP Tick.Utils.Reconnaissance.Request

                endif ; ~_TICK_OBJECT_HERO_

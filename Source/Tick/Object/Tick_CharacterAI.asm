
                ifndef _TICK_OBJECT_CHARACTER_AI_
                define _TICK_OBJECT_CHARACTER_AI_
AI_DEMO_POINT_A_X      EQU #03
AI_DEMO_POINT_A_Y      EQU #03
AI_DEMO_POINT_B_X      EQU #04
AI_DEMO_POINT_B_Y      EQU #03
; -----------------------------------------
; обработчик тика объекта "AI-персонаж"
; In:
;   IX - адрес структуры объекта (FObjectCharacterAI)
;   C  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   F' - Carry установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   все регистры, кроме IX
; Note:
;   AI движется между двумя заданными гексами и самостоятельно не запрашивает время
;   ToDo: заменить демонстрационную логику на State Tree
; -----------------------------------------
CharacterAI:    ; сохранение параметров текущего cadence-прохода
                LD A, C
                LD (AI.Move.RelativeCadence), A
                EX AF, AF'
                LD A, #00
                ADC A, A
                LD (AI.Move.WorldTickFlag), A

                ; проверка активного движения AI-персонажа
                LD C, (IX + FObjectCharacter.Super.Sprite)
                BIT ANIM_STATE_BIT, C
                JR NZ, AI.Move                                                  ; переход, если AI уже движется

                ; проверка наличия демонстрационного пути
                LD A, (IX + FObjectCharacter.PathID)
                CP PATH_ID_NONE
                JR NZ, .PathReady                                               ; переход, если путь уже назначен
                CALL AI.AssignPath

                ; бесплатный визуальный поворот к точке пути
.PathReady      LD HL, Adr.AIPath
                PUSH HL
                CALL Tick.Utils.Movement.FacePath                              ; бесплатный визуальный поворот
                POP DE
                RET NZ                                                          ; выход, если поворот ещё не завершён

                ; проверка доставки "мирового тика"
                LD A, (AI.Move.WorldTickFlag)
                OR A
                RET Z                                                           ; AI ждёт течение времени, созданное действием игрока
AI.Move.Init    ; подготовка нового сегмента движения
                CALL AI.SetDistance
                CALL Tick.Utils.Movement.UpdateEffectiveStepCost                ; рассчитать стоимость шага начального гекса
                SET ANIM_STATE_BIT, (IX + FObjectCharacter.Super.Sprite)        ; последующие cadence-проходы продолжают распределять бюджет
AI.Move         ; начисление и распределение бюджета движения
                CALL Tick.Utils.Movement.GetCharacterMovementBudget             ; получить бюджет движения за один "мировой тик"
.WorldTickFlag  EQU $+1
                LD A, #00
                OR A
                CALL NZ, Tick.Utils.Movement.AddBudget                          ; начислить бюджет только в активной фазе cadence-эпохи
                CALL Tick.Utils.Movement.GetCharacterMovementBudget             ; получить бюджет движения за один "мировой тик"

.RelativeCadence EQU $+1
                LD A, #00
                CALL Tick.Utils.Movement.TransferBudget                         ; передать движению долю пакета текущего cadence-прохода
    
                ; сохранение координат гекса до попытки движения
                LD A, (IX + FObject.Position.X.High)
                LD (AI.Move.PreviousHexX), A
                LD A, (IX + FObject.Position.Y.High)
                LD (AI.Move.PreviousHexY), A

                ; сброс признака фактического перемещения в текущем cadence-проходе
                XOR A
                LD (AI.Move.MovedFlag), A

.StepLoop       ; чтение рассчитанной стоимости DDA-шага для текущего участка маршрута
                LD E, (IX + FObjectCharacter.StepCost)
                LD D, #00

                ; проверка возможности движения по текущему участку маршрута
                LD A, E
                OR A
                JR Z, .Animation                                                ; переход, если поверхность запрещает движение

                ; проверка наличия бюджета для одного DDA-шага
                LD HL, (IX + FObjectCharacter.MovementBudget)
                OR A
                SBC HL, DE
                JR C, .Animation                                                ; переход, если бюджета недостаточно для DDA-шага
                LD (IX + FObjectCharacter.MovementBudget), HL

                ; выполнение одного оплаченного DDA-шага
                CALL Tick.Utils.Movement.Step
                LD A, #01
                LD (AI.Move.MovedFlag), A                                       ; выполнен хотя бы один четвертьпиксельный DDA-шаг
                JR C, .Animation                                                ; переход, если точка назначения достигнута
                JR .StepLoop

.Animation      ; -----------------------------------------
                ; обработка событий и визуального состояния после движения
                ; -----------------------------------------
                ; проверка смены гекса после движения
                LD A, (IX + FObject.Position.X.High)
.PreviousHexX   EQU $+1
                CP #00
                JR NZ, .RequestReconnaissance                                   ; переход, если изменилась координата X
                LD A, (IX + FObject.Position.Y.High)
.PreviousHexY   EQU $+1
                CP #00
                JR Z, .AnimationState                                           ; переход, если гекс не изменился

.RequestReconnaissance
                LD E, (IX + FObject.Position.X.High)
                LD D, (IX + FObject.Position.Y.High)
                CALL Tick.Utils.Reconnaissance.Request                          ; союзники получают общую разведку группы

.AnimationState ; проверка фактического перемещения в текущем cadence-проходе
.MovedFlag      EQU $+1
                LD A, #00
                OR A
                JR Z, .CheckCompletion                                          ; переход, если позиция в текущем проходе не изменилась

                ; обновление кадра анимации после фактического перемещения
                LD C, (IX + FObjectCharacter.Super.Sprite)
                LD A, C
                INC A
                XOR C
                AND %00000111
                XOR C
                AND %00111111
                OR ANIM_STATE_MOVE
                LD (IX + FObjectCharacter.Super.Sprite), A
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)

                ; проверка достижения заданной точки
.CheckCompletion
                LD A, (IX + FObjectCharacter.Movement.RemainingSteps.Low)
                OR (IX + FObjectCharacter.Movement.RemainingSteps.High)
                RET NZ

                ; фиксация объекта в центре заданного гекса после завершения DDA
                LD HL, Adr.AIPath
                LD A, (HL)
                LD (IX + FObject.Position.X.High), A
                LD (IX + FObject.Position.X.Low), HEXTILE_SIZE_X << 4
                INC L
                LD A, (HL)
                LD (IX + FObject.Position.Y.High), A
                LD (IX + FObject.Position.Y.Low), HEXTILE_SIZE_Y << 4

                LD (IX + FObjectCharacter.PathID), PATH_ID_NONE
                RES ANIM_STATE_BIT, (IX + FObjectCharacter.Super.Sprite)
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)
                RET
; -----------------------------------------
; выбрать следующую из двух демонстрационных точек
; In:
;   IX - адрес структуры объекта (FObjectCharacterAI)
; Out:
;   Adr.AIPath - записана следующая демонстрационная точка
;   FObjectCharacter.WayPointID - переключен индекс демонстрационной точки
;   FObjectCharacter.PathID - установлен индекс текущего пути
; Corrupt:
;   HL, DE, AF
; Note:
;   AI ходит между двумя фиксированными гексами A и B
;   ToDo: заменить демонстрационную логику на State Tree
; -----------------------------------------
AI.AssignPath:  ; переключение индекса демонстрационной точки
                LD A, (IX + FObjectCharacter.WayPointID)
                INC A                                                           ; #FF -> 0 при первом назначении
                AND #01
                LD (IX + FObjectCharacter.WayPointID), A

                ; выбор координат следующей демонстрационной точки
                LD DE, (AI_DEMO_POINT_B_Y << 8) | AI_DEMO_POINT_B_X

                ; проверка выбора точки B
                OR A
                JR Z, .Store                                                    ; переход, если выбрана точка B
                LD DE, (AI_DEMO_POINT_A_Y << 8) | AI_DEMO_POINT_A_X

.Store          ; запись FPath для демонстрационного движения
                LD HL, Adr.AIPath
                LD (HL), E                                                      ; FPath.HexCoord.X
                INC L
                LD (HL), D                                                      ; FPath.HexCoord.Y
                INC L
                LD (HL), #00                                                    ; FPath.HextileID пока не используется
                INC L
                LD (HL), #00                                                    ; FPath.WayPointIdx
                LD (IX + FObjectCharacter.PathID), #00
                RET
; -----------------------------------------
; рассчитать DDA-линию от AI-объекта до текущей демонстрационной точки
; In:
;   DE - адрес структуры FPath
;   IX - адрес структуры объекта (FObjectCharacterAI)
; Out:
;   FObjectCharacter - подготовлены поля DDA для движения к точке пути
; Corrupt:
;   HL, DE, AF
; Note:
;   Character.DistancePath рассчитывает знаковое расстояние до центра точки пути
;   в четвертях пикселя
;   Tick.Utils.Movement.SetLine преобразует расстояние в состояние DDA объекта
; -----------------------------------------
AI.SetDistance: CALL Character.DistancePath
                JP Tick.Utils.Movement.SetLine

                endif ; ~_TICK_OBJECT_CHARACTER_AI_

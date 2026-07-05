
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
;   временная демонстрационная логика без State Tree;
;   AI движется между двумя заданными гексами и самостоятельно не запрашивает время
; -----------------------------------------
CharacterAI:    LD A, C
                LD (AI.Move.RelativeCadence), A
                EX AF, AF'
                LD A, #00
                ADC A, A
                LD (AI.Move.WorldTickFlag), A

                LD C, (IX + FObjectCharacter.Super.Sprite)
                BIT ANIM_STATE_BIT, C
                JR NZ, AI.Move

                LD A, (IX + FObjectCharacter.PathID)
                CP PATH_ID_NONE
                JR NZ, .PathReady
                CALL AI.AssignPath

.PathReady      LD HL, Adr.AIPath
                PUSH HL
                CALL Tick.Utils.Movement.FacePath                              ; бесплатный визуальный поворот
                POP DE
                RET NZ

                LD A, (AI.Move.WorldTickFlag)
                OR A
                RET Z                                                           ; AI ждёт течение времени, созданное действием игрока

AI.Move.Init    CALL AI.SetDistance
                CALL Tick.Utils.Movement.UpdateHextileID
                SET ANIM_STATE_BIT, (IX + FObjectCharacter.Super.Sprite)       ; последующие cadence-проходы продолжают распределять бюджет

AI.Move         ; начислить время только в активной фазе cadence-эпохи
.WorldTickFlag  EQU $+1
                LD A, #00
                OR A
                CALL NZ, Tick.Utils.Movement.AddBudget

.RelativeCadence EQU $+1
                LD A, #00
                CALL Tick.Utils.Movement.TransferBudget

                LD A, (IX + FObject.Position.X.High)
                LD (AI.Move.PreviousHexX), A
                LD A, (IX + FObject.Position.Y.High)
                LD (AI.Move.PreviousHexY), A

                XOR A
                LD (.MovedFlag), A

.StepLoop       LD L, (IX + FObjectCharacter.HextileID)
                LD H, HIGH Adr.SurfPass
                LD E, (HL)
                LD D, #00
                LD A, E
                OR A
                JR Z, .Animation

                LD HL, (IX + FObjectCharacter.MovementBudget)
                OR A
                SBC HL, DE
                JR C, .Animation
                LD (IX + FObjectCharacter.MovementBudget), HL

                CALL Tick.Utils.Movement.Step
                LD A, #01
                LD (.MovedFlag), A
                JR C, .Animation
                JR .StepLoop

.Animation      LD A, (IX + FObject.Position.X.High)
.PreviousHexX   EQU $+1
                CP #00
                JR NZ, .RequestReconnaissance
                LD A, (IX + FObject.Position.Y.High)
.PreviousHexY   EQU $+1
                CP #00
                JR Z, .AnimationState

.RequestReconnaissance
                LD E, (IX + FObject.Position.X.High)
                LD D, (IX + FObject.Position.Y.High)
                CALL Tick.Utils.Reconnaissance.Request                         ; союзники получают общую разведку группы

.AnimationState
.MovedFlag      EQU $+1
                LD A, #00
                OR A
                JR Z, .CheckCompletion

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

.CheckCompletion:
                LD A, (IX + FObjectCharacter.MajorRemaining.Low)
                OR (IX + FObjectCharacter.MajorRemaining.High)
                RET NZ

                ; DDA завершён: зафиксировать центр заданного гекса
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
; -----------------------------------------
AI.AssignPath:  LD A, (IX + FObjectCharacter.WayPointID)
                INC A                                                           ; #FF -> 0 при первом назначении
                AND #01
                LD (IX + FObjectCharacter.WayPointID), A

                LD DE, (AI_DEMO_POINT_B_Y << 8) | AI_DEMO_POINT_B_X
                OR A
                JR Z, .Store
                LD DE, (AI_DEMO_POINT_A_Y << 8) | AI_DEMO_POINT_A_X

.Store          LD HL, Adr.AIPath
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
; рассчитать DDA до текущей демонстрационной точки
; In:
;   DE - адрес FPath
; -----------------------------------------
AI.SetDistance: CALL Character.DistancePath
                JP Tick.Utils.Movement.SetLine

                endif ; ~_TICK_OBJECT_CHARACTER_AI_

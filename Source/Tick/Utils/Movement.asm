
                ifndef _TICK_UTILS_MOVEMENT_
                define _TICK_UTILS_MOVEMENT_
; -----------------------------------------
; подготовить DDA для движения на заданное расстояние
; In:
;   HL - знаковое расстояние по вертикали, в четвертях пикселя
;   DE - знаковое расстояние по горизонтали, в четвертях пикселя
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
SetLine:        XOR A
                LD (IX + FObjectCharacter.MovementFlags), A

                BIT 7, D
                JR Z, .PositiveX
                SET MOVEMENT_STEP_X_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
                XOR A
                SUB E
                LD E, A
                SBC A, A
                SUB D
                LD D, A

.PositiveX      BIT 7, H
                JR Z, .PositiveY
                SET MOVEMENT_STEP_Y_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
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
                PUSH DE
                POP HL
                LD (IX + FObjectCharacter.MinorLength), HL
                RET

.MajorX         PUSH HL
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
; повернуть персонажа на один шаг в направлении точки пути
; In:
;   HL - адрес FPath
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
;   Zero установлен, если персонаж уже смотрит в направлении пути;
;   Zero сброшен, если выполнен шаг поворота
; Corrupt:
;   HL, DE, BC, AF
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
; добавить бюджет движения за пакет "мировых тиков" текущей cadence-эпохи
; In:
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
AddBudget:      LD A, (GameConfig.SpeedHero)
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
                LD HL, #FFFF
.Store          LD (IX + FObjectCharacter.MovementPending), HL
                RET

; -----------------------------------------
; передать движению долю временного бюджета текущего cadence-прохода
; In:
;   A  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   IX - адрес структуры объекта (FObjectCharacter)
; Out:
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
TransferBudget: LD B, A
                LD A, (GameConfig.SpeedHero)
                LD L, A
                LD H, #00
                ADD HL, HL                                                    ; x2, четверть полного бюджета обычной поверхности
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
                CALL Math.Mul16x8_16
                PUSH HL
                POP BC

                LD HL, (IX + FObjectCharacter.MovementPending)
                OR A
                SBC HL, BC
                JR NC, .ShareFits

                ADD HL, BC
                PUSH HL
                POP DE
                LD HL, #0000
                LD (IX + FObjectCharacter.MovementPending), HL
                JR .AddBudget

.ShareFits      LD (IX + FObjectCharacter.MovementPending), HL
                PUSH BC
                POP DE

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
; -----------------------------------------
UpdateHextileID:
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
Step:           PUSH BC
                LD HL, (IX + FObjectCharacter.MajorRemaining)
                LD A, L
                OR H
                JR Z, .Complete

                DEC HL
                LD (IX + FObjectCharacter.MajorRemaining), HL

                BIT MOVEMENT_MAJOR_Y_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .MajorY
                CALL StepX
                JR .UpdateError
.MajorY         CALL StepY

.UpdateError    LD HL, (IX + FObjectCharacter.LineError)
                LD DE, (IX + FObjectCharacter.MinorLength)
                OR A
                SBC HL, DE
                JR NC, .StoreError

                LD DE, (IX + FObjectCharacter.MajorLength)
                ADD HL, DE
                LD (IX + FObjectCharacter.LineError), HL

                BIT MOVEMENT_MAJOR_Y_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .MinorX
                CALL StepY
                JR .CheckRemaining
.MinorX         CALL StepX
                JR .CheckRemaining

.StoreError     LD (IX + FObjectCharacter.LineError), HL

.CheckRemaining LD A, (IX + FObjectCharacter.MajorRemaining.Low)
                OR (IX + FObjectCharacter.MajorRemaining.High)
                JR Z, .Complete
                POP BC
                OR A
                RET

.Complete       POP BC
                SCF
                RET

; -----------------------------------------
; выполнить один четвертьпиксельный шаг по горизонтали
; -----------------------------------------
StepX:          BIT MOVEMENT_STEP_X_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .Negative

                LD A, (IX + FObject.Position.X.Low)
                INC A
                CP HEXTILE_SIZE_X << 5
                JR C, .Store
                XOR A
                LD (IX + FObject.Position.X.Low), A
                INC (IX + FObject.Position.X.High)
                JP UpdateHextileID

.Store          LD (IX + FObject.Position.X.Low), A
                RET

.Negative       LD A, (IX + FObject.Position.X.Low)
                OR A
                JR NZ, .Decrement
                DEC (IX + FObject.Position.X.High)
                LD A, (HEXTILE_SIZE_X << 5) - 1
                LD (IX + FObject.Position.X.Low), A
                JP UpdateHextileID

.Decrement      DEC A
                LD (IX + FObject.Position.X.Low), A
                RET

; -----------------------------------------
; выполнить один четвертьпиксельный шаг по вертикали
; -----------------------------------------
StepY:          BIT MOVEMENT_STEP_Y_NEG_BIT, (IX + FObjectCharacter.MovementFlags)
                JR NZ, .Negative

                LD A, (IX + FObject.Position.Y.Low)
                INC A
                CP (HEXTILE_SIZE_Y - 1) << 5
                JR C, .Store

                XOR A
                LD (IX + FObject.Position.Y.Low), A
                INC (IX + FObject.Position.Y.High)

                BIT 0, (IX + FObject.Position.Y.High)
                JR NZ, .DownOddRow
                CALL AddHalfX
                JP UpdateHextileID
.DownOddRow     CALL SubHalfX
                JP UpdateHextileID

.Store          LD (IX + FObject.Position.Y.Low), A
                RET

.Negative       LD A, (IX + FObject.Position.Y.Low)
                OR A
                JR NZ, .Decrement

                DEC (IX + FObject.Position.Y.High)
                LD A, ((HEXTILE_SIZE_Y - 1) << 5) - 1
                LD (IX + FObject.Position.Y.Low), A

                BIT 0, (IX + FObject.Position.Y.High)
                JR NZ, .UpOddRow
                CALL AddHalfX
                JP UpdateHextileID
.UpOddRow       CALL SubHalfX
                JP UpdateHextileID

.Decrement      DEC A
                LD (IX + FObject.Position.Y.Low), A
                RET

; -----------------------------------------
; сместить локальную координату X вправо на половину ширины гекса
; -----------------------------------------
AddHalfX:       LD A, (IX + FObject.Position.X.Low)
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
SubHalfX:       LD A, (IX + FObject.Position.X.Low)
                SUB HEXTILE_SIZE_X << 4
                JR NC, .Store
                ADD A, HEXTILE_SIZE_X << 5
                DEC (IX + FObject.Position.X.High)
.Store          LD (IX + FObject.Position.X.Low), A
                RET

                endif ; ~_TICK_UTILS_MOVEMENT_


                ifndef _TICK_OBJECT_HERO_
                define _TICK_OBJECT_HERO_
; -----------------------------------------
; обработчик тика объекта "герой"
; In:
;   IX - адрес структуры объекта (FObjectHero)
; Out:
; Corrupt:
; Note:
;   анимация должна меняться после готовности предыдущего кадра
; ----------------------------------------
Hero:           ; проверка смены анимации героя
                LD A, (GameSession.PeriodTick + FTick.Hero)
                CP DURATION.HERO_TICK
                RET NZ                                                          ; выход, если счётчик не обнулён

                ; проверка перемещения героя
                LD C, (IX + FObjectHero.Super.Sprite)
                BIT ANIM_STATE_BIT, C
                JR NZ, Move;.Prepare                                             ; переход, если герой движется

                ; проверка наличия пути
                LD A, (IX + FObjectHero.PathID)
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
                LD E, (IX + FObjectHero.Super.Position.X.High)
                LD D, (IX + FObjectHero.Super.Position.Y.High)
                CALL Hero.DirectonPath
                LD B, (HL)                                                      ; направление
                ; определение расстояние пути
                POP DE
                
                ; --------------------------------------------------------------
                ; проверка необходимости поворота в направление движения
                LD C, (IX + FObjectHero.Super.Sprite)

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

                LD (IX + FObjectHero.Super.Sprite), A
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)                      ; установить флаг, объект требуется обновиться
                RET
; Move.Prepare    ; --------------------------------------------------------------
;                 ; направление спрайта
;                 LD A, C
;                 RRA
;                 RRA
;                 RRA
;                 AND DIR_MASK
;                 LD B, A

Move.Init       CALL SetDistance
Move            ; --------------------------------------------------------------
                ; перемещение

                ; проверка доступности шага
                LD HL, (IX + FObjectHero.Delta.X)
                LD A, L
                OR H
                JR Z, .CalcY                                                    ; переход, если дельта нулевая
                
                LD BC, (IX + FObjectHero.Direction.X)                           ; чтение шага
                ; проверка знака дельты
                BIT 7, H
                JP NZ, .DeltaNegX    ; отрицательаня дельта (движение вправо)

.DeltaPosX      ; положительная дельта (HL), отрицательный шаг (BC) (движение влево)

                ; проверка доступности шага
                OR A
                ADC HL, BC
                JP P, .ApplyStepLeft                                            ; переход, если шаг возможен
                
                OR A
                SBC HL, BC
                
                ; перемещение на ширину шага невозможно, остаток дельты - новый шаг (отрицательный)
                ; NEG HL
                XOR A
                SUB L
                LD C, A
                SBC A, A
                SUB H
                LD B, A

                ; сброс дельты
                LD H, #00
                LD L, H

.ApplyStepLeft  ; сохранение новой дельты
                LD (IX + FObjectHero.Delta.X), HL
                
                ; смещение влево (шаг отрицательный)
                LD L, #00
                LD A, (IX + FObject.Position.X.Low)
                SRL A
                RR L
                RRA
                RR L
                LD H, A
                ADC HL, BC
                JP P, .ResultPosX                                               ; положительный результат

                ; переход на левый гексагон
                DEC (IX + FObject.Position.X.High)
                LD DE, (HEXTILE_SIZE_X << 3) << 8                               ; правая граница гексагона
                ADD HL, DE

.ResultPosX     ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                LD (IX + FObject.Position.X.Low), H
                JR .CalcY

.DeltaNegX      ; отрицательаня дельта (HL), положительный шаг (BC) (движение вправо)

                ; проверка доступности шага
                OR A
                ADC HL, BC
                JP M, .ApplyStepRight                                           ; переход, если шаг возможен
                
                OR A
                SBC HL, BC
                
                ; перемещение на ширину шага невозможно, остаток дельты - новый шаг (отрицательный)
                ; NEG HL
                XOR A
                SUB L
                LD C, A
                SBC A, A
                SUB H
                LD B, A

                ; сброс дельты
                LD H, #00
                LD L, H
                
.ApplyStepRight ; сохранение новой дельты
                LD (IX + FObjectHero.Delta.X), HL

                ; смещение вправо (шаг положительный)
                LD L, #00
                LD A, (IX + FObject.Position.X.Low)
                SRL A
                RR L
                RRA
                RR L
                LD H, A
                ADC HL, BC
                LD A, H
                CP HEXTILE_SIZE_X << 3                                          ; правая граница гексагона
                JP C, .ResultPosX_

                ; переход на правый гексагон
                INC (IX + FObject.Position.X.High)
                LD DE, (HEXTILE_SIZE_X << 3) << 8                               ; правая граница гексагона
                OR A
                SBC HL, DE

.ResultPosX_    ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                LD (IX + FObject.Position.X.Low), H

.CalcY          ; -----------------------------------------
                ; проверка доступности шага
                LD HL, (IX + FObjectHero.Delta.Y)
                LD A, L
                OR H
                JR Z, .SetState                                                 ; переход, если дельта нулевая

                LD BC, (IX + FObjectHero.Direction.Y)                           ; чтение шага
                ; проверка знака дельты
                BIT 7, H
                JP NZ, .DeltaNegY    ; отрицательаня дельта (движение вниз)

.DeltaPosY      ; положительная дельта (HL), отрицательный шаг (BC) (движение вверх)

                ; проверка доступности шага
                OR A
                ADC HL, BC
                JP P, .ApplyStepUp                                            ; переход, если шаг возможен
                
                OR A
                SBC HL, BC
                
                ; перемещение на ширину шага невозможно, остаток дельты - новый шаг (отрицательный)
                ; NEG HL
                XOR A
                SUB L
                LD C, A
                SBC A, A
                SUB H
                LD B, A

                ; сброс дельты
                LD H, #00
                LD L, H

.ApplyStepUp    ; сохранение новой дельты
                LD (IX + FObjectHero.Delta.Y), HL
                
                ; смещение вверх (шаг отрицательный)
                LD L, #00
                LD A, (IX + FObject.Position.Y.Low)
                SRL A
                RR L
                RRA
                RR L
                LD H, A
                ADC HL, BC
                JP P, .ResultPosY                                               ; положительный результат

                ; переход на верхний гексагон
                DEC (IX + FObject.Position.Y.High)
                LD DE, (HEXTILE_SIZE_Y << 3) << 8                               ; правая граница гексагона
                ADD HL, DE

.ResultPosY     ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                LD (IX + FObject.Position.Y.Low), H
                JR .SetState

.DeltaNegY      ; отрицательаня дельта (HL), положительный шаг (BC) (движение вниз)

                ; проверка доступности шага
                OR A
                ADC HL, BC
                JP M, .ApplyStepDown                                            ; переход, если шаг возможен
                
                OR A
                SBC HL, BC

                ; перемещение на ширину шага невозможно, остаток дельты - новый шаг (отрицательный)
                ; NEG HL
                XOR A
                SUB L
                LD C, A
                SBC A, A
                SUB H
                LD B, A

                ; сброс дельты
                LD H, #00
                LD L, H

.ApplyStepDown  ; сохранение новой дельты
                LD (IX + FObjectHero.Delta.Y), HL

                ; смещение вниз (шаг положительный)
                LD L, #00
                LD A, (IX + FObject.Position.Y.Low)
                SRL A
                RR L
                RRA
                RR L
                LD H, A
                ADC HL, BC
                LD A, H
                CP HEXTILE_SIZE_Y << 3                                          ; правая нижняя гексагона
                JP C, .ResultPosY_

                ; переход на правый гексагон
                INC (IX + FObject.Position.Y.High)
                LD DE, (HEXTILE_SIZE_X << 3) << 8                               ; нижняя граница гексагона
                OR A
                SBC HL, DE

.ResultPosY_    ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                LD (IX + FObject.Position.Y.Low), H

.SetState       ; --------------------------------------------------------------
                ; установить состояние перемещения героя,
                ; изменить кадр спрайта
                LD C, (IX + FObjectHero.Super.Sprite)
                LD A, C
                INC A
                XOR C
                AND %00000111
                XOR C
                AND %00111111
                OR ANIM_STATE_MOVE
                LD (IX + FObjectHero.Super.Sprite), A
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)                      ; установить флаг, объект требуется обновиться
                ; --------------------------------------------------------------
                ; проверка что герой дошёл до центра тайла
                LD A, (IX + FObjectHero.Delta.X)
                OR (IX + FObjectHero.Delta.Y)

                RET NZ                                                          ; выход, если недостигли центра тайла

                DEC (IX + FObjectHero.PathID)
                RES ANIM_STATE_BIT, (IX + FObjectHero.Super.Sprite)

                ; расчёт адреса текущей FPath
                LD A, (IX + FObjectHero.PathID)
                ADD A, A    ; x2
                ADD A, A    ; x4
                LD E, A
                SET 7, E    ; Adr.HeroPath начинается с 0x80
                LD D, HIGH Adr.HeroPath
SetDistance:    ; установить доступное расстояние между точками
                ;   DE - адрес хранения FPath
                ;   IX - адрес структуры объекта (FObjectHero)
                CALL Hero.DistancePath

                ; меняем знаки дельт
                LD A, E
                NEG
                LD (IX + FObjectHero.Delta.X.High), A
                LD (IX + FObjectHero.Delta.X.Low), #00
                LD A, L
                NEG
                LD (IX + FObjectHero.Delta.Y.High), A
                LD (IX + FObjectHero.Delta.Y.Low), #00

                ; -----------------------------------------
                ; нормализация ветора
                ; In:
                ;   DE - вектор (D - y [-128..127], E - x [-128..127])
                ; Out:
                ;   DE - нормализованный ветор (D - y [-128..127], E - x [-128..127])
                ;   A' - Sqrt(squared)
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                LD D, L
                CALL Math.Normalize
                LD C, D

                ; приведение к 16-битному значению
                LD A, E
                RLA
                SBC A, A
                LD D, A
                ; -----------------------------------------
                ; In :
                ;   DE - множимое
                ;   A  - множитель
                ; Out :
                ;   HL - результат умножения DE * A
                ; -----------------------------------------
                LD A, #05   ; скорость
                CALL Math.Mul16x8_16
                LD (IX + FObjectHero.Direction.X), HL

                ; приведение к 16-битному значению
                LD E, C
                LD A, C
                RLA
                SBC A, A
                LD D, A
                ; -----------------------------------------
                ; In :
                ;   DE - множимое
                ;   A  - множитель
                ; Out :
                ;   HL - результат умножения DE * A
                ; -----------------------------------------
                LD A, #05   ; скорость
                CALL Math.Mul16x8_16
                LD (IX + FObjectHero.Direction.Y), HL

                RET

                endif ; ~_TICK_OBJECT_HERO_

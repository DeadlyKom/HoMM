
                ifndef _PAGE_0_TICK_
                define _PAGE_0_TICK_

Tick.Utils.Movement:
.SetLine                    EQU Page0.Tick.Utils.Movement.SetLine                       ; подготовить DDA для движения к заданной точке
.FacePath                   EQU Page0.Tick.Utils.Movement.FacePath                      ; повернуть персонажа в направлении точки пути
.GetCharacterMovementBudget EQU Page0.Tick.Utils.Movement.GetCharacterMovementBudget    ; получить бюджет движения за один "мировой тик"
.AddBudget                  EQU Page0.Tick.Utils.Movement.AddBudget                     ; добавить бюджет движения за пакет "мировых тиков"
.TransferBudget             EQU Page0.Tick.Utils.Movement.TransferBudget                ; передать движению долю бюджета текущего cadence-прохода
.UpdateEffectiveStepCost    EQU Page0.Tick.Utils.Movement.UpdateEffectiveStepCost       ; обновить стоимость DDA-шага по текущим координатам
.Step                       EQU Page0.Tick.Utils.Movement.Step                          ; выполнить один четвертьпиксельный DDA-шаг

Tick.Utils.Reconnaissance:
.Request                    EQU Page0.Tick.Utils.Reconnaissance.Request                 ; запросить обновление рекогносцировки

                endif ; ~_PAGE_0_TICK_

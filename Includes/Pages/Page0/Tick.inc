
                ifndef _PAGE_0_TICK_
                define _PAGE_0_TICK_

Tick.Utils.Movement:
.SetLine                EQU Page0.Tick.Utils.Movement.SetLine
.FacePath               EQU Page0.Tick.Utils.Movement.FacePath
.AddBudget              EQU Page0.Tick.Utils.Movement.AddBudget
.TransferBudget         EQU Page0.Tick.Utils.Movement.TransferBudget
.UpdateHextileID        EQU Page0.Tick.Utils.Movement.UpdateHextileID
.Step                   EQU Page0.Tick.Utils.Movement.Step

Tick.Utils.Reconnaissance:
.Request                EQU Page0.Tick.Utils.Reconnaissance.Request

                endif ; ~_PAGE_0_TICK_

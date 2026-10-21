
                ifndef _MODULE_INVENTORY_INCLUDE_
                define _MODULE_INVENTORY_INCLUDE_

                include "Kernel/Bind.inc"                                       ; (0)
                include "Launch.asm"
                include "UI/Include.inc"
                include "RestoreState.asm"
                include "Input/Include.inc"
                include "Launch/Include.inc"
                include "Graphics/Include.inc"
                include "States/Include.inc"                                    ; состояния

                ; блок кода, копируемый при развёртывании модуля
Adr.Deploy      include "Source/Inventory/Include.inc"
Size.Deploy     EQU $-Adr.Deploy
Adr.Deploy.Sprite   include "Sprite/Include.inc"
Size.Deploy.Sprite  EQU $-Adr.Deploy.Sprite

                ; блок кода для общей памяти в 7 странице
Adr.Deploy.SharedScreen     include "SharedScreen/Include.inc"
Size.Deploy.SharedScreen    EQU $-Adr.Deploy.SharedScreen

                endif ; ~_MODULE_INVENTORY_INCLUDE_

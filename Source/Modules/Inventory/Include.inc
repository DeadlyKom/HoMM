
                ifndef _MODULE_INVENTORY_INCLUDE_
                define _MODULE_INVENTORY_INCLUDE_

                include "Kernel/Bind.inc"                                       ; (0)
                include "Launch.asm"
                include "UI/Include.inc"
                include "Input/Include.inc"
                include "Launch/Include.inc"
                include "Graphics/Include.inc"

                ; блок кода, копируемый при развёртывании модуля
Adr.Deploy      include "Source/Inventory/Include.inc"
                ; определение размера копируемого блока
Size.Deploy     EQU $-Adr.Deploy

                endif ; ~_MODULE_INVENTORY_INCLUDE_

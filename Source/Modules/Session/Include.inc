
                ifndef _MODULE_SESSION_INCLUDE_
                define _MODULE_SESSION_INCLUDE_

                include "Kernel/Bind.inc"
                include "Launch.asm"
                include "Utilities/Include.inc"
                include "Kernel/Include.inc"
                include "Map/HextileShading.inc"
                include "Map/HextileShadingTable.inc"
                
                ; блок кода, копируемый при развёртывания модуля
Adr.Deploy      include "Session.inc"
Size.Deploy     EQU $-Adr.Deploy

                endif ; ~_MODULE_SESSION_INCLUDE_

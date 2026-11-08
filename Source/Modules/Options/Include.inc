
                ifndef _MODULE_OPTIONS_INCLUDE_
                define _MODULE_OPTIONS_INCLUDE_

                include "Kernel/Bind.inc"                                       ; (0)
                include "Launch.asm"
                include "UI/Include.inc"
                include "RestoreState.asm"
                include "Input/Include.inc"
                include "Launch/Include.inc"
                include "Graphics/Include.inc"

                ; блок кода, копируемый при развёртывании модуля
Adr.Deploy      include "Source/Options/Include.inc"
Size.Deploy     EQU $-Adr.Deploy

                endif ; ~_MODULE_OPTIONS_INCLUDE_


                ifndef _MODULE_CHARACTERISTICS_INCLUDE_
                define _MODULE_CHARACTERISTICS_INCLUDE_

                include "Kernel/Bind.inc"                                       ; (0)
                include "Launch.asm"
                include "UI/Include.inc"
                include "Input/Include.inc"
                include "Launch/Include.inc"

                ; блок кода, копируемый при развёртывании модуля
Adr.Deploy      include "Source/Characteristics/Include.inc"
Size.Deploy     EQU $-Adr.Deploy

                endif ; ~_MODULE_CHARACTERISTICS_INCLUDE_

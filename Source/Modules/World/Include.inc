
                ifndef _MODULE_WORLD_INCLUDE_
                define _MODULE_WORLD_INCLUDE_

                include "Kernel_Bind.inc"
                include "Launch.asm"

                ; блок кода, копируемый при развёртывания модуля
Adr.Deploy.Sprite   include "Sprite/Include.inc"
Size.Deploy.Sprite  EQU $-Adr.Deploy.Sprite
Adr.Deploy.World    include "Source/World/Include.inc"
Size.Deploy.World   EQU $-Adr.Deploy.World

; блок кода для расположения в 7 страницы, рядом с теневым окном
Adr.Deploy.ScreenRefresh    include "Screen/Include.inc"
Size.Deploy.ScreenRefresh   EQU $-Adr.Deploy.ScreenRefresh

                endif ; ~_MODULE_WORLD_INCLUDE_

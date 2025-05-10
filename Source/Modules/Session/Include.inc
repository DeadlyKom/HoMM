
                ifndef _MODULE_SESSION_INCLUDE_
                define _MODULE_SESSION_INCLUDE_

                include "Kernel_Bind.inc"
                include "Launch.asm"
                include "Make_Session.asm"
                include "Load_Session.asm"
                include "Utils/Include.inc"
                
                ; блок кода, копируемый при развёртывания модуля
Adr.Deploy      include "Session.inc"
Size.Deploy     EQU $-Adr.Deploy

                endif ; ~_MODULE_SESSION_INCLUDE_

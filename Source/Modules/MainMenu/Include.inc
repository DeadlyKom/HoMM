
                ifndef _MODULE_MAIN_MENU_INCLUDE_
                define _MODULE_MAIN_MENU_INCLUDE_

                include "Kernel_Bind.inc"
                include "Launch.asm"
                
                ; блок кода, копируемый при развёртывания модуля
Adr.Deploy.MainMenu     include "Source/MainMenu/Include.inc"
Size.Deploy.MainMenu    EQU $-Adr.Deploy.MainMenu

                endif ; ~_MODULE_MAIN_MENU_INCLUDE_

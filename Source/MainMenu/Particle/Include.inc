
                ifndef _MAIN_MENU_PARTICLE_INCLUDE_
                define _MAIN_MENU_PARTICLE_INCLUDE_

                module Particle
Begin           EQU $
                include "Update.asm"
                include "Initialize.asm"
                include "PlacementNew.asm"

                display " - Particle system:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_MAIN_MENU_PARTICLE_INCLUDE_

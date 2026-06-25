
                ifndef _MAIN_MENU_PARTICLE_INCLUDE_
                define _MAIN_MENU_PARTICLE_INCLUDE_

                module Particle
Begin           EQU $
                include "Initialize.asm"
                include "PlacementNew.asm"
                include "RestoreScreen.asm"
                include "DrawParticles.asm"
                include "UpdateParticles.asm"
                include "ParticleSampling.asm"
                include "RefillPointQueue.asm"
Adr.RestoreBuf  EQU SCR_STACK_ADR_SHADOW                                        ; адрес буфера восстановления экрана
Adr.PointQueue  EQU Adr.SpriteInfoBuffer                                        ; адрес буфера очереди точек
Size.PointQueue EQU 64                                                         ; максимальное количество элементов в буфере очереди точек
Size.Particle   EQU 6                                                           ; максимальное количество добавляемых частиц за раз

                display " - Particle system:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_MAIN_MENU_PARTICLE_INCLUDE_

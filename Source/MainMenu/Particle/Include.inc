
                ifndef _MAIN_MENU_PARTICLE_INCLUDE_
                define _MAIN_MENU_PARTICLE_INCLUDE_

                module Particle
Begin           EQU $
                include "Initialize.asm"
                include "PlacementNew.asm"
                include "RemoveAtSwap.asm"
                include "RestoreScreen.asm"
                include "DrawParticles.asm"
                include "UpdateParticles.asm"
                include "ParticleSampling.asm"
                include "RefillPointQueue.asm"
Adr.RestoreBuf  EQU SCR_ADR_SHADOW + SCR_SIZE                                   ; адрес буфера восстановления экрана
Adr.PointQueue  EQU Adr.SpriteInfoBuffer                                        ; адрес буфера очереди точек
Size.PointQueue EQU 64+64                                                         ; максимальное количество элементов в буфере очереди точек
Size.Particle   EQU 4                                                           ; максимальное количество добавляемых частиц за раз

                display " - Particle system:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"
                endmodule

                endif ; ~_MAIN_MENU_PARTICLE_INCLUDE_

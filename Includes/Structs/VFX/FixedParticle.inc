
                ifndef _STRUCT_FIXED_PARTICLE_
                define _STRUCT_FIXED_PARTICLE_

                struct FFixedParticle                                           ; частица со смешанной фиксированной точкой (9.7)   [8 байт]
Position        FVector16                                                       ; позиция на экране     (unsigned 8.8)              [4 байта]
Velocity        FVector16                                                       ; векторная скорость    (signed 9.7)                [4 байта]

                ends

                endif ; ~_STRUCT_FIXED_PARTICLE_

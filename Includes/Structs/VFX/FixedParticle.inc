
                ifndef _STRUCT_FIXED_PARTICLE_
                define _STRUCT_FIXED_PARTICLE_

                struct FFixedParticle                                           ; частица fixed 8.8                             [8 байт]
Position        FVector16                                                       ; позиция на экране     (fixed 8.8)             [4 байта]
Velocity        FVector16                                                       ; векторная скорость    (fixed 8.8)             [4 байта]

                ends

                endif ; ~_STRUCT_FIXED_PARTICLE_

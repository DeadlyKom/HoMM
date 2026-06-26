
                ifndef _CONST_PARTICLE_
                define _CONST_PARTICLE_
TARGET_PARTICLE_SIZE    EQU 16                                                  ; размер структуры FTargetParticle
MAX_TARGET_PARTICLE     EQU 64 + 32                                                 ; максимальное количество частиц 'нацеливания'
                                                                                ; значение уменьшено на еденицу, т.к. мб 0 элементов

                endif ; ~_CONST_PARTICLE_

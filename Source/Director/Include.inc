                
                ifndef _AI_DIRECTOR_INCLUDE_
                define _AI_DIRECTOR_INCLUDE_

                ; начальное заселение
                module Director
                include "DistanceMap/Include.inc"
                include "LocationSearch/Include.inc"
                include "SpawnPointFormation/Include.inc"
                include "Initialize.asm"
AIDirector      FAIDirector                                                     ; структура управления популяцией ИИ (временная)
                endmodule

                endif ; ~_AI_DIRECTOR_INCLUDE_

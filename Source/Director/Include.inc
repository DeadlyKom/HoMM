                
                ifndef _AI_DIRECTOR_INCLUDE_
                define _AI_DIRECTOR_INCLUDE_

                ; начальное заселение
                module Director
                include "Source/Director/LocationSearch/Include.inc"
                include "Source/Director/SpawnPointFormation/Include.inc"
                include "Initialize.asm"
AIDirector      FAIDirector                                                     ; структура управления популяцией ИИ (временная)
                endmodule

                endif ; ~_AI_DIRECTOR_INCLUDE_

                
                ifndef _AI_DIRECTOR_DISTANCE_MAP_INCLUDE_
                define _AI_DIRECTOR_DISTANCE_MAP_INCLUDE_

                module DistanceMap
DISTANCE_FAR                EQU #0F                                             ; значение далёкого или недостижимого объекта
DISTANCE_PACKED_FAR         EQU (DISTANCE_FAR << 4) | DISTANCE_FAR
DISTANCE_ROAD               EQU #10                                             ; один шаг расстояния до дороги в старшем полубайте
DISTANCE_ROAD_MASK          EQU #F0                                             ; маска расстояния до дороги
DISTANCE_SETTLEMENT         EQU #01                                             ; один шаг расстояния до поселения в младшем полубайте
DISTANCE_SETTLEMENT_MASK    EQU #0F                                             ; маска расстояния до поселения

                include "Build.asm"
                include "Launch.asm"
                include "Initialize.asm"
                include "UpdateFromNeighbor.asm"
                endmodule

                endif ; ~_AI_DIRECTOR_DISTANCE_MAP_INCLUDE_

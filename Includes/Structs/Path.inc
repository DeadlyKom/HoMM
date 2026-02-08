
                ifndef _STRUCTS_PATH_
                define _STRUCTS_PATH_

                struct FPath
HexCoord        FVector8                                                        ; координаты гексагона
HextileID       DB #00                                                          ; идентификатор гексагона
WayPointIdx     DB #00                                                          ; индекс WayPoint'а гексагона
                ends

                endif ; ~_STRUCTS_PATH_

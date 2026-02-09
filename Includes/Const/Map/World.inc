
                ifndef _CONST_MAP_WORLD_
                define _CONST_MAP_WORLD_
MAX_WORLD_HEX       EQU 48
MAX_WORLD_HEX_X     EQU MAX_WORLD_HEX                                           ; максимальное количество гексагонов мира по горизонтали
MAX_WORLD_HEX_Y     EQU MAX_WORLD_HEX                                           ; максимальный количество гексагонов мира по вертикали

HEXTILE_SIZE_X      EQU 6                                                       ; ширина гексагона по горизонтали
HEXTILE_BASE_SIZE_Y EQU 4                                                       ; высота основания гексагона по вертикали
HEXTILE_ALL_Y       EQU 8                                                       ; максимальная высота гексагона по вертикали


                endif ; ~_CONST_MAP_WORLD_

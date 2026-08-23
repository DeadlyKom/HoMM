
                ifndef _CONST_PATHFINDING_
                define _CONST_PATHFINDING_
PATHFINDING_MAX_DISTANCE        EQU 8                                           ; максимальная длина пути
PATHFINDING_RANGE_DIAMETER      EQU PATHFINDING_MAX_DISTANCE * 2 + 1            ; размер локального квадрата координа
PATHFINDING_RANGE_CELL_COUNT    EQU PATHFINDING_RANGE_DIAMETER *\
                                    PATHFINDING_RANGE_DIAMETER                  ; размер таблицы родителей
PATHFINDING_MAX_CELLS           EQU 1 + 3 * PATHFINDING_MAX_DISTANCE *\
                                    (PATHFINDING_MAX_DISTANCE + 1)              ; количество гексов в радиусе "максимальной длины пути"
                                                                                ; определяет максимальный размер очереди
PATHFINDING_QUEUE_NODE_SIZE     EQU 3                                           ; один элемент очереди занимает (FPathfindQueueNode)
PATHFINDING_CELL_UNVISITED      EQU #FF                                         ; значение не посещённой клетки в таблице родителей
PATHFINDING_CELL_START          EQU #FE                                         ; cпециальная метка стартовой клетки для остановки восстановления пути

                endif ; ~_CONST_PATHFINDING_


                ifndef _PAGE_1_PATHFINDING_
                define _PAGE_1_PATHFINDING_
Pathfinding:
.Request        EQU Page1.Pathfinding.Request                                   ; ограниченный поиск пути в ширину
.Request.Wrap   EQU Page1.Pathfinding.Request.Wrap                              ; ограниченный поиск пути в ширину  (обёртка)
.CanTraverse    EQU Page1.Pathfinding.Request.CanTraverse                       ; проверка перехода в соседний гекс

                endif ; ~_PAGE_1_PATHFINDING_

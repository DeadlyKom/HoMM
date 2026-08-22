
                ifndef _PAGE_1_PATHFINDING_
                define _PAGE_1_PATHFINDING_
Pathfinding:
.Request        EQU Page1.Pathfinding.Request                                  ; прямой шаг, bounded BFS либо дальний префикс
.Request.Wrap   EQU Page1.Pathfinding.Request.Wrap                             ; обёртка для вызова со сменой страницы
.CanTraverse    EQU Page1.Pathfinding.Request.CanTraverse                      ; проверка перехода в соседний гекс

                endif ; ~_PAGE_1_PATHFINDING_

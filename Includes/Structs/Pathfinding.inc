
                ifndef _STRUCTS_PATHFINDING_
                define _STRUCTS_PATHFINDING_

                struct FPathfindQueueNode                                       ; элемент FIFO bounded BFS                                  [3 байта]
DeltaQ          DB #00                                                          ; относительная axial-координата Q от стартового гекса      [1 байт]
DeltaR          DB #00                                                          ; относительная axial-координата R от стартового гекса      [1 байт]
Depth           DB #00                                                          ; количество переходов от стартового гекса                  [1 байт]
                ends

                endif ; ~_STRUCTS_PATHFINDING_

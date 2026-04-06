
                ifndef _STRUCTS_STATE_TREE_TRANSITION_
                define _STRUCTS_STATE_TREE_TRANSITION_

                struct FStateTreeTransition                                     ; переход между узлами state tree                               [4 байта]
Condition       FFunctionRef                                                    ; callback условия перехода                                     [3 байта]
                                                                                ; значение Function = 0 задаёт безусловный переход
                                                                                ; функция возвращает результат через Carry
TargetNode      DB #00                                                          ; индекс целевого узла                                          [1 байт]
                                                                                ; приоритет переходов задаётся порядком в массиве
                ends

                endif ; ~_STRUCTS_STATE_TREE_TRANSITION_

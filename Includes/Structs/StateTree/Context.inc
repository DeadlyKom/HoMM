
                ifndef _STRUCTS_STATE_TREE_CONTEXT_
                define _STRUCTS_STATE_TREE_CONTEXT_

STATE_TREE_ACTIVE_STACK_MAX                EQU 8
STATE_TREE_CONTEXT_INITIALIZED_BIT         EQU 0
STATE_TREE_CONTEXT_TRANSITION_PENDING_BIT  EQU 1
STATE_TREE_CONTEXT_BLOCKED_BIT             EQU 2

                struct FStateTreeContext                                        ; динамические данные экземпляра state tree                     [11 байт]
ActiveStack     DS STATE_TREE_ACTIVE_STACK_MAX, #00                             ; стек активных узлов от корня к листу                          [8 байт]
ActiveDepth     DB #00                                                          ; текущая глубина стека                                         [1 байт]
Flags           DB #00                                                          ; флаги runtime-состояния дерева                                [1 байт]
RequestedNode   DB #FF                                                          ; запрошенный целевой узел, #FF если отсутствует                [1 байт]
                ends

                endif ; ~_STRUCTS_STATE_TREE_CONTEXT_

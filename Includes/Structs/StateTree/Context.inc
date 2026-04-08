
                ifndef _STRUCTS_STATE_TREE_CONTEXT_
                define _STRUCTS_STATE_TREE_CONTEXT_

                struct FStateTreeContext                                        ; динамические данные экземпляра state tree                     [11 байт]
ActiveStack     DS STATE_TREE_ACTIVE_STACK_MAX, #00                             ; стек активных узлов от корня к листу                          [8 байт]
ActiveDepth     DB #00                                                          ; текущая глубина стека                                         [1 байт]
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | BL | IN |
;   +----+----+----+----+----+----+----+----+
;
;   BL      [1]     - флаг временной блокировки выполнения StateTree
;   IN      [0]     - флаг инициализации контекста StateTree
; -----------------------------------------
Flags           DB #00                                                          ; флаги runtime-состояния дерева                                [1 байт]
RequestedNode   DB #00                                                          ; целевой узел перехода                                         [1 байт]
                                                                                ; значение #FF runtime использует как признак, что переход не запрошен
                ends

                endif ; ~_STRUCTS_STATE_TREE_CONTEXT_

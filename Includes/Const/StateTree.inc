
                ifndef _CONST_STATE_TREE_
                define _CONST_STATE_TREE_
STATE_TREE_SIZE                             EQU 24                              ; размер структуры AI-контекста FAIContext
STATE_TREE_ACTIVE_AI_MAX                    EQU 16                              ; максимальное количество активных AI-контекстов
STATE_TREE_ACTIVE_STACK_MAX                 EQU 8                               ; максимальный размер стека активных узлов от корня к листу

; флаги
STATE_TREE_CONTEXT_INITIALIZED_BIT          EQU 0x00                            ; флаг инициализации контекста StateTree
STATE_TREE_CONTEXT_BLOCKED_BIT              EQU 0x01                            ; флаг временной блокировки выполнения StateTree

                endif ; ~_CONST_STATE_TREE_

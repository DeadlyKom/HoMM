
                ifndef _STRUCTS_STATE_TREE_AI_CONTEXT_
                define _STRUCTS_STATE_TREE_AI_CONTEXT_

                struct FAIContext                                               ; полный runtime-контекст AI-экземпляра                         [22 байт]
CharacterID     DB #00                                                          ; идентификатор владельца (структура FCharacter)                [1 байт]
Descriptor      FAddress                                                        ; адрес FStateTreeDescriptor                                    [2 байта]
StateTree       FStateTreeContext                                               ; runtime-состояние дерева состояний                            [11 байт]
Blackboard      FBlackboard                                                     ; рабочие данные AI                                             [8 байт]
                ends

                endif ; ~_STRUCTS_STATE_TREE_AI_CONTEXT_

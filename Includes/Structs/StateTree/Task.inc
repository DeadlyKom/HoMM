
                ifndef _STRUCTS_STATE_TREE_TASK_
                define _STRUCTS_STATE_TREE_TASK_

                struct FStateTreeTask                                           ; задача узла state tree                                        [9 байт]
OnEnter         FFunctionRef                                                    ; callback входа в задачу/логику узла                           [3 байта]
OnUpdate        FFunctionRef                                                    ; callback обновления задачи/логики узла                        [3 байта]
OnExit          FFunctionRef                                                    ; callback выхода из задачи/логики узла                         [3 байта]
                ends

                endif ; ~_STRUCTS_STATE_TREE_TASK_

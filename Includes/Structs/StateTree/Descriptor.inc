
                ifndef _STRUCTS_STATE_TREE_DESCRIPTOR_
                define _STRUCTS_STATE_TREE_DESCRIPTOR_

                struct FStateTreeDescriptor                                     ; статическое ROM-описание state tree                           [15 байт]
NodesNum        DB #00                                                          ; общее количество узлов в дереве                               [1 байт]

; адреса таблиц для каждого узла (индекс = номер узла)
ChildrenNum     DW #0000                                                        ; адрес массива количества дочерних узлов (DB[NodesNum])        [2 байта]
FirstChild      DW #0000                                                        ; адрес массива индексов первого дочернего узла (DB[NodesNum])  [2 байта]
                                                                                ; дети одного узла должны быть расположены подряд
EntryCondition  DW #0000                                                        ; адрес массива FStateTreeFunction[NodesNum]                    [2 байта]
                                                                                ; значение Function = 0 означает отсутствие условия входа
                                                                                ; callback условия входа возвращает результат через Carry
Tasks           DW #0000                                                        ; адрес массива указателей на FStateTreeTask[]                  [2 байта]
                                                                                ; все lifecycle-callback'и узла хранятся в задачах
                                                                                ; для узлов без задач значение указателя равно 0
TasksNum        DW #0000                                                        ; адрес массива количества задач (DB[NodesNum])                 [2 байта]
Transitions     DW #0000                                                        ; адрес массива указателей на FStateTreeTransition[]            [2 байта]
                                                                                ; для узлов без переходов значение указателя равно 0
TransitionsNum  DW #0000                                                        ; адрес массива количества переходов (DB[NodesNum])             [2 байта]
                ends

                endif ; ~_STRUCTS_STATE_TREE_DESCRIPTOR_

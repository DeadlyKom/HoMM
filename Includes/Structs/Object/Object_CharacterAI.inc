                ifndef _STRUCT_OBJECT_CHARACTER_AI_
                define _STRUCT_OBJECT_CHARACTER_AI_

                struct FObjectCharacterAI                                       ; расширение объекта персонажа для AI-управления            [26 байт]
                                                                                ; содержит ссылку на FAIContext
Super           FObjectCharacter                                                ; базовый класс объекта персонажа                           [25 байта]
AIContextID     DB #00                                                          ; идентификатор AI-контекста                                [1 байт]
                                                                                ; позволяет получить доступ к:
                                                                                ;   Descriptor       - описание поведения
                                                                                ;   StateTreeContext - runtime-состояние StateTree
                                                                                ;   Blackboard       - рабочие данные AI
                ends

                endif ; ~_STRUCT_OBJECT_CHARACTER_AI_

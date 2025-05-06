
                ifndef _STRUCTS_HERO_
                define _STRUCTS_HERO_

                struct FHero                                                    ; герой "аватар", за которого играет человек или ИИ             [32 байта]
Class           DB #00                                                          ; класс героя                                                   [1 байт]
                                                                                ; Note: 
                                                                                ;   влияет на вероятность выподания вторичных навыков
ParticipantID   DB #00                                                          ; идентификатор владельца, указатель на структуру FParticipant  [1 байт]
ObjectID        DB #00                                                          ; идентификатор объекта, к которому привязан                    [1 байт]
                                                                                ; Note: 
                                                                                ;   при перемещении структуры FObjectHero в массиве, необходимо
                                                                                ;   обновлять идентификатор объекта
PrimarySkill    FPrimarySkill                                                   ; основные навыки                                               [4 байта]
SecondarySkill  FSecondarySkill                                                 ; вторичные навыки                                              [байт]
CombatStates    FCombatStates                                                   ; боевые состояния                                              [2 байта]
Equipment       FHeroEquipment                                                  ; экипировка героя                                              [10 байт]
                ends

                endif ; ~_STRUCTS_HERO_

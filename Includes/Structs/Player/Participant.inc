
                ifndef _STRUCTS_PARTICIPANT_
                define _STRUCTS_PARTICIPANT_

                struct FParticipant                                             ; участник игры человек или ИИ                                  [32 байта]
HeroesNum       DB #00                                                          ; количество героев                                             [1 байт]
Heroes          DS MAX_PARTICIPANT_HEROES * FHero                               ; массив идентификаторов ID героев данного участника            [8 байт]
                                                                                ; Note: 
                                                                                ;   при перемещении структуры FHero в массиве, необходимо
                                                                                ;   обновлять идентификатор объекта
                ends

                endif ; ~_STRUCTS_PARTICIPANT_

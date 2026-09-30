
                ifndef _CONST_CHARACTER_
                define _CONST_CHARACTER_
CHARACTER_SIZE              EQU 32                                              ; размер структуры объекта Character
MAX_PARTICIPANT_PLAYER      EQU 0x04                                            ; максимальное количество героев у игрока
MAX_PARTICIPANT_CHARACTERS  EQU 0x08                                            ; максимальное количество героев участника

PLAYER_CHARACTER_ID_MAIN    EQU 0x00                                            ; ID основного игрового персонажа
PLAYER_CHARACTER_ID_EXTRA_1 EQU 0x01                                            ; ID первого дополнительного игрового персонажа
PLAYER_CHARACTER_ID_EXTRA_2 EQU 0x02                                            ; ID второго дополнительного игрового персонажа
PLAYER_CHARACTER_ID_EXTRA_3 EQU 0x03                                            ; ID третьего дополнительного игрового персонажа

                endif ; ~_CONST_CHARACTER_

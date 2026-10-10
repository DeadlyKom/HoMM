
                ifndef _CONST_CHARACTER_
                define _CONST_CHARACTER_
CHARACTER_SIZE              EQU 32                                              ; размер структуры объекта Character
MAX_PARTICIPANT_PLAYER      EQU 0x04                                            ; максимальное количество героев у игрока
MAX_PARTICIPANT_CHARACTERS  EQU 0x08                                            ; максимальное количество героев участника

PLAYER_CHARACTER_ID_MAIN    EQU 0x00                                            ; идентификатор основного игрового персонажа
PLAYER_CHARACTER_ID_EXTRA_1 EQU 0x01                                            ; идентификатор первого дополнительного игрового персонажа
PLAYER_CHARACTER_ID_EXTRA_2 EQU 0x02                                            ; идентификатор второго дополнительного игрового персонажа
PLAYER_CHARACTER_ID_EXTRA_3 EQU 0x03                                            ; идентификатор третьего дополнительного игрового персонажа

                endif ; ~_CONST_CHARACTER_

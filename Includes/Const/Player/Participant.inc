
                ifndef _CONST_PARTICIPANT_
                define _CONST_PARTICIPANT_
PARTICIPANT_SIZE        EQU 32                                                  ; размер структуры объекта FParticipant
MAX_PARTICIPANT         EQU 0x04                                                ; ограничено до 4х играющий, в том числе и ИИ
                                                                                ; позволяет освободить 4 бита в буфере метаданных карты (Adr.MapMetadata)

PLAYER_AFFILIATION_BIT  EQU 0x07                                                ; флаг, принадлежности
                                                                                ;   0 - человек
                                                                                ;   1 - компьютер
PLAYER_GROUP_BIT        EQU 0x00                                                ; принадлежность участника к группе

HUMANOID                EQU 0 << PLAYER_AFFILIATION_BIT
COMPUTER                EQU 1 << PLAYER_AFFILIATION_BIT

PLAYER_GROUP_0          EQU 0 << PLAYER_GROUP_BIT
PLAYER_GROUP_1          EQU 0 << PLAYER_GROUP_BIT
PLAYER_GROUP_2          EQU 0 << PLAYER_GROUP_BIT
PLAYER_GROUP_3          EQU 0 << PLAYER_GROUP_BIT

                endif ; ~_CONST_PARTICIPANT_

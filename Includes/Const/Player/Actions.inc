
                ifndef _CONST_PLAYER_ACTIONS_
                define _CONST_PLAYER_ACTIONS_
PLAYER_ACTION_NONE          EQU 0x00                                                ; отсутствуют действия
PLAYER_ACTION_HERO_MOVEMENT EQU 0x01                                            ; движение героя
PLAYER_ACTION_SELECT        EQU 0xFF                                            ; выбор
PLAYER_ACTION_CAST          EQU 0xFF                                            ; каст заклинания

                endif ; ~_CONST_PLAYER_ACTIONS_

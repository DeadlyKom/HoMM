
                ifndef _CONST_TICK_SCHEDULER_
                define _CONST_TICK_SCHEDULER_
; FTickRuntime.Control
GAME_SUSPEND_BIT            EQU 0x07                                            ; флаг, выборочного отключения тиков объектов в режиме "остановки времени"
GAME_PAUSE_BIT              EQU 0x06                                            ; флаг, отключения планировщика тиков

GAME_SUSPEND                EQU 1 << GAME_SUSPEND_BIT
GAME_PAUSE                  EQU 1 << GAME_PAUSE_BIT

; FTickRuntime.Requests
GAME_SUSPEND_REQUEST_BIT    EQU 0x07                                            ; флаг, запроса "остановки времени"
GAME_PAUSE_REQUEST_BIT      EQU 0x06                                            ; флаг, запроса паузы игры
GAME_SUSPEND_REQUEST        EQU 1 << GAME_SUSPEND_REQUEST_BIT
GAME_PAUSE_REQUEST          EQU 1 << GAME_PAUSE_REQUEST_BIT

CHUNK_ORDER_NEED_REBUID_BIT EQU 0x07                                            ; флаг, необходимости перестроения массива ChunkOrder
CHUNK_ORDER_NEED_REBUID     EQU 1 << CHUNK_ORDER_NEED_REBUID_BIT

; относительный временной шаг тика:
CADENCE_RANGE_1_2           EQU 0                                               ; базовый шаг,      диапазон 1/2 (x1)
CADENCE_RANGE_1_4           EQU 1                                               ; удвоенный шаг,    диапазон 1/4 (x2)
CADENCE_RANGE_1_8           EQU 2                                               ; учетверённый шаг, диапазон 1/8 (x4)

                endif ; ~_CONST_TICK_SCHEDULER_

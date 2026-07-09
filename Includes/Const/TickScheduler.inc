
                ifndef _CONST_TICK_SCHEDULER_
                define _CONST_TICK_SCHEDULER_
CHUNK_ORDER_NEED_REBUID_BIT EQU 0x07                                            ; флаг, необходимости перестроения массива ChunkOrder
CHUNK_ORDER_NEED_REBUID     EQU 1 << CHUNK_ORDER_NEED_REBUID_BIT

; относительный временной шаг тика:
CADENCE_RANGE_1_2           EQU 0                                               ; базовый шаг,      диапазон 1/2 (x1)
CADENCE_RANGE_1_4           EQU 1                                               ; удвоенный шаг,    диапазон 1/4 (x2)
CADENCE_RANGE_1_8           EQU 2                                               ; учетверённый шаг, диапазон 1/8 (x4)

                endif ; ~_CONST_TICK_SCHEDULER_

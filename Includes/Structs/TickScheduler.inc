
                ifndef _STRUCTS_TICK_SCHEDULER_
                define _STRUCTS_TICK_SCHEDULER_

                struct FCadenceRange
FirstIndex      DB #00                                                          ; номер первого индекса
CadencePassId   DB #00                                                          ; идентификатор прохода
Pointer         DB #00                                                          ; указатель в диапазоне
                ends

                struct FTickScheduler
ChunkOrder      DS MAX_WORLD_CHUNK_SIZE, 0                                      ; массив
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | NR | .. | .. | .. | .. | C8 | C4 | C2 |
;   +----+----+----+----+----+----+----+----+
;
;   NR      [7]     - флаг необходимости перестроения массива ChunkOrder
;   C8      [2]     - флаг завершения "шага обновления" 1/8
;   C4      [1]     - флаг завершения "шага обновления" 1/4
;   C2      [1]     - флаг завершения "шага обновления" 1/2
; -----------------------------------------
Flags           DB #00                                                          ; флаги
Range_0         FCadenceRange                                                   ; 0-й диапазон
Range_1         FCadenceRange                                                   ; 1-й диапазон
Range_2         FCadenceRange                                                   ; 2-й диапазон
                DB MAX_WORLD_CHUNK_SIZE                                         ; всегда последний, для корректного обхода диапазона
                ends

                endif ; ~_STRUCTS_TICK_SCHEDULER_

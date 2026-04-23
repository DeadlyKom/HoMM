
                ifndef _OBJECT_UTILITIES_GET_CADENCE_PASS_ID_BY_CHUNK_
                define _OBJECT_UTILITIES_GET_CADENCE_PASS_ID_BY_CHUNK_
; -----------------------------------------
; получить CadencePassId по номеру чанка
; In:
;   A - порядковый номер чанка
; Out:
;   A - текущий CadencePassId диапазона,
;       если чанк не найден в ChunkOrder, возвращает #FF
; Corrupt:
;   HL, BC, AF
; Note:
; -----------------------------------------
GetCadencePassIdByChunk:
                LD HL, TickScheduler + FTickScheduler.ChunkOrder
                LD BC, MAX_WORLD_CHUNK_SIZE

                ; поиск чанка в ChunkOrder
.Loop           CPI
                JR Z, .Found
                JP PE, .Loop

.NotFound       ; неудалось найти
                LD A, #FF
                RET

.Found          ; регистр C указывает оставшиеся место в массиве,
                ; перобразуем его в индекс найденого чанка (OrderIndex)
                LD A, MAX_WORLD_CHUNK_SIZE - 1
                SUB C
                LD C, A

                ; поиск в нулевом диапазоне (OrderIndex < Range_1.FirstIndex)
                LD A, (TickScheduler + FTickScheduler.Range_1.FirstIndex)
                DEC A                                                           ; уменьшить на еденицу, для исключения индекса первого диапозона
                CP C
                JR C, .FirstRange                                               ; переход, если не нулевой диапозон
                LD A, (TickScheduler + FTickScheduler.Range_0.CadencePassId)
                RET

.FirstRange     ; поиск в первом диапазоне (OrderIndex < Range_2.FirstIndex)
                LD A, (TickScheduler + FTickScheduler.Range_2.FirstIndex)
                DEC A                                                           ; уменьшить на еденицу, для исключения индекса второго диапозона
                CP C
                JR C, .SecondRange                                              ; переход, если не первый диапозон
                LD A, (TickScheduler + FTickScheduler.Range_1.CadencePassId)
                RET

.SecondRange    ; сравнение не требуется, это точно втрой диапозон
                LD A, (TickScheduler + FTickScheduler.Range_2.CadencePassId)
                RET

                endif ; ~ _OBJECT_UTILITIES_GET_CADENCE_PASS_ID_BY_CHUNK_

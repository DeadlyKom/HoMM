
                ifndef _PAGE_0_CHUNK_ARRAY_
                define _PAGE_0_CHUNK_ARRAY_
ChunkArray:
.Initialize     EQU Page0.ChunkArray.Initialize                                 ; первичная инициализация массива чанков
.Insert         EQU Page0.ChunkArray.Insert                                     ; вставка значения в массив чанков
.Remove         EQU Page0.ChunkArray.Remove                                     ; удаление значения из массива чанков
.Move           EQU Page0.ChunkArray.Move                                       ; перемещение значения в другой чанк
.Area           EQU Page0.ChunkArray.Area                                       ; получение значений в области
.GetChunkIndex  EQU Page0.ChunkArray.GetChunkIndex                              ; получение номера чанка
.GetAddress     EQU Page0.ChunkArray.GetAddress                                 ; получение адреса указаннго чанка
                endif ; ~_PAGE_0_CHUNK_ARRAY_


                ifndef _KERNEL_CHUNK_ARRAY_
                define _KERNEL_CHUNK_ARRAY_
ChunkArray:
.Initialize     EQU Kernel.ChunkArray.Initialize                                ; первичная инициализация массива чанков
.Insert         EQU Kernel.ChunkArray.Insert                                    ; вставка значения в массив чанков
.Remove         EQU Kernel.ChunkArray.Remove                                    ; удаление значения из массива чанков
.Move           EQU Kernel.ChunkArray.Move                                      ; перемещение значения в другой чанк
.Area           EQU Kernel.ChunkArray.Area                                      ; получение значений в области
.GetChunkIndex  EQU Kernel.ChunkArray.GetChunkIndex                             ; получение номера чанка
.GetAddress     EQU Kernel.ChunkArray.GetAddress                                ; получение адреса указаннго чанка
                endif ; ~_KERNEL_CHUNK_ARRAY_

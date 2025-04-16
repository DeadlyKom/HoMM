
                ifndef _CHUNK_ARRAY_INCLUDE_
                define _CHUNK_ARRAY_INCLUDE_

                module ChunkArray
CHUNK_SHIFT     EQU 3                                                           ; значение определяющая размер чанка
                                                                                ; размер карты
                                                                                ;   при CHUNK_SHIFT = 2
                                                                                ; 48x48 - (48 >> CHUNK_SHIFT) => 12x12 тайлов один чанк
                                                                                ; 64x64 - (64 >> CHUNK_SHIFT) => 16х16 тайлов один чанк
                                                                                ; 80x80 - (80 >> CHUNK_SHIFT) => 20x20 тайлов один чанк
                                                                                ;   при CHUNK_SHIFT = 3
                                                                                ; 48x48 - (48 >> CHUNK_SHIFT) =>  6x6  тайлов один чанк
                                                                                ; 64x64 - (64 >> CHUNK_SHIFT) =>  8х8  тайлов один чанк
                                                                                ; 80x80 - (80 >> CHUNK_SHIFT) => 10x10 тайлов один чанк
CHUNK_SIZE      EQU 1 << CHUNK_SHIFT
CHUNK_SIZE_MASK EQU (CHUNK_SIZE - 1) & 0xFF

                ; структура хранения данных, состоит из 2х половинок
                ; буфер ChunkArrayCounters хранит счётчики объектов в данном чанке,
                ;     a порядковый номер в буфере соответствент номеру чанка (ID Chunk)
                ; буфер ChunkArrayValues хранит уникальный номер объекта (ID Object)
Begin           EQU $
                include "Core.asm"
                include "Area.asm"
                include "Move.asm"
                include "Remove.asm"
                include "Insert.asm"
                include "Initialize.asm"
Size            EQU $-Begin
                display " - Chunk array:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " byte(s)  ]"

                endmodule

                endif ; ~ _CHUNK_ARRAY_INCLUDE_

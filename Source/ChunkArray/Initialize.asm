
                ifndef _CHUNK_ARRAY_INITIALIZE_
                define _CHUNK_ARRAY_INITIALIZE_
; -----------------------------------------
; первичная инициализация массива чанков
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Initialize:     LD DE, #0000

                ; очистка массива чанков для статических объектов
                LD HL, Adr.ChunkArrayCounters + Size.ChunkArrayCounters
                CALL SafeFill.b256

                ; очистка массива чанков для статических объектов
                LD HL, (Adr.ChunkArrayValues + Size.ChunkArrayValues) & 0xFFFF
                CALL SafeFill.b256
                
                ; ToDo сделать инициализацию на основе размера карты

                ; подготовка
                LD C, #00
                
                ; округление
                LD A, 64                                                        ; размер карты по горизонтали
                rept CHUNK_SHIFT
                RRA
                ADC A, C
                endr
                DEC A
                LD (GetChunkIndex.Mask), A

                ; округление
                LD A, 64                                                        ; размер карты по вертикали
                rept CHUNK_SHIFT
                RRA
                ADC A, C
                endr

                RRA                                                             ; пропуск 1 бита
                LD HL, #1F1F                                                    ; x2 (RRA : RRA)
                RRA
                JR C, .SetOperation
                LD H, C                                                         ; x4
                RRA
                JR C, .SetOperation
                LD L, C                                                         ; x8
                RRA
                JR C, .SetOperation
                LD L, #87                                                       ; x16 (ADD A, A)
.SetOperation   LD (GetChunkIndex.Operation), HL

                RET

                endif ; ~ _CHUNK_ARRAY_INITIALIZE_


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

                ; инициализацию на основе размера карты
                LD A, (GameSession.MapSize.Width)                               ; размер карты по горизонтали
                LD C, A
                LD A, (GameSession.MapSize.Height)                              ; размер карты по вертикали
                CP C
                DEBUG_BREAK_POINT_NZ                                            ; произошла ошибка!
                                                                                ; размеры ширины и высоты карты различаются

                ; определение индекса в таблице адресов функций
                RRA             ; %0HHHHHHH : H
                RRA             ; %H0HHHHHH : H
                RRA             ; %HH0HHHHH : H
                AND %00011110   ; %000HHHH0 : 0
                SUB #03 << 1
                DEBUG_BREAK_POINT_C                                             ; произошла ошибка!
                                                                                ; размеры карты меньше 48
                ifdef _DEBUG
                CP #03 << 1
                DEBUG_BREAK_POINT_NC                                            ; произошла ошибка!
                                                                                ; размер карты больше 80
                endif

                ; определение адреса в таблице
                ADD A, LOW .Table
                LD L, A
                ADC A, HIGH .Table
                SUB L
                LD H, A

                ; чтение адреса
                LD E, (HL)
                INC HL
                LD D, (HL)

                ; установка адреса функции
                LD (GetChunkIndex + 1), DE
                RET

.Table          DW Shift._48, Shift._64, Shift._80

                endif ; ~ _CHUNK_ARRAY_INITIALIZE_

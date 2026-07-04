
                ifndef _OBJECT_TICK_SCHEDULER_INITIALIZE_
                define _OBJECT_TICK_SCHEDULER_INITIALIZE_
; -----------------------------------------
; инициализация планировщика по умолчанию
; In:
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу работы с объектами (страница 0)
; ----------------------------------------
Initialize:     ; порядок чанков по умолчанию: 0..35
                LD HL, TickScheduler.Variables + FTickScheduler.ChunkOrder
                LD B, MAX_WORLD_CHUNK_SIZE
                XOR A

.FillChunkOrder LD (HL), A
                INC HL
                INC A
                DJNZ .FillChunkOrder

                ; FTickScheduler.Flags
                LD (HL), CHUNK_ORDER_NEED_REBUID                                ; первоначальный запрос на построение ChunkOrder
                INC HL

                ; FTickScheduler.CadenceStep
                LD (HL), #01                                                    ; первая эпоха начинается с прохода 1/2;
                                                                                ; шаг 0 будет выполнен после шагов 1..7
                INC HL

                ; FTickScheduler.LastCenterChunk
                LD A, #FF
                LD (HL), A                                                      ; #FF не является допустимым номером чанка
                                                                                ; и гарантирует первое перестроение после начальной эпохи
                INC HL
                XOR A

                ; Range_0: [0 .. 11]
                LD (HL), A                                                      ; FCadenceRange.FirstIndex
                INC HL
                LD (HL), A                                                      ; FCadenceRange.CadencePassId
                INC HL
                LD (HL), A                                                      ; FCadenceRange.Pointer
                INC HL

                ; Range_1: [12 .. 23]
                LD (HL), 12                                                     ; FCadenceRange.FirstIndex
                INC HL
                LD (HL), A                                                      ; FCadenceRange.CadencePassId
                INC HL
                LD (HL), 12                                                     ; FCadenceRange.Pointer
                INC HL

                ; Range_2: [24 .. 35]
                LD (HL), 24                                                     ; FCadenceRange.FirstIndex
                INC HL
                LD (HL), A                                                      ; FCadenceRange.CadencePassId
                INC HL
                LD (HL), 24                                                     ; FCadenceRange.Pointer
                RET

                endif ; ~_OBJECT_TICK_SCHEDULER_INITIALIZE_

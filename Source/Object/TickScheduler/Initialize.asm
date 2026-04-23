
                ifndef _OBJECT_TICK_SCHEDULER_INITIALIZE_
                define _OBJECT_TICK_SCHEDULER_INITIALIZE_
; -----------------------------------------
; инициализация планировщика по умолчанию
; In:
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
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
                LD (HL), %10000111                                              ; дефолтные флаги:
                                                                                ; bit 7 - требуется перестроение ChunkOrder
                                                                                ; bits 2..0 - дефолтное состояние cadence
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

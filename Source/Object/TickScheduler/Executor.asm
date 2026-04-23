
                ifndef _OBJECT_TICK_SCHEDULER_EXECUTOR_
                define _OBJECT_TICK_SCHEDULER_EXECUTOR_
; -----------------------------------------
; исполнитель планировщика обновлений тиков
; In:
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
; ----------------------------------------
Executor:       ; 0 -> барьер / проверка эпохи
                ; 1 -> "шаг обновления" 1/2
                ; 2 -> "шаг обновления" 1/4
                ; 3 -> "шаг обновления" 1/2
                ; 4 -> "шаг обновления" 1/8
                ; 5 -> "шаг обновления" 1/2
                ; 6 -> "шаг обновления" 1/4
                ; 7 -> "шаг обновления" 1/2

                LD A, (TickCounterRef)
                AND %00000111
                JP Z, CheckEpochBarrier                                         ; 0 -> барьер
                BIT 0, A
                JP NZ, RunCadence_1_2                                           ; 1, 3, 5, 7
                BIT 1, A
                JP NZ, RunCadence_1_4                                           ; 2, 6
                ; JP RunCadence_1_8                                               ; 4

; "шаг обновления" 1/8
RunCadence_1_8: ; инициализация
                LD HL, TickScheduler.Variables + FTickScheduler.Range_2 + FCadenceRange.Pointer
                LD (RunCadence.Renge_Pointer), HL
                LD A, (TickScheduler.Variables + FTickScheduler.Range_2.FirstIndex)
                LD (RunCadence.Range_FirstIdx), A                               ; установка первого индекса текущего диапазона
                LD A, #86 + (2 << 3)
                LD (RunCadence.Range_Bit), A
                JP RunCadence
; "шаг обновления" 1/4
RunCadence_1_4: ; инициализация
                LD HL, TickScheduler.Variables + FTickScheduler.Range_1 + FCadenceRange.Pointer
                LD (RunCadence.Renge_Pointer), HL
                LD A, (TickScheduler.Variables + FTickScheduler.Range_1.FirstIndex)
                LD (RunCadence.Range_FirstIdx), A                               ; установка первого индекса текущего диапазона
                LD A, #86 + (1 << 3)
                LD (RunCadence.Range_Bit), A
                JP RunCadence

; "шаг обновления" 1/2
RunCadence_1_2: ; инициализация
                LD HL, TickScheduler.Variables + FTickScheduler.Range_0 + FCadenceRange.Pointer
                LD (RunCadence.Renge_Pointer), HL
                XOR A
                LD (RunCadence.Range_FirstIdx), A                               ; установка первого индекса текущего диапазона
                LD A, #86 + (0 << 3)
                LD (RunCadence.Range_Bit), A
                ; JP RunCadence
; -----------------------------------------
; запуск "шаг обновления" тика объектов в чанке
; In:
;   HL - адрес диапозона со смещением на указатель
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
; ----------------------------------------
RunCadence:     ; основной цикл обхода объектов в чанке
.Loop           DEC HL                                                          ; переход к СadencePassId
                LD E, (HL)                                                      ; чтение текущего CadencePassId
                INC HL                                                          ; переход к указателю
                LD A, (HL)                                                      ; чтение текущего указателя в массиве ChunkOrder
                ADD A, LOW (TickScheduler.Variables + FTickScheduler.ChunkOrder)
                LD L, A
                ADC A, HIGH (TickScheduler.Variables + FTickScheduler.ChunkOrder)
                SUB L
                LD H, A
                LD A, (HL)                                                      ; чтение номера чанка из массива ChunkOrder
                CALL TickObjectChunk                                            ; тик объектов в чанке
                RET C                                                           ; время фрейма завершено

                ; проверка окончания текущего диапазона
.Renge_Pointer  EQU $+1
                LD HL, #0000                                                    ; адрес указателя диапозона
                INC (HL)                                                        ; увеличение указателя
                LD A, (HL)                                                      ; чтение текущего указателя в массиве ChunkOrder
                INC HL                                                          ; переход к первому индексу следующего диапазона
                CP (HL)
                DEC HL                                                          ; переход к указателю
                JR C, .Loop                                                     ; переход, если меньше крайнего индекса в диапазоне
                
                ; обнуление указателя в массиве ChunkOrder
.Range_FirstIdx EQU $+1
                LD (HL), #00                                                    ; установка первого индекса текущего диапазона

.Done           ; увеличение идентификатора прохода текущего "шага обновления"
                DEC HL                                                          ; переход к СadencePassId
                INC (HL)
                ; установка флага завершения текущего "шага обновления"
                LD HL, TickScheduler.Variables + FTickScheduler.Flags
.Range_Bit      EQU $+1
                DB #CB, #00                                                     ; RES n, (HL)
                RET

; барьер / проверка эпохи
CheckEpochBarrier:
                LD HL, TickScheduler.Variables + FTickScheduler.Flags
                LD A, (HL)
                AND %00000111
                RET NZ                                                          ; выход, если объекты во всех "шаг обновления" не обработались

                LD (HL), %00000111                                              ; сброс флагов cadence

                ; проверка обновление массива ChunkOrder
                LD A, (TickScheduler.Variables + FTickScheduler.Flags)
                ADD A, A
                JP NZ, Builder                                                  ; необходимо перестроить массив ChunkOrder
                RET

                endif ; ~_OBJECT_TICK_SCHEDULER_EXECUTOR_

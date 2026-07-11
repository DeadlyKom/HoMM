
                ifndef _OBJECT_TICK_SCHEDULER_EXECUTOR_
                define _OBJECT_TICK_SCHEDULER_EXECUTOR_
; -----------------------------------------
; исполнитель планировщика обновлений тиков
; In:
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу работы с объектами (страница 0)
; ----------------------------------------
Executor:       ; сохранение аппаратного кадра текущего запуска
                LD A, (TickCounterRef)
                LD (TickObjectChunk.LastFrame), A
                
                ; шаг каденции не зависит от аппаратного счётчика кадров:
                ; 0 -> барьер / проверка эпохи
                ; 1 -> "шаг обновления" 1/2
                ; 2 -> "шаг обновления" 1/4
                ; 3 -> "шаг обновления" 1/2
                ; 4 -> "шаг обновления" 1/8
                ; 5 -> "шаг обновления" 1/2
                ; 6 -> "шаг обновления" 1/4
                ; 7 -> "шаг обновления" 1/2

                LD A, (TickScheduler.Variables + FTickScheduler.CadenceStep)
                OR A
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
                LD A, CADENCE_RANGE_1_8
                JP RunCadence
; "шаг обновления" 1/4
RunCadence_1_4: ; инициализация
                LD HL, TickScheduler.Variables + FTickScheduler.Range_1 + FCadenceRange.Pointer
                LD (RunCadence.Renge_Pointer), HL
                LD A, (TickScheduler.Variables + FTickScheduler.Range_1.FirstIndex)
                LD (RunCadence.Range_FirstIdx), A                               ; установка первого индекса текущего диапазона
                LD A, CADENCE_RANGE_1_4
                JP RunCadence

; "шаг обновления" 1/2
RunCadence_1_2: ; инициализация
                LD HL, TickScheduler.Variables + FTickScheduler.Range_0 + FCadenceRange.Pointer
                LD (RunCadence.Renge_Pointer), HL
                XOR A
                LD (RunCadence.Range_FirstIdx), A                               ; установка первого индекса текущего диапазона
                LD A, CADENCE_RANGE_1_2
                ; JP RunCadence
; -----------------------------------------
; выполнение cadence-прохода по диапазону объектов
; In:
;   A  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   HL - адрес поля FCadenceRange.Pointer текущего диапазона
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу работы с объектами (страница 0)
; ----------------------------------------
RunCadence:     LD (TickObjectChunk.RelativeDeltaTime), A                       ; установка относительного временного шага: 0 - x1, 1 - x2, 2 - x4

                ; "мировой тик" не зависит от частоты cadence-диапазона
                ; при активной фазе каждый диапазон получает "мировой тик" один раз за cadence-эпоху
                CALL WorldTime.IsWorldTick
                LD (TickObjectChunk.WorldDeltaTime), A

                ; основной цикл обхода объектов в чанке
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
                LD HL, #0000                                                    ; адрес указателя диапазона
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

                ; следующий шаг разрешён только после полного завершения
                ; назначенного текущим шагом прохода диапазона
                LD HL, TickScheduler.Variables + FTickScheduler.CadenceStep
                LD A, (HL)

                ; после шага 4 последний диапазон (1/8) уже получил "мировой тик"
                CP #04
                CALL Z, WorldTime.CloseEpoch

                INC A
                AND %00000111
                LD (HL), A
                JP Z, WorldTime.AdvanceEpoch                                    ; переход 7 -> 0: начало новой cadence-эпохи
                RET

; барьер / проверка эпохи
CheckEpochBarrier:
                ; шаг 0 служит барьером после перехода 7 -> 0;
                ; рабочие проходы текущей эпохи начинаются с шага 1
                LD A, #01
                LD (TickScheduler.Variables + FTickScheduler.CadenceStep), A

                ; получение номера центрального чанка видимой области.
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                ADD A, SCR_WORLD_SIZE_X >> 1                                    ; добавляем половину размера окна
                LD E, A
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                ADD A, SCR_WORLD_SIZE_Y >> 1                                    ; добавляем половину размера окна
                LD D, A
                ; -----------------------------------------
                ; получение номера чанка
                ; In:
                ;   DE - координаты в тайлах (D - y, E - x)
                ; Out:
                ;   A  - порядковый номер чанка
                ; Corrupt:
                ;   HL, AF
                ; Note:
                ; -----------------------------------------
                CALL ChunkArray.GetChunkIndex
                LD C, A                                                         ; текущий центральный чанк

                ; перестроение требуется после смены центрального чанка
                LD A, (TickScheduler.Variables + FTickScheduler.LastCenterChunk)
                CP C
                JR NZ, .RebuildChunkOrder

                LD HL, TickScheduler.Variables + FTickScheduler.Flags
                BIT CHUNK_ORDER_NEED_REBUID_BIT, (HL)                           ; проверка принудительного запроса на перестроение ChunkOrder
                RET Z                                                           ; выход, если порядок чанков остался актуальным

.RebuildChunkOrder:
                LD A, C
                LD (TickScheduler.Variables + FTickScheduler.LastCenterChunk), A
                JP BuilderTwoPass

                endif ; ~_OBJECT_TICK_SCHEDULER_EXECUTOR_

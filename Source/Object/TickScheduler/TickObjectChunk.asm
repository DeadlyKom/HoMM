
                ifndef _OBJECT_TICK_SCHEDULER_TICK_OBJECT_CHUNK_
                define _OBJECT_TICK_SCHEDULER_TICK_OBJECT_CHUNK_
; -----------------------------------------
; тик объектов в чанке
; In:
;   A - номер чанка
;   E - текущий CadencePassId
; Out:
;   Carry установлен, если во время обхода начался новый кадр;
;   Carry сброшен, если объекты в чанке закончились или отсутствовали
; Corrupt:
;   все регистры
; Note:
;   необходимо включить страницу работы с объектами (страница 0)
; ----------------------------------------
TickObjectChunk:; получение объектов в чанке

                ; -----------------------------------------
                ; получение адреса указанного чанка
                ; In:
                ;   A  - порядковый номер чанка
                ;   HL - адрес счётчиков массива чанков (выровненный 256 байт)
                ; Out:
                ;   HL - начальный адрес счётчиков в указанном чанке
                ;   A  - количество пройденных элементов/начальный адрес расположения элементов
                ; Corrupt:
                ;   L, BC, AF
                ; Note:
                ; -----------------------------------------
                LD HL, Adr.ChunkArrayCounters
                CALL ChunkArray.GetAddress
                EX AF, AF'
                LD A, (HL)
                OR A
                RET Z                                                           ; выход, если отсутствуют объекты в чанке

                LD C, A                                                         ; количество объектов в чанке
                LD B, E                                                         ; сохранение текущего CadencePassId в B
                EX AF, AF'
                LD L, A
                INC H                                                           ; переход на страницу значений чанка
                EX DE, HL

.Loop           LD A, (DE)                                                      ; чтение ID объекта
                CALL Object.Utilities.GetAdr.IX

                BIT OBJECT_TICK_ENABLED_BIT, (IX + FObject.Flags)
                JR Z, .SkipObject

                LD A, B                                                         ; текущий CadencePassId диапазона
                CP (IX + FObject.CadencePassID)
                JR Z, .SkipObject

                ; помечаем объект до тика, чтобы исключить повторную обработку
                ; при переносе в другой чанк/диапазон во время тика
                LD (IX + FObject.CadencePassID), B

                ; установить Carry согласно активной фазе "мирового тика" текущего cadence-прохода
.WorldDeltaTime EQU $
                DB #00                                                          ; код команды OR A или SCF
                EX AF, AF'                                                      ; сохранить Carry в альтернативном регистре флагов

                ; тик объекта в чанке
                LD A, (IX + FObject.Class)
                AND OBJECT_CLASS_MASK

                ifdef _DEBUG
                CP OBJECT_CLASS_MAX
                DEBUG_BREAK_POINT_NC
                endif

                LD HL, TickObjectJumpTable
                PUSH BC                                                         ; сохранение CadencePassId и количества оставшихся объектов
                PUSH DE                                                         ; сохранение указателя на текущий объект в массиве чанка
.RelativeDeltaTime EQU $+1
                LD C, #00                                                       ; относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
                CALL Func.JumpTable
                POP DE
                POP BC

.SkipObject     OR A                                                            ; текущий кадр не завершён
                DEC C
                RET Z                                                           ; выход, если объекты в чанке закончились

                ; проверка смены фрейма
                LD A, (TickCounterRef)
.LastFrame      EQU $+1
                SUB #00
                SCF                                                             ; текущий кадр завершён
                RET NZ                                                          ; выход, если фрейм сменился, продолжим в следующем таком же "шаге обновления"
                INC E                                                           ; следующий объект в массиве
                JR .Loop

; -----------------------------------------
; диспетчер тика объекта
; In:
;   IX - адрес структуры объекта (FObject)
;   C  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   F' - Carry установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   все регистры, кроме IX
; ----------------------------------------
TickObjectJumpTable:
                DW Page0.Tick.Object.Character                                  ; OBJECT_CLASS_CHARACTER
                DW Page0.Tick.Object.CharacterAI                                ; OBJECT_CLASS_CHARACTER_AI
                DW TickObject_NoTick                                            ; OBJECT_CLASS_CONSTRUCTION
                DW TickObject_NoTick                                            ; OBJECT_CLASS_PROPS
                DW TickObject_NoTick                                            ; OBJECT_CLASS_INTERACTION
                DW TickObject_NoTick                                            ; OBJECT_CLASS_PARTICLE
                DW TickObject_NoTick                                            ; OBJECT_CLASS_DECAL
                DW TickObject_NoTick                                            ; OBJECT_CLASS_UI
TickObject_NoTick:
                RET

                endif ; ~_OBJECT_TICK_SCHEDULER_TICK_OBJECT_CHUNK_

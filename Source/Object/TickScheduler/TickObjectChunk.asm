
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
;   ℹ️ код расположен в странице 0
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
                LD (.CurrentChunk), A                                           ; сохранение номера обрабатываемого чанка
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

                ; проверка флага, разрешающего тик объекта
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

                ; проверка флага, разрешающего проверку попадания курсора в bound объекта
                BIT OBJECT_CURSOR_HIT_TEST_BIT, (IX + FObject.Flags)
                CALL NZ, CursorHitTest

                ; сохранение количества объектов до тика
                LD A, (GameSession.WorldInfo + FWorldInfo.ObjectNum)
                LD (SpawnOffset.OldObjectNum), A

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

                ; проверка количества созданных объектов
                LD A, (GameSession.WorldInfo + FWorldInfo.ObjectNum)
                LD HL, SpawnOffset.OldObjectNum
                SUB (HL)
                CALL NZ, SpawnOffset                                            ; корректировка указателя, если созданы новые объекты

                ; проверка необходимости удаления объекта
                BIT OBJECT_PENDING_KILL_STATE_BIT, (IX + FObject.Flags)
                JR NZ, .RemoveObject

.SkipObject     OR A                                                            ; сброс флага Carry, текущий кадр не завершён
                DEC C
                RET Z                                                           ; выход, если объекты в чанке закончились

                ; проверка смены фрейма
                LD A, (TickCounterRef)
.LastFrame      EQU $+1
                SUB #00
                SCF                                                             ; текущий кадр завершён
                RET NZ                                                          ; выход, если фрейм сменился, продолжим в следующем таком же "шаге обновления"
                INC E                                                           ; следующий объект в массиве
                
                ; корректировка указателя после перемещения объекта между чанками
                LD A, (IX + FObject.Chunk)
.CurrentChunk   EQU $+1
                CP #00
                JR C, .Loop                                                     ; при переносе назад указатель уже установлен на следующий объект
                JR Z, .Loop                                                     ; объект остался в текущем чанке

                DEC E                                                           ; при переносе вперёд следующий объект сместился на текущий адрес
                JR .Loop

.RemoveObject   ; удаление текущего объекта
                PUSH BC
                PUSH DE
                PUSH IX
                POP IY
                CALL Object.SmartRemove
                POP DE
                POP BC

                OR A                                                            ; сброс флага Carry, текущий кадр не завершён
                DEC C
                RET Z                                                           ; выход, если объекты в чанке закончились

                ; проверка смены фрейма
                LD A, (TickCounterRef)
                LD HL, .LastFrame
                CP (HL)
                SCF                                                             ; текущий кадр завершён
                RET NZ                                                          ; выход, если фрейм сменился

                JR .Loop                                                        ; следующий ID сместился на текущий адрес
; -----------------------------------------
; корректировка указателя текущего объекта после создания объектов
; In:
;   A  - количество созданных объектов
;   DE - адрес текущего объекта в Adr.ChunkArrayValues
; Out:
;   DE - скорректированный адрес текущего объекта в Adr.ChunkArrayValues
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
SpawnOffset     PUSH BC
                PUSH DE
                LD B, A                                                         ; количество созданных объектов
                LD C, #00                                                       ; смещение адреса текущего объекта

                ; получение адреса первого созданного объекта
.OldObjectNum   EQU $+1
                LD A, #00                                                       ; ID первого созданного объекта
                CALL Object.Utilities.GetAdr.HL

                ; переход к номеру чанка первого созданного объекта
                LD DE, FObject.Chunk
                ADD HL, DE
                LD A, (TickObjectChunk.CurrentChunk)
                LD D, A                                                         ; номер обрабатываемого чанка

.Loop           ; проверка чанка созданного объекта
                LD A, D                                                         ; номер обрабатываемого чанка
                CP (HL)                                                         ; сравнение с чанком созданного объекта
                JR C, .Next                                                     ; объект создан после обрабатываемого чанка
                INC C                                                           ; увеличение смещения текущего объекта

.Next           ; переход к следующему созданному объекту
                LD A, L
                ADD A, OBJECT_SIZE
                LD L, A
                JR NC, $+3
                INC H

                DJNZ .Loop

                ; применение накопленного смещения
                LD A, C
                POP DE
                POP BC
                ADD A, E
                LD E, A                                                         ; корректировка указателя текущего объекта
                RET
; -----------------------------------------
; проверка попадания курсора в bound объекта
; In:
;   IX - адрес структуры объекта (FObject)
; Out:
;   OBJECT_CURSOR_HIT_STATE установлен, если курсор находится в bound объекта;
;   OBJECT_CURSOR_HIT_STATE сброшен, если курсор находится вне bound объекта
; Corrupt:
;   AF
; Note:
;   проверка попадания выполняется только в диапазоне Range_0
;   код расположен в странице 0
; -----------------------------------------
CursorHitTest   ; проверка диапозона
                LD A, (TickObjectChunk.RelativeDeltaTime)
                OR A
                JR NZ, .CursorMiss                                              ; переход, если диапазон не нулевой

                ; проверка по горизонтали
                LD A, (Mouse.PositionX)
                SUB (IX + FObject.Bound + FSpriteBound.Location.X)
                JR C, .CursorMiss                                               ; переход, если курсор находится левее bound объекта
                CP (IX + FObject.Bound + FSpriteBound.Size.Width)
                JR NC, .CursorMiss                                              ; переход, если курсор находится правее bound объекта

                ; проверка по вертикали
                LD A, (Mouse.PositionY)
                SUB (IX + FObject.Bound + FSpriteBound.Location.Y)
                JR C, .CursorMiss                                               ; переход, если курсор находится выше bound объекта
                CP (IX + FObject.Bound + FSpriteBound.Size.Height)
                JR NC, .CursorMiss                                              ; переход, если курсор находится ниже bound объекта

                SET OBJECT_CURSOR_HIT_STATE_BIT, (IX + FObject.Flags)           ; установка флага нахождения курсор в bound объекте
                RET

.CursorMiss     RES OBJECT_CURSOR_HIT_STATE_BIT, (IX + FObject.Flags)           ; сброс флага нахождения курсор в bound объекте
                RET
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
                DW Page0.Tick.Object.UI                                         ; OBJECT_CLASS_UI
TickObject_NoTick:
                RET

                endif ; ~_OBJECT_TICK_SCHEDULER_TICK_OBJECT_CHUNK_

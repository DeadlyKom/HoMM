
                ifndef _OBJECT_SPAWN_
                define _OBJECT_SPAWN_
; -----------------------------------------
; спавн объекта
; In:
;   B  - тип объекта (настройки по умолчанию)
;   DE - положение объекта в знакоместах (D - y, E - x)
; Out:
;   A' - идентификатор объекта
;   IX - адрес структуры FObjectDefaultSettings
;   IY - адрес структуры FObject
;   флаг переполнения Carry установлен, если нет свободного места в массиве
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
; -----------------------------------------
Spawn:          ; -----------------------------------------
                ; размещение нового объекта
                ; In:
                ;   флаг переполнения отвечает с каким массивом объектов производится работа
                ;   если сброшен, то работа с Adr.StaticArray иначе с Adr.DynamicArray
                ; Out:
                ;   A' - текущий ID объекта
                ;   IY - адрес свободного элемента
                ;   флаг переполнения Carry установлен, если нет свободного места в массиве
                ; Corrupt:
                ;   HL, AF, AF'
                ; Note:
                ; -----------------------------------------
                CALL Object.PlacemantNew
                RET C                                                           ; выход, если ошибка - нет места для размещения объекта

                ; сохранение ID объекта
                EX AF, AF'
                LD C, A

                PUSH BC                                                         ; сохранение тип объекта и ID объекта

                ; -----------------------------------------
                ; установка положения объекта
                ; -----------------------------------------
                SRL E
                LD H, E
                LD L, #00
                RR L
                LD (IY + FObject.Position.X), HL

                SRL D
                LD H, D
                LD L, #00
                RR L
                LD (IY + FObject.Position.Y), HL

                ; -----------------------------------------
                ; получение номера чанка
                ; In:
                ;   DE - координаты в тайлах (D - y, E - x)
                ; Out:
                ;   A  - порядковый номер чанка
                ; Corrupt:
                ;   D, AF
                ; Note:
                ; -----------------------------------------
                CALL ChunkArray.GetChunkIndex
                LD (IY + FObject.Chunk), A                                      ; информация о чанке

                ; -----------------------------------------
                ; вставка значения в массив чанков
                ; In:
                ;   A  - порядковый номер чанка
                ;   HL - адрес счётчиков массива чанков (выровненый 256 байт)
                ;   D  - добавляемое значение
                ;   E  - количество элементов в массиве
                ; Out:
                ; Corrupt:
                ;   L, BC, AF
                ; Note:
                ; -----------------------------------------
                LD HL, Adr.ChunkArrayCounters
                LD D, C
                LD E, C
                ; -----------------------------------------
                ; вставка значения в массив чанков
                ; In:
                ;   A  - порядковый номер чанка
                ;   HL - адрес счётчиков массива чанков (выровненый 256 байт)
                ;   D  - добавляемое значение
                ;   E  - количество элементов в массиве
                ; Out:
                ; Corrupt:
                ;   L, BC, AF, AF'
                ; Note:
                ; -----------------------------------------
                CALL ChunkArray.Insert

                ; -----------------------------------------
                ; установка значений по умолчанию
                ; -----------------------------------------

                ; адрес структуры FObjectDefaultSettings настроек по умолчанию
                POP BC
                LD A, C                                                         ; восстановление ID объекта
                EX AF, AF'
                LD A, B
                LD (IY + FObject.Settings), A                                   ; настройки объекта по умолчанию
                ADD A, A    ; x2
                LD L, A
                LD H, #00
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                LD A, H
                ADD A, HIGH Adr.ObjectDefaultSettings
                LD IXH, A
                LD A, L
                LD IXL, A

                LD A, (IX + FObjectDefaultSettings.Class)
                AND OBJECT_CLASS_MASK
                LD (IY + FObject.Class), A                                      ; сохранение класса объекта

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_CLASS_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого объекта
                endif

                LD HL, .JumpTable
                JP Func.JumpTable

.JumpTable      DW Object.Class.Hero                                            ; OBJECT_CLASS_HERO
                DW Object.Class.Construction                                    ; OBJECT_CLASS_CONSTRUCTION
                DW #0000                                                        ; OBJECT_CLASS_PROPS
                DW #0000                                                        ; OBJECT_CLASS_INTERACTION
                DW #0000                                                        ; OBJECT_CLASS_PARTICLE
                DW #0000                                                        ; OBJECT_CLASS_DECAL
                DW Object.Class.UI                                              ; OBJECT_CLASS_UI

                display " - Spawn object:\t\t\t\t\t", /A, Spawn, "\t= busy [ ", /D, $-Spawn, " byte(s)  ]"

                endif ; ~_OBJECT_PLACEMENT_NEW_

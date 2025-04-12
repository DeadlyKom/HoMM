
                ifndef _MODULE_MAP_LOAD_OBJECTS_
                define _MODULE_MAP_LOAD_OBJECTS_
; -----------------------------------------
; инициализация объектов карты после загрузки
; In:
;   HL - адрес FMapHeader.ObjectNum
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load_Objects:   ; чтение данных об объектах
                LD A, (HL)                                                      ; FMapHeader.ObjectNum
                INC HL
                LD E, (HL)                                                      ; FMapHeader.ObjectOffset.Low
                INC HL
                LD D, (HL)                                                      ; FMapHeader.ObjectOffset.High
                ADD HL, DE

                PUSH AF
                EX DE, HL

                ; -----------------------------------------
                ; копирование объектов во временный буфер
                ; -----------------------------------------

                ; умножение FMapHeader.ObjectNum * FMapObject
                LD B, #00
                LD C, A
                LD H, B
                LD L, B
                LD A, FMapObject

.MultiplyLoop   ADD HL, BC
                DEC A
                JR NZ, .MultiplyLoop

                LD B, H
                LD C, L

                LD HL, Adr.ExtraBuffer
                EX DE, HL
                CALL Memcpy.FastLDIR

                ; -----------------------------------------
                ; инициализация объектов
                ; -----------------------------------------
                SET_PAGE_WORLD                                                  ; включить страницу работы с картой "мира"
                POP BC
                LD HL, Adr.ExtraBuffer

.ObjectLoop     PUSH BC
                LD A, (HL)                                                      ; FMapObject.Type
                INC HL
                SRL A

                PUSH AF                                                         ; сохранение типа объекта по умолчанию
                PUSH HL
                ; -----------------------------------------
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
                DEBUG_BREAK_POINT_C                                             ; ошибка, нет места для размещения объекта
                POP HL

                ; -----------------------------------------
                ; установка положения объекта
                ; -----------------------------------------
                LD E, (HL)                                                      ; FMapObject.Position.X
                INC HL

                LD A, E
                SRL A
                EX AF, AF'
                LD C, A                                                         ; номер текущего ID объекта

                EX HL, DE
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                LD (IY + FObject.Position.X), HL
                EX HL, DE

                LD E, (HL)                                                      ; FMapObject.Position.Y
                INC HL

                LD A, E
                SRL A
                
                EX HL, DE
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                LD (IY + FObject.Position.Y), HL
                EX HL, DE

                LD D, A
                EX AF, AF'
                LD E, A
                ; -----------------------------------------
                ; получение номера чанка
                ; In:
                ;   DE - координаты в тайлах (D - y, E - x)
                ; Out:
                ;   A  - порядковый номер чанка [0..127]
                ; Corrupt:
                ;   D, AF
                ; Note:
                ; -----------------------------------------
                CALL ChunkArray.GetChunkIndex
                LD (IY + FObject.Chunk), A                                      ; информация о чанке
                LD D, A

                POP AF                                                          ; восстановление типа объекта по умолчанию
                LD (IY + FObject.Settings), A                                   ; настройки объекта по умолчанию
                PUSH HL

                ; корректировка адреса буфера чанков 
                LD HL, Adr.StaticChunkArray | 0x80
                JR NC, $+4
                LD H, HIGH Adr.DynamicChunkArray

                LD A, D
                LD D, C
                LD E, C
                
                ; -----------------------------------------
                ; вставка значения в массив чанков
                ; In:
                ;   A  - порядковый номер чанка [0..127]
                ;   HL - адрес массива чанков (выровненый 256 байт) + 0x80
                ;   D  - добавляемое значение
                ;   E  - количество элементов в массиве
                ; Out:
                ; Corrupt:
                ;   L, BC, AF
                ; Note:
                ; -----------------------------------------
                CALL ChunkArray.Insert

                ; -----------------------------------------
                ; установка значений по умолчанию
                ; -----------------------------------------

                ; адрес структуры FObjectDefaultSettings настроек по умолчанию
                LD A, (IY + FObject.Settings)
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
                CALL Func.JumpTable
                POP HL
                POP BC

                DJNZ .ObjectLoop
                RET

.JumpTable      DW #0000                                                        ; OBJECT_CLASS_CHARACTER
                DW Object.Class.Construction                                    ; OBJECT_CLASS_CONSTRUCTION
                DW #0000                                                        ; OBJECT_CLASS_PROPS
                DW #0000                                                        ; OBJECT_CLASS_INTERACTION
                DW #0000                                                        ; OBJECT_CLASS_PARTICLE
                DW #0000                                                        ; OBJECT_CLASS_DECAL
                DW #0000                                                        ; OBJECT_CLASS_DECAL

                endif ; ~_MODULE_MAP_LOAD_OBJECTS_

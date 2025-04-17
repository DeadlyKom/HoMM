
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
                CALL .ObjectInit
                POP BC

                DJNZ .ObjectLoop
                RET

.ObjectInit     LD A, (HL)                                                      ; FMapObject.Type
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
                LD D, (HL)                                                      ; FMapObject.Position.X
                INC HL
                SRL D
                LD E, #00
                RR E
                LD (IY + FObject.Position.X), DE

                EX AF, AF'
                LD C, A                                                         ; номер текущего ID объекта

                LD D, (HL)                                                      ; FMapObject.Position.Y
                INC HL
                SRL D
                LD E, #00
                RR E
                LD (IY + FObject.Position.Y), DE

                EX AF, AF'
                LD E, A

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
                LD D, A

                POP AF                                                          ; восстановление типа объекта по умолчанию
                LD (IY + FObject.Settings), A                                   ; настройки объекта по умолчанию
                PUSH HL

                LD A, D
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
                ;   L, BC, AF
                ; Note:
                ; -----------------------------------------
                LD HL, Adr.ChunkArrayCounters
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

                ; -----------------------------------------
                ; инициализация спрайта
                ; -----------------------------------------
                LD A, (HL)                                                      ; FMapObject.SpriteIndex
                INC HL
                PUSH HL

                ; определение адреса расположения необходимой структуры FSprite
                LD HL, (GameState.Assets + FAssets.Address.Adr)                 ; адрес загрузки ассета графического ассета
                ADD A, L
                LD E, A
                ADC A, H
                SUB E
                LD D, A

                ; включение страницы ресурса
                LD A, (GameState.Assets + FAssets.Address.Page)
                CALL SetPage

                ; -----------------------------------------
                ; добавление спрайта
                ; In:
                ;   DE - адрес структуры FSprite
                ; Out:
                ;   A  - индекс спрайта в буфере спрайтов (Adr.SpriteInfoBuffer)
                ;   HL - адрес структуры FSprite (текущего спрайта)
                ;   флаг переполнения Carry сброшен, если спрайт не был добавлен
                ; Corrupt:
                ;   HL, DE, B, AF
                ; Note:
                ;   * структура FSprite расположена в буфере SpriteInfoBuffer нелинейно, переход между полями изменяя старший адрес
                ;   * автоматически корректирует адрес и страницу после загрузки ассета
                ; -----------------------------------------
                CALL Sprite.Add                                                 ; добавление спрайта в общий список
                LD L, A
                SET_PAGE_WORLD                                                  ; включить страницу работы с картой "мира"
                LD (IY + FObject.Sprite), L                                     ; установка индекс спрайта в буфере спрайтов Adr.SpriteInfoBuffer

                POP HL
                RET

.JumpTable      DW #0000                                                        ; OBJECT_CLASS_CHARACTER
                DW Object.Class.Construction                                    ; OBJECT_CLASS_CONSTRUCTION
                DW #0000                                                        ; OBJECT_CLASS_PROPS
                DW #0000                                                        ; OBJECT_CLASS_INTERACTION
                DW #0000                                                        ; OBJECT_CLASS_PARTICLE
                DW #0000                                                        ; OBJECT_CLASS_DECAL
                DW #0000                                                        ; OBJECT_CLASS_DECAL

                endif ; ~_MODULE_MAP_LOAD_OBJECTS_

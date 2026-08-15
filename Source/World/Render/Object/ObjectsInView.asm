
                ifndef _WORLD_OBJECTS_IN_VIEW_
                define _WORLD_OBJECTS_IN_VIEW_
; -----------------------------------------
; формирование списка объектов в области видимости
; In:
; Out:
;   Adr.SortBuffer - адреса объектов в порядке Decal, World, UI
;   A              - количество объектов в массиве
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу 0
; -----------------------------------------
InView:         ; инициализация
                XOR A
                LD (.Num), A
                LD (AddObjects.Offset), A
                LD (AddObjects.OffsetUI), A
                LD (AddObjects.OffsetDecal), A
                LD IX, AddObjects
                EXX

                ; формирование рамки захвата
                LD HL, GameSession.WorldInfo + FWorldInfo.MapPosition
                LD BC, #0101                                                    ; минимальное захватываемое окно в чанках
                LD E, (HL)                                                      ; X
                INC L
                LD D, (HL)                                                      ; Y

                ; корректировка ширины захвата чанков, если не выровнено
                LD A, E
                CP MAX_WORLD_HEX_X - Page0.ChunkArray.CHUNK_SIZE
                JR NC, $+7                                                      ; пропуск, если достигнут правый край массива чанков
                AND Page0.ChunkArray.CHUNK_SIZE_MASK
                JR Z, $+3
                INC C

                ; корректировка высоты захвата чанков, если не выровнено
                LD A, D
                CP MAX_WORLD_HEX_Y - Page0.ChunkArray.CHUNK_SIZE
                JR NC, $+7                                                      ; пропуск, если достигнут нижний край массива чанков
                AND Page0.ChunkArray.CHUNK_SIZE_MASK
                JR Z, $+3
                INC B

                ifdef _DEBUG
                LD (.VisibleSize), BC
.VisibleSize    EQU $+1
                LD BC, #0000
                endif
                
                ; -----------------------------------------
                ; получение значений в области
                ; In:
                ;   HL - адрес счётчиков массива чанков (выровнен на границу 256 байт)
                ;   DE - координаты области в тайлах (D - y, E - x)
                ;   BC - размер охватываемой области в чанках (B - y, C - x)
                ;   IX - адрес обработчика добавления объектов
                ;       A - количество добавляемых элементов
                ;       H - старший адрес текущего массива чанков
                ;       E - смещение в массиве чанков первого элемента
                ; Out:
                ; Corrupt:
                ;   L, DE, BC, AF
                ; Note:
                ; -----------------------------------------
                LD HL, Adr.ChunkArrayCounters
                CALL ChunkArray.Area
                
                EXX

.Num            EQU $+1
                LD A, #00
                OR A                                                            ; выставление флагов
                RET
; -----------------------------------------
; добавление объектов чанка в список видимых объектов
; In:
;   A  - количество добавляемых элементов
;   H  - старший адрес текущего массива чанков
;   E  - смещение в массиве чанков первого элемента
; Out:
;   Adr.SortBuffer - адреса объектов в порядке Decal, World, UI
;   InView.Num     - количество объектов в SortBuffer
; Corrupt:
;   HL, BC, AF, HL', DE', BC', AF'
; Note:
;   SortBuffer хранит адреса FObject, а не адреса полей FObject.Position.Y.
;   Decal размещаются с конца буфера в обратном направлении.
;   World размещаются с начала буфера и сортируются по FObject.Position.Y.
;   UI размещаются после World и сортируются по FObjectUI.ZOrder.
; -----------------------------------------
AddObjects:     ; инициализация
                PUSH HL                                                         ; сохранить текущий адрес массива чанков
                LD L, E                                                         ; смещение в массиве чанков первого элемента
                EX (SP), HL                                                     ; восстановить адрес массива чанков
                                                                                ; и сохранить адрес первого элемента в массиве чанков
                EXX
                LD B, A                                                         ; количество добавляемых элементов
                POP HL                                                          ; восстановить адрес первого элемента в массиве чанков
                INC H                                                           ; переход на массив значений

.Loop           ; обработка следующего элемента массива чанка

                ; чтение индекса объекта из массива чанка
                LD A, (HL)
                INC L

                CALC_OBJECT_ADD C                                               ; расчёт адреса объекта
                                                                                ;   С:A - адрес объекта
                ; вставка объекта с учётом его слоя и порядка отображения
                PUSH HL
                PUSH BC

                LD D, HIGH Adr.SortBuffer                                       ; старший байт адреса SortBuffer
.Offset         EQU $+1                                                         ; количество объектов в областях World и UI
                LD E, #00
                SLA E   ; x2

                CALL .InsertObject                                              ; вставка объекта в массив

                ; увеличение количества объектов в массиве
                LD HL, InView.Num
                INC (HL)

                POP BC
                POP HL

                DJNZ .Loop

                EXX
                RET
; -----------------------------------------
; вставить один объект в SortBuffer
; In:
;   DE  - адрес следующей свободной ячейки SortBuffer
;   С:A - адрес объекта
; Out:
;   Adr.SortBuffer - список адресов объектов
; Corrupt:
;   AF, BC, DE, HL
; Note:
; -----------------------------------------
.InsertObject   ; инициализация
                LD L, A
                LD H, C

                ; HL - адрес вставляемого объекта
                ; DE - адрес следующей свободной ячейки SortBuffer

                ; распределение вставляемого объекта
                LD A, (HL)
                AND OBJECT_CLASS_MASK
                SUB OBJECT_CLASS_DECAL
                JR Z, .InsertDecal                                              ; переход, если вставка Decal объекта

                ; увеличение количества объектов в областях World и UI
                PUSH HL
                LD HL, .Offset
                INC (HL)
                POP HL

                DEC A   ; OBJECT_CLASS_UI
                JR Z, .InsertUI                                                 ; переход, если вставка UI объекта

                ; -----------------------------------------
                ; вставка объекта перед UI с сортировкой по оси Y
                ; -----------------------------------------

                ; проверка наличия объектов в области UI
.OffsetUI       EQU $+1
                LD A, #00
                CP E
                JR Z, .PassedUI

                PUSH HL ; сохранение адреса вставляемого объекта

                ; инициализация размера перемещения UI объектов
                SUB E
                NEG
                LD B, #00
                LD C, A

                ; инициализация адресов перемещения UI объектов
                LD L, E
                LD H, D
                DEC L
                INC E

                ; перемещение объектов UI
.MemmoveLoop    LDD
                LDD
                JP PE, .MemmoveLoop
                
                DEC E   ; DE - адрес вставки в SortBuffer
                POP HL  ; восстановление адреса вставляемого объекта

.PassedUI       ; сохранение нового смещения начала области UI
                LD A, E
                ADD A, #02
                LD (.OffsetUI), A

                ; вставка нового объекта в список
                EX DE, HL
                LD (HL), E
                INC L
                LD (HL), D
                INC L
                EX DE, HL

                ; определение количества World объектов,
                ; требующих сортировки по оси Y
                LD A, E
                SRL A   ; /2
                DEC A
                LD B, A
                RET Z                                                           ; выход, если это первый World объект

                ; установка HL на младший байт последнего элемента списка
                EX DE, HL
                DEC L
                DEC L

.InsertLoop     PUSH BC

                ; чтение адреса текущего объекта
                LD E, (HL)
                INC L
                LD D, (HL)
                DEC L

                ; чтение Y текущего элемента
                INC E                                                           ; пропуск FObject.Class
                INC E                                                           ; пропуск FObject.Flags
                EX DE, HL
                LD C, (HL)                                                      ; чтение Object.Position.Y.Low
                INC L
                LD B, (HL)                                                      ; чтение Object.Position.Y.High
                EX DE, HL

                ; чтение адреса предыдущего элемента
                DEC L
                LD D, (HL)
                DEC L
                LD E, (HL)

                INC E                                                           ; пропуск FObject.Class
                INC E                                                           ; пропуск FObject.Flags

                ; HL - адрес SortBuffer предыдущего элемента
                ; DE - адрес поля Position.Y предыдущего объекта
                ; BC - значение оси Y текущего элемента

                ; проверка старшего байта Y предыдущего объекта
                INC E                                                           ; переход к адресу Object.Position.Y.High
                LD A, (DE)
                DEC E                                                           ; переход к адресу Object.Position.Y.Low
                CP B
                JR C, .InsertDone                                               ; переход, если предыдущий объект выше текущего
                JR NZ, .Swap                                                    ; переход, если предыдущий объект ниже текущего

                ; проверка младшего байта Y предыдущего объекта
                LD A, (DE)
                CP C
                JR C, .InsertDone                                               ; переход, если предыдущий объект выше текущего
                JR Z, .InsertDone                                               ; переход, если объекты находятся на одной Y

.Swap           ; -----------------------------------------
                ; обмен адресов двух объектов
                ; -----------------------------------------
                
                ; обмен предыдущего и текущего элемента SortBuffer
                DEC E                                                           ; переход к адресу Object.FObject.Flags
                DEC E                                                           ; переход к адресу Object.FObject.Class

                ; переход к адресу SortBuffer текущего элемента
                LD B, L                                                         ; сохранение младшего адреса SortBuffer предыдущего элемента
                INC L
                INC L

                ; чтение адреса текущего объекта с последующей записью адреса предыдущего объекта
                LD C, (HL)
                LD (HL), E
                INC L
                LD A, (HL)
                LD (HL), D

                ; запись адреса текущего объекта в адрес SortBuffer предыдущего элемента
                LD L, B                                                         ; восстановление младшего адреса SortBuffer предыдущего элемента
                LD (HL), C
                INC L
                LD (HL), A
                DEC L

                POP BC
                DJNZ .InsertLoop

                RET

.InsertDone     POP BC
                RET
; -----------------------------------------
; вставить один Decal объект в SortBuffer
; In:
;   HL - адрес вставляемого объекта
;   D  - старший байт адреса Adr.SortBuffer
; Out:
;   Adr.SortBuffer - объект добавлен в начало области Decal
; Corrupt:
;   AF, DE, HL
; Note:
;   область Decal растёт от конца SortBuffer к его началу двухбайтовыми элементами
; -----------------------------------------
.InsertDecal    ; сохранение нового смещения начала области Decal
.OffsetDecal    EQU $+1
                LD A, #00
                SUB #02
                LD (.OffsetDecal), A

                LD E, A

                ; вставка нового Decal объекта в список
                EX DE, HL
                LD (HL), E
                INC L
                LD (HL), D

                RET
; -----------------------------------------
; вставить один UI объект в SortBuffer
; In:
;   HL - адрес вставляемого объекта
;   DE - адрес следующей свободной ячейки SortBuffer
; Out:
;   Adr.SortBuffer - область UI отсортирована по FObjectUI.ZOrder
; Corrupt:
;   AF, BC, DE, HL
; Note:
;   сортировка сохраняет порядок добавления объектов с одинаковым ZOrder
; -----------------------------------------
.InsertUI       ; вставка нового UI объекта в список
                EX DE, HL
                LD (HL), E
                INC L
                LD (HL), D
                INC L

                ; определение количества UI объектов,
                ; требующих сортировки по ZOrder
                LD A, (.OffsetUI)
                NEG
                ADD A, L

                SRL A
                DEC A
                LD B, A
                RET Z                                                           ; выход, если это первый UI объект

                ; установка HL на младший байт последнего элемента списка
                DEC L
                DEC L

.SortUI         ; чтение ZOrder текущего UI объекта
                LD A, (HL)
                OR FObjectUI.ZOrder
                LD E, A
                INC L
                LD D, (HL)
                DEC L
                LD A, (DE)                                                      ; чтение ZOrder текущего элемента
                LD C, A

                ; чтение ZOrder предыдущего UI объекта
                DEC L
                LD D, (HL)
                DEC L
                LD A, (HL)
                OR FObjectUI.ZOrder
                LD E, A

                ; проверка ZOrder объектов
                LD A, (DE)
                CP C
                RET Z                                                           ; выход, если значения ZOrder равны
                RET C                                                           ; выход, если ZOrder предыдущего объекта меньше

                ; -----------------------------------------
                ; обмен адресов двух UI объектов
                ; -----------------------------------------
                
                LD A, (HL)
                LD C, L                                                         ; сохранение младшего адреса SortBuffer предыдущего элемента
                
                ; переход к адресу SortBuffer текущего элемента
                INC L
                INC L

                INC L                                                           ; переход к старшему адресу текущего элемента
                LD E, (HL)                                                      ; чтение старшего адреса текущего UI объекта
                LD (HL), D                                                      ; запись старшего адреса предыдущего UI объекта
                
                DEC L                                                           ; переход к младшему адресу текущего элемента
                LD D, (HL)                                                      ; чтение младшего адреса текущего UI объекта
                LD (HL), A                                                      ; запись младшего адреса предыдущего UI объекта

                DEC L                                                           ; переход к старшему адресу предыдущего элемента
                LD (HL), E                                                      ; запись старшего адреса текущего UI объекта
                DEC L                                                           ; переход к младшему адресу предыдущего элемента
                LD (HL), D                                                      ; запись младшего адреса текущего UI объекта

                DJNZ .SortUI
                RET

                display " - Objects in view:\t\t\t\t\t", /A, InView, "\t= busy [ ", /D, $-InView, " byte(s)  ]"

                endif ; ~_WORLD_OBJECTS_IN_VIEW_


                ifndef _WORLD_OBJECTS_IN_VIEW_
                define _WORLD_OBJECTS_IN_VIEW_
; -----------------------------------------
; формирование списка объектов в области видимости
; In:
; Out:
;   Adr.SortBuffer - адреса объектов
;   A              - количество объектов в массиве
;   DE             - адрес последнего элемента
; Corrupt:
; Note:
;  необходимо включить страницу работы с объектами (страница 0)
; -----------------------------------------
InView:         ; инициализация
                XOR A
                LD (.Num), A
                LD IX, AddObjects
                LD DE, Adr.SortBuffer
                EXX

                ; формирование рамки захвата
                LD HL, GameSession.WorldInfo + FWorldInfo.MapPosition
                LD BC, #0101                                                    ; минимальный захватываемое окно в чанках
                LD E, (HL)                                                      ; X
                INC L
                LD D, (HL)                                                      ; Y

                ; приведение положение окна к тайлам (есть проблемы с этим)
                SRL D
                SRL E

                ; корректировка ширины захвата чанков, если не выровнено
                LD A, E
                AND Page0.ChunkArray.CHUNK_SIZE_MASK
                JR Z, $+3
                INC C

                ; корректировка центрирования захвата видимого окна
                LD A, E
                SUB Page0.ChunkArray.CHUNK_SIZE
                JR C, $+4
                LD E, A
                INC C

                ; корректировка высоты захвата чанков, если не выровнено
                LD A, D
                AND Page0.ChunkArray.CHUNK_SIZE_MASK
                JR Z, $+3
                INC B

                ; корректировка центрирования захвата видимого окна
                LD A, D
                SUB Page0.ChunkArray.CHUNK_SIZE
                JR C, $+4
                LD D, A
                INC B

                ifdef _DEBUG
                LD (.VisibleSize), BC
.VisibleSize    EQU $+1
                LD BC, #0000
                endif
                
                ; -----------------------------------------
                ; получение значений в области
                ; In:
                ;   HL - адрес счётчиков массива чанков (выровненый 256 байт)
                ;   DE - координаты области в тайлах (D - y, E - x)
                ;   BC - размер охватываемой области в чанках (B - y, C - x)
                ;   IX - адрес обработчика сортировки
                ;       A - количествой добавляемых элементов
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
;   DE' - адрес следующей свободной ячейки SortBuffer
; Out:
;   Adr.SortBuffer - адреса объектов, отсортированные по оси Y
;   InView.Num     - количество объектов в SortBuffer
;   DE'            - адрес следующей свободной ячейки SortBuffer
; Corrupt:
;   HL, BC, AF, HL', DE', BC', AF', IY
; Note:
;   SortBuffer хранит адреса FObject, а не адреса полей FObject.Position.Y.
;   сортировка выполняется при добавлении: новый объект записывается в конец
;   списка и поднимается назад обменами, пока его Position.Y меньше предыдущего.
; -----------------------------------------
AddObjects:     ; инициализация
                PUSH HL                                                         ; сохраним текущий адрес массиве чанков
                LD L, E                                                         ; смещение в массиве чанков первого элемента
                EX (SP), HL                                                     ; восстановим адрес массиве чанков, 
                                                                                ; и сохраним адрес первого элемента в массиве чанков
                EXX
                LD B, A                                                         ; количество добавляемых элементов
                POP HL                                                          ; восстановим адрес первого элемента в массиве чанков
                INC H                                                           ; переход на массив значений

.Loop           ; чтение индекса объекта из массива чанка
                LD A, (HL)
                INC L

                CALC_OBJECT_ADD C                                               ; расчёт адрес объекта
                                                                                ;   С:A - адрес объекта
                ; вставка объекта с сохранением сортировки по оси Y
                PUSH HL
                PUSH BC
                CALL .InsertObject
                POP BC
                POP HL

                DJNZ .Loop

                EXX
                RET
; -----------------------------------------
; вставить один объект в SortBuffer
; In:
;   DE' - адрес следующей свободной ячейки SortBuffer
;   С:A - адрес объекта
; Out:
;   Adr.SortBuffer - список объектов отсортирован по FObject.Position.Y
;   InView.Num     - увеличен на один
;   DE'            - адрес следующей свободной ячейки SortBuffer
; Corrupt:
;   AF, BC, DE, HL
; Note:
;   Используется гномья сортировка: новый элемент сравнивается с предыдущим
;   и меняется с ним местами, пока не займёт корректное положение.
; -----------------------------------------
.InsertObject   LD HL, InView.Num
                LD B, (HL)
                INC (HL)

                ; добавить новый объект в конец списка
                LD (DE), A
                INC E
                LD A, C
                LD (DE), A
                INC E

                ; проверка, если до вставки список был пустой
                LD A, B
                OR A
                RET Z                                                           ; выход, если массив пустой
                PUSH DE

                ; установка HL на младший байт последнего элемента списка
                EX DE, HL
                DEC L
                DEC L

.InsertLoop     PUSH BC

                ; чтение Y текущего элемента
                LD E, (HL)
                INC L
                LD D, (HL)
                DEC L
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
                ; DE - адрес объекта оси Y предыдущего элемента
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

.Swap           ; обмен предыдущего и текущего элемента SortBuffer
                DEC E                                                           ; переход к адресу Object.FObject.Flags
                DEC E                                                           ; переход к адресу Object.FObject.Class

                ; переход к адресу SortBuffer текущего элемента
                LD B, L                                                         ; сохранение младшего адреса SortBuffer предыдущего элемента
                INC L
                INC L

                ; чтение адреса текущего объекта с последующей записбю нового адреса предуыдущего объекта 
                LD C, (HL)
                LD (HL), E
                INC L
                LD A, (HL)
                LD (HL), D

                ; запись адреса текущего объекта в адрес SortBuffer предыдущего элемента
                LD L, B                                                         ; восстановлени младшего адреса SortBuffer предыдущего элемента
                LD (HL), C
                INC L
                LD (HL), A
                DEC L

                POP BC
                DJNZ .InsertLoop

                POP DE
                RET

.InsertDone     POP BC
                POP DE
                RET

                display " - Objects in view:\t\t\t\t\t", /A, InView, "\t= busy [ ", /D, $-InView, " byte(s)  ]"

                endif ; ~_WORLD_OBJECTS_IN_VIEW_

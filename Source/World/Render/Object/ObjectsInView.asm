
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
; -----------------------------------------
InView:         SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                ; инициализация
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
                AND CHUNK_SIZE_MASK
                JR Z, $+3
                INC C

                ; корректировка центрирования захвата видимого окна
                LD A, E
                SUB CHUNK_SIZE
                JR C, $+4
                LD E, A
                INC C

                ; корректировка высоты захвата чанков, если не выровнено
                LD A, D
                AND CHUNK_SIZE_MASK
                JR Z, $+3
                INC B

                ; корректировка центрирования захвата видимого окна
                LD A, D
                SUB CHUNK_SIZE
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
                RET
;   A - количествой добавляемых элементов
;   H - старший адрес текущего массива чанков
;   E - смещение в массиве чанков первого элемента
AddObjects:     ; 
                EX AF, AF'
                LD A, E
                PUSH HL
                EXX

                EX AF, AF'
                LD B, A
                LD HL, InView.Num
                ADD A, (HL)
                LD (HL), A
                EX AF, AF'

                POP HL
                INC H                                                           ; переход на массив значений
                LD L, A 

.Loop           ;
                LD A, (HL)
                INC L

                ; %0aaaaaaa
                LD C, HIGH Adr.ObjectsArray >> 4    ; %00001100
                ADD A, A    ; %aaaaaaa0 : 0
                RL C        ; %0001100a
                ADD A, A    ; %aaaaaa00 : a
                RL C        ; %001100aa
                ADD A, A    ; %aaaaa000 : a
                RL C        ; %01100aaa
                ADD A, A    ; %aaaa0000 : a
                RL C        ; %1100aaaa

                ; сохранение адреса
                LD (DE), A
                INC E
                LD A, C
                LD (DE), A
                INC E

                DJNZ .Loop

                EXX
                RET

                display " - Objects in view:\t\t\t\t\t", /A, InView, "\t= busy [ ", /D, $-InView, " byte(s)  ]"

                endif ; ~_WORLD_OBJECTS_IN_VIEW_


                ifndef _WORLD_TILEMAP_VISIBLE_OBJECTS_
                define _WORLD_TILEMAP_VISIBLE_OBJECTS_
; -----------------------------------------
; определение видимых объектов
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
VisibleObjects: SET_PAGE_WORLD                                                  ; включить страницу работы с картой "мира"

                ;
                LD IX, AddObjects
                LD DE, Adr.SortBuffer
                EXX

                ;
                LD HL, GameSession.WorldInfo + FWorldInfo.MapPosition
                LD BC, #0202                                                    ; минимальный захватываемое окно в чанках
                LD E, (HL)                                                      ; X
                INC L
                LD D, (HL)                                                      ; Y

                ; корректировка ширины захвата чанков, если не выровнено
                LD A, E
                AND Kernel.ChunkArray.CHUNK_SIZE_MASK
                JR Z, $+3
                INC C

                ; корректировка высоты захвата чанков, если не выровнено
                LD A, D
                AND Kernel.ChunkArray.CHUNK_SIZE_MASK
                JR Z, $+3
                INC B
                
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
                RET
;   A - количествой добавляемых элементов
;   H - старший адрес текущего массива чанков
;   E - смещение в массиве чанков первого элемента
AddObjects:     ; 
                EX AF, AF'
                LD A, E
                PUSH HL
                EXX

                POP HL
                INC H                                                           ; переход на массив значений
                LD L, A
                LD A, (HL)

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

                EXX
                RET

                endif ; ~_WORLD_TILEMAP_VISIBLE_OBJECTS_

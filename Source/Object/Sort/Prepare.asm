
                ifndef _OBJECT_SORT_PREPARE_
                define _OBJECT_SORT_PREPARE_
; -----------------------------------------
; подготовка к сортировке объектов для отображения
; In:
;   A'  - количество обробаываемых объектов
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Prepare:        ; -----------------------------------------
                ; копирование в буфер сортировки
                ; -----------------------------------------
                
                LD HL, Adr.SortBuffer
                LD DE, Adr.Object                                               ; стартовый адрес обрабатываемого объекта
                LD A, H
                EXX
                LD D, A
                LD B, #00
                EXX
                EX AF, AF'
                LD B, A
                LD C, A                                                         ; B - размер массива, C - количествой элементов в массиве

.ObjectLoop     ; проверка видимости объекта
                LD A, (DE)
                RRA                                                             ; BIT FLAG_OBJECT_VISIBLE_BIT, A
                JR NC, .NextObject

                ; является ли объект декалью
                INC E                                                           ; .Flags
                LD A, (DE)
                ADD A, A                                                        ; BIT DECAL_FLAG_BIT, A
                JR C, .IsDecal                                                  ; переход если объект, является декалью

.Copy           ; копирование адреса объекта
                INC E                                                           ; .Position.Y
                LD (HL), E
                DEC E
                DEC E
                INC L
                LD (HL), D
                INC L

                INC C
.NextObject     DEC C                                                           ; уменьшение счётчика активных объектов на экране
                
                ; следующий элемент
                LD A, E
                ADD A, OBJECT_SIZE
                LD E, A
                ADC A, D
                SUB E
                LD D, A

                DJNZ .ObjectLoop

                RET

.IsDecal        ; сдвиг право на 2 байта весь массив
                LD A, L
                EXX
                LD E, A
                LD L, A
                LD C, A
                INC E
                DEC L
                LD H, D
                LDDR

                INC A
                INC A

                ;
                LD HL, Quicksort.Offset
                INC (HL)
                INC (HL)

                EXX

                LD L, #00

                ; копирование адреса объекта
                INC E
                LD (HL), E
                DEC E
                INC L
                LD (HL), D

                LD L, A
                DEC E
                JR .NextObject

                endif ; ~_OBJECT_SORT_PREPARE_

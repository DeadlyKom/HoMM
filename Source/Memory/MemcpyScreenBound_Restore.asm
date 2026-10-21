
                ifndef _MEMORY_COPY_SCREEN_RESTORE_BOUND_
                define _MEMORY_COPY_SCREEN_RESTORE_BOUND_

                module Memcpy
                module Restore
Begin:          EQU $
; -----------------------------------------
; восстановление экранной области из буфера
; In:
;   HL - адрес начала буфера
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', BC', IX, IY
; Note:
;   - допустимая ширина: 2, 4, 6 знакомест
;   - область должна целиком помещаться на экране
; -----------------------------------------
Bound:          ; инициализация стека
                LD (.ContainerSP), SP
                LD SP, HL

                ; ℹ️ формат шапки:
                ;   +0 - ширина в знакоместах
                ;   +1 - высота в знакоместах
                ;   +2 - указатель на начало данных

                ; чтение шапки сохранённых данных
                POP BC                                                          ; чтение размера области из шапки
                POP HL                                                          ; чтение указателя на данные для восстановления

                ; ℹ️ формат данных:
                ;   +0 - адрес правого атрибута нижнего ряда
                ;   +2 - сохранённые данные

                ; чтение экранного адреса начала восстановления
                LD SP, HL
                POP HL

                ; сохранение экранного адреса на время выбора обработчиков
                EX DE, HL

                ; расчёт смещения в таблице
                LD A, C
                ADD A, A    ; x2
                ADD A, C    ; x3
                SUB #06     ; ширина * 3 - 6
                ADD A, LOW .Table
                LD L, A
                ADC A, HIGH .Table
                SUB L
                LD H, A

                ; чтение адреса прямой записи
                LD A, (HL)
                LD IXL, A
                INC HL
                LD A, (HL)
                LD IXH, A
                INC HL

                ; чтение адреса обратной записи
                LD A, (HL)
                LD IYL, A
                INC HL
                LD A, (HL)
                LD IYH, A
                INC HL

                ; чтение адреса записи атрибутов
                LD A, (HL)
                INC HL
                LD H, (HL)
                LD L, A
                LD (.WriteAttr), HL

                ; инициализация счётчиков восстановления
                LD C, B
                LD B, #04

                ; подготовка адреса записи
                EX DE, HL
                PUSH HL
                EXX
                POP HL

.Attr           ; переход к записи строки атрибутов
.WriteAttr      EQU $+1
                JP #0000

.Exit           ; восстановление стека вызывающего кода
.ContainerSP    EQU $+1
                LD SP, #0000
                RET

.Table          ; адреса прямой, обратной и атрибутной записи
                DW Forward.x2, Backward.x2, Attribute.x2
                DW Forward.x4, Backward.x4, Attribute.x4
                DW Forward.x6, Backward.x6, Attribute.x6
WRITE_TWO_BYTES_FORWARD macro
                POP BC
                LD (HL), B
                INC L
                LD (HL), C
                INC L
                endm
WRITE_TWO_BYTES_FORWARD_ macro
                POP BC
                LD (HL), B
                INC L
                LD (HL), C
                endm
WRITE_TWO_BYTES_BACKWARD macro
                POP BC
                LD (HL), B
                DEC L
                LD (HL), C
                DEC L
                endm
WRITE_TWO_BYTES_BACKWARD_ macro
                POP BC
                LD (HL), B
                DEC L
                LD (HL), C
                endm
; -----------------------------------------
; запись строки пикселей слева направо
; In:
;   HL  - текущий экранный адрес записи
;   HL' - адрес правого атрибута текущего ряда
;   B'  - счётчик пар пиксельных строк (4 в знакоместе)
;   C'  - количество оставшихся рядов знакомест
;   IX  - адрес записи строки пикселей слева направо
;   IY  - адрес записи строки пикселей справа налево
;   SP  - указатель стека буфера для чтения
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Forward:        ; запись строки пикселей слева направо
.x6             WRITE_TWO_BYTES_FORWARD
.x4             WRITE_TWO_BYTES_FORWARD
.x2             WRITE_TWO_BYTES_FORWARD_

                ; переход к предыдущей пиксельной строке
                DEC H
                JP (IY)
; -----------------------------------------
; запись строки пикселей справа налево
; In:
;   HL  - текущий экранный адрес записи
;   HL' - адрес правого атрибута текущего ряда
;   B'  - счётчик пар пиксельных строк (4 в знакоместе)
;   C'  - количество оставшихся рядов знакомест
;   IX  - адрес записи строки пикселей слева направо
;   IY  - адрес записи строки пикселей справа налево
;   SP  - указатель стека буфера для чтения
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Backward:       ; запись строки пикселей справа налево
.x6             WRITE_TWO_BYTES_BACKWARD
.x4             WRITE_TWO_BYTES_BACKWARD
.x2             WRITE_TWO_BYTES_BACKWARD_

                ; цикл пар пиксельных строк
                EXX
                DJNZ .NextPairRows
                LD B, #04

                ; проверка количества оставшихся рядов знакомест
                DEC C
                JP Z, Bound.Exit                                                ; переход, если восстановлены все ряды знакомест

                ; расчёт адреса правого атрибута предыдущего ряда
                LD A, L
                SUB #20
                LD L, A
                JR NC, $+3
                DEC H

                ; переход к началу предыдущей строки
                PUSH HL
                EXX
                POP HL
                JP Bound.Attr

.NextPairRows   ; переход к предыдущей паре пиксельных строк
                EXX
                DEC H
                JP (IX)
; -----------------------------------------
; запись строки атрибутов справа налево
; In:
;   HL  - текущий экранный адрес записи
;   HL' - адрес правого атрибута текущего ряда
;   B'  - счётчик пар пиксельных строк (4 в знакоместе)
;   C'  - количество оставшихся рядов знакомест
;   IX  - адрес записи строки пикселей слева направо
;   IY  - адрес записи строки пикселей справа налево
;   SP  - указатель стека буфера для чтения
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Attribute:      ; запись строки атрибутов справа налево
.x6             WRITE_TWO_BYTES_BACKWARD
.x4             WRITE_TWO_BYTES_BACKWARD
.x2             WRITE_TWO_BYTES_BACKWARD_

                ; преобразование адреса (левого) атрибута в адрес пиксельной строки 7
                LD A, H
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                XOR H
                AND #7F
                XOR H
                OR #07
                LD H, A
                JP (IX)

                display " - Memcpy screen restore bound:\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule
                endmodule

                endif ; ~_MEMORY_COPY_SCREEN_RESTORE_BOUND_
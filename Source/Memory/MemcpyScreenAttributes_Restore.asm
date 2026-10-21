
                ifndef _MEMORY_COPY_SCREEN_RESTORE_ATTRIBUTES_
                define _MEMORY_COPY_SCREEN_RESTORE_ATTRIBUTES_

                module Memcpy
                module Attributes
; -----------------------------------------
; восстановление атрибутов экранной области из буфера
; In:
;   HL - адрес шапки буфера
; Out:
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; Note:
;   - допустимая ширина: 2, 4, 6 знакомест
;   - буфер сохранённых атрибутов остаётся неизменным
; -----------------------------------------
Restore:        ; инициализация стека
                LD (.ContainerSP), SP
                LD SP, HL

                ; ℹ️ формат шапки:
                ;   +0 - ширина в знакоместах
                ;   +1 - высота в знакоместах
                ;   +2 - указатель на начало данных

                ; чтение размера области и указателя на данные
                POP BC
                POP HL

                ; ℹ️ формат данных:
                ;   +0 - адрес правого атрибута нижнего ряда
                ;   +2 - сохранённые атрибуты

                ; чтение адреса правого атрибута нижнего ряда
                LD SP, HL
                POP HL
                EX DE, HL

                ; сохранение количества восстанавливаемых рядов
                LD IYL, B

                ; расчёт смещения в таблице обработчиков ширины
                LD A, C
                SUB #02
                ADD A, LOW .Table
                LD L, A
                ADC A, HIGH .Table
                SUB L
                LD H, A

                ; чтение адреса обработчика строки атрибутов
                LD A, (HL)
                LD IXL, A
                INC HL
                LD A, (HL)
                LD IXH, A

                ; подготовка адреса записи первого ряда
                EX DE, HL

                ; расчёт смещения от левого атрибута к правому предыдущего ряда
                ; смещение равно ширине области - 1 - 32
                LD A, C
                SUB #21
                LD E, A
                LD D, #FF
                JP (IX)

.Row6           WRITE_TWO_BYTES_BACKWARD
.Row4           WRITE_TWO_BYTES_BACKWARD
.Row2           WRITE_TWO_BYTES_BACKWARD_

                ; проверка количества оставшихся рядов знакомест
                DEC IYL
                JR Z, .Exit                                                     ; переход, если восстановлены все ряды знакомест

                ; расчёт адреса правого атрибута предыдущего ряда
                ADD HL, DE
                JP (IX)

.Exit           ; восстановление стека вызывающего кода
.ContainerSP    EQU $+1
                LD SP, #0000
                RET

.Table          ; адреса записи строк шириной 2, 4, 6 знакомест
                DW .Row2, .Row4, .Row6

                display " - Memcpy screen restore attributes:\t\t\t", /A, Restore, "\t= busy [ ", /D, $ - Restore, " byte(s)  ]"
                endmodule
                endmodule

                endif ; ~_MEMORY_COPY_SCREEN_RESTORE_ATTRIBUTES_

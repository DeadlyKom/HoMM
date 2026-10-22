
                ifndef _MEMORY_COPY_SCREEN_SAVE_ATTRIBUTES_
                define _MEMORY_COPY_SCREEN_SAVE_ATTRIBUTES_

                module Memcpy
                module Attributes
; -----------------------------------------
; сохранение атрибутов экранной области в буфер (обёртка)
; In:
;   HL' - адрес буфера
;   DE' - позиция в знакоместах (D' - y, E' - x)
;   BC' - размер в знакоместах (B' - y, C' - x)
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', BC', IX
; Note:
;   - параметры передаются через EXX перед вызовом из другой страницы
; -----------------------------------------
Save.Wrap       EXX
; -----------------------------------------
; сохранение атрибутов экранной области в буфер
; In:
;   HL - адрес шапки буфера
;   DE - позиция в знакоместах (D - y, E - x)
;   BC - размер в знакоместах (B - y, C - x)
; Out:
; Corrupt:
;   HL, DE, BC, AF, HL', BC', IX
; Note:
;   - допустимая ширина: 2, 4, 6 знакомест
;   - высота должна быть ненулевой, область целиком помещается на экране
; -----------------------------------------
Save:           ; инициализация стека
                LD (.ContainerSP), SP
                LD SP, HL

                ; запись размера области в шапку
                LD (HL), C
                INC HL
                LD (HL), B
                INC HL

                ; сохранение адреса поля для фактического указателя стека
                LD (.BufferPtr), HL

                ; расчёт адреса левого атрибута верхнего ряда
                CALL Convert.AttributeAdr

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

                ; подготовка адреса чтения первого ряда
                EX DE, HL
                PUSH HL
                EXX
                POP HL
                JP (IX)

.Row6           READ_TWO_BYTES_FORWARD
.Row4           READ_TWO_BYTES_FORWARD
.Row2           READ_TWO_BYTES_FORWARD_

                ; проверка количества оставшихся рядов знакомест
                EXX
                DJNZ .NextRow

                ; расчёт адреса правого атрибута нижнего ряда
                LD A, C
                DEC A
                ADD A, L
                LD L, A

                ; сохранение экранного адреса начала восстановления
                PUSH HL

                ; запись фактического указателя стека в шапку
.BufferPtr      EQU $+2
                LD (#0000), SP

                ; восстановление стека вызывающего кода
.ContainerSP    EQU $+1
                LD SP, #0000
                RET

.NextRow        ; расчёт адреса левого атрибута следующего ряда
                LD A, L
                ADD A, #20
                LD L, A
                JR NC, .ReadRow                                                  ; переход, если перенос в старший байт адреса не требуется
                INC H

.ReadRow        ; подготовка адреса чтения следующего ряда
                PUSH HL
                EXX
                POP HL
                JP (IX)

.Table          ; адреса чтения строк шириной 2, 4, 6 знакомест
                DW .Row2, .Row4, .Row6

                display " - Memcpy screen save attributes:\t\t\t", /A, Save, "\t= busy [ ", /D, $ - Save, " byte(s)  ]"
                endmodule
                endmodule

                endif ; ~_MEMORY_COPY_SCREEN_SAVE_ATTRIBUTES_

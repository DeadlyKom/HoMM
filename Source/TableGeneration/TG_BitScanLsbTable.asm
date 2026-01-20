                ifndef _TABLE_GENERATION_BIT_SCAN_LSB_
                define _TABLE_GENERATION_BIT_SCAN_LSB_

                module Tables
; -----------------------------------------
; генерация таблица для поиска первого установленного бита
; In:
;   HL - адрес таблицы выровнен 256 байт!
; Out:
; Corrupt:
; Note:
;   0 значение будет сгенерированно как 8 бит (несуществующий)
; -----------------------------------------
TG_BitScanLsbTable:; инициализация генерации
                ; LD HL, Adr.BitScanLsbTable
                LD B, #00

.Loop           LD A, B
                LD C, #08                                                       ; номер бита

                dup 8
                RRA                                                             ; двиг вправо, LSB → CF
                JR C, .BitFound                                                 ; переход, если найден включенный бит
                DEC C
                edup

                LD C, #07

.BitFound       LD (HL), C
                INC L
                DJNZ .Loop

                RET

                display " - Generate table to bit scan LSB:\t\t\t", /A, TG_BitScanLsbTable, "\t= busy [ ", /D, $-TG_BitScanLsbTable, " byte(s)  ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_BIT_SCAN_LSB_

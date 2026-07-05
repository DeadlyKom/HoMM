
                ifndef _UTILITIES_BINARY_TO_DECIMAL_
                define _UTILITIES_BINARY_TO_DECIMAL_

                module Utilities
Begin           EQU $
; -----------------------------------------
; преобразование двоичного числа в десятичную ASCII-строку
; Entry:
;   BinaryToDecimal.x8  - L    содержит 8-битное число  [0..255]
;   BinaryToDecimal.x16 - HL   содержит 16-битное число [0..65535]
;   BinaryToDecimal.x24 - A:HL содержит 24-битное число [0..16777215]
; Out:
;   HL - адрес первой цифры строки
;   BC - количество цифр [1..8], B = 0
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   число выравнивается по правому краю внутреннего буфера;
;   свободные позиции заполняются пробелами, строка завершается нулём;
;   следующий вызов перезаписывает результат предыдущего
; ----------------------------------------
BinaryToDecimal:
.x8             LD H, #00
.x16            XOR A
.x24            ; сохранение 24-битного исходного числа в порядке L:H:A
                LD (.Number + 0), HL
                LD (.Number + 2), A

                ; заполнение свободной части буфера пробелами
                LD HL, .Buffer
                LD DE, .Buffer + 1
                LD (HL), ' '
                LD BC, #0007
                LDIR

                ; младший байт BCD и завершающий ноль
                LD (.End - 1), BC                                               ; после LDIR BC = 0
                LD E, #01                                                       ; текущий размер BCD в байтах

                ; поиск старшего ненулевого байта исходного числа
                LD HL, .Number + 3
                LD BC, #0409                                                    ; 3 байта числа + 1, 8 бит + 1
                XOR A
.SkipZeroByte   DEC B
                JR Z, .Size                                                     ; исходное число равно нулю
                DEC HL
                OR (HL)
                JR Z, .SkipZeroByte

                ; определение количества значащих битов старшего байта
.FindFirstBit   DEC C
                RLA
                JR NC, .FindFirstBit
                RRA
                LD D, A                                                         ; текущий байт исходного числа

                ; последовательное добавление битов в упакованное BCD-значение
.NextByte       PUSH HL
                PUSH BC
.NextBit        LD HL, .End - 1                                                 ; младший байт BCD-значения
                LD B, E                                                         ; текущий размер BCD в байтах
                RL D                                                            ; следующий бит исходного числа -> Carry
.DoubleBCD      LD A, (HL)
                ADC A, A
                DAA
                LD (HL), A
                DEC HL
                DJNZ .DoubleBCD
                JR NC, .NoGrow
                INC E                                                           ; BCD-значение увеличилось на один байт
                LD (HL), #01
.NoGrow         DEC C
                JR NZ, .NextBit

                POP BC                                                          ; количество оставшихся байтов исходного числа
                LD C, #08                                                       ; количество битов в следующем байте
                POP HL
                DEC HL
                LD D, (HL)
                DJNZ .NextByte

                ; определение положения BCD-значения и начала ASCII-строки
.Size           LD HL, .End
                LD C, E                                                         ; размер BCD в байтах
                OR A
                SBC HL, BC                                                      ; адрес старшего байта BCD
                LD D, H
                LD E, L
                SBC HL, BC
                EX DE, HL                                                       ; HL = BCD, DE = начало ASCII-строки

                ; преобразование упакованных BCD-разрядов в ASCII
                LD B, C
                SLA C                                                           ; максимальное количество цифр
                LD A, '0'
                RLD
                CP '0'
                JR NZ, .StoreHigh
                DEC C                                                           ; старший BCD-полубайт не используется
                INC DE
                JR .StoreLow

.ExpandLoop     RLD
.StoreHigh      LD (DE), A
                INC DE
.StoreLow       RLD
                LD (DE), A
                INC DE
                INC HL
                DJNZ .ExpandLoop

                SBC HL, BC                                                      ; адрес первой цифры строки
                RET

.Number         DS 3, 0                                                         ; исходное число в порядке L:H:A
.Buffer         DS 9, 0                                                         ; выравнивание + восемь десятичных цифр
.End            DB #00                                                          ; завершающий ноль

                display " - Binary to decimal string:\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $-Begin, " byte(s)  ]"

                endmodule

                endif ; ~_UTILITIES_BINARY_TO_DECIMAL_

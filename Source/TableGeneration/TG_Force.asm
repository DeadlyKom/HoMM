                ifndef _TABLE_GENERATION_FORCE_TABLE_
                define _TABLE_GENERATION_FORCE_TABLE_

                module Tables
; -----------------------------------------
; генерация таблица величины силы (по умолчанию)
; In:
;   HL - адрес таблицы выровнен 256 байт!
; Out:
; Corrupt:
; Note:
;   F(r) = K_GRAV / (r + 1)
; -----------------------------------------
TG_Force.Default;
.Gravity        EQU 128                                                         ; масштабный коэффициент
                LD C, .Gravity
; -----------------------------------------
; генерация таблица величины силы
; In:
;   HL - адрес таблицы выровнен 256 байт!
;   C  - масштабный коэффициент (128)
; Out:
; Corrupt:
; Note:
;   F(r) = K_GRAV / (r + 1)
;   форма хранения таблицы:
;    - младщий байт -> HL + значение
;    - старший байт -> HL + значение + 256
; -----------------------------------------
TG_Force:       ; инициализация генерации
                LD B, #FF                                                       ; счётчик (255 значений)

.Loop           PUSH BC

                LD A, #FF
                SUB B
                LD E, A

                LD A, C
                LD C, #00
                LD D, C
                INC DE
                ; -----------------------------------------
                ; деление A:C на DE
                ; In :
                ;   A:C - делимое
                ;   DE  - делитель
                ; Out :
                ;   A:C - результат деления
                ;   HL  - остаток               (mod)
                ; Corrupt :
                ;   HL, BC, AF
                ; -----------------------------------------
                PUSH HL
                CALL Math.Div16x16_16
                POP HL

                ; сохранение результата
                LD (HL), C
                INC H
                LD (HL), A
                DEC H
                INC L

                POP BC
                DJNZ .Loop

                ; 256 значение
                LD (HL), C
                INC H
                LD (HL), B

                RET

                display " - Generate table force:\t\t\t\t\t\t= busy [ ", /D, $-TG_Force, " byte(s) ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_FORCE_TABLE_

                ifndef _TABLE_GENERATION_PRNG_
                define _TABLE_GENERATION_PRNG_

                module Tables
; -----------------------------------------
; генерация PRNG
; In:
; Out:
; Corrupt:
; Note:
;   должен быть установлен seed генерации
; -----------------------------------------
TG_PRNG:        ; инициализация генерации
                LD HL, Adr.PRNG

.Loop           ; генерация таблицы PRNG
                EXX
                CALL Math.Rand8
                EXX
                LD (HL), A
                INC L
                JR NZ, .Loop

                RET

                display "\t- PRNG generator:\t\t\t\t", /A, TG_PRNG, "\t= busy [ ", /D, $-TG_PRNG, " byte(s)  ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_PRNG_

                ifndef _TABLE_GENERATION_BYTE_MIRROR_
                define _TABLE_GENERATION_BYTE_MIRROR_

                module Tables
; -----------------------------------------
; генерация таблицы зеркальных байт
; In:
; Out:
; Corrupt:
; Note:
;   должен быть установлен seed генерации
; -----------------------------------------
TG_ByteMirror:  ; инициализация генерации
                LD HL, Adr.ByteMirrorTable

.Loop           LD B, #08
                LD A, L
                RRA
                RL C
                DJNZ $-3
                LD (HL), C
                INC L
                JR NZ, .Loop

                RET

                display " - Byte mirror generator:\t\t\t\t", /A, TG_ByteMirror, "\t= busy [ ", /D, $-TG_ByteMirror, " byte(s)  ]"
                endmodule

                endif ; ~ _TABLE_GENERATION_BYTE_MIRROR_

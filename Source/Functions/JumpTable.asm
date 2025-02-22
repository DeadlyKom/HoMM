
                ifndef _FUNCTIONS_JUMP_TABLE_
                define _FUNCTIONS_JUMP_TABLE_
; -----------------------------------------
; переход по таблице переходов
; In:
;   A  - индекс перехода
;   HL - адрес таблицы переходов
; Out:
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
JumpTable:      ; расчёт адреса хранения перехода
                ADD A, A
.NoShift        ADD A, L
                LD L, A
                ADC A, H
                SUB L
                LD H, A
                LD A, (HL)
                INC HL
                LD H, (HL)
                LD L, A
                JP (HL)

                display " - Function jump by table:\t\t\t\t", /A, JumpTable, "\t= busy [ ", /D, $-JumpTable, " byte(s)  ]"

                endif ; ~_FUNCTIONS_JUMP_TABLE_

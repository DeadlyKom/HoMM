
                ifndef _UTILITIES_GET_LENGTH_STRING_
                define _UTILITIES_GET_LENGTH_STRING_
; -----------------------------------------
; длина строки
; In:
;   HL - адрес строки
; Out:
;   BC - длина строки
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
GetLength:      PUSH HL
                XOR A
                LD B, A
                LD C, A

.Loop           CPI
                JR NZ, .Loop

                ; NEG BC
                SUB C
                LD C, A
                SBC A, A
                SUB B
                LD B, A

                POP HL
                RET

                endif ; ~_UTILITIES_GET_LENGTH_STRING_

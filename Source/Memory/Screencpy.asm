
                ifndef _MEMORY_SCREEN_COPY_
                define _MEMORY_SCREEN_COPY_

                module Memory
Begin:          EQU $
; -----------------------------------------
; In:
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
Screencpy:      LD HL, #C000 + 22
                EXX
                LD HL, #4000

.Loop           LD SP, #0000
                POP BC
                POP DE
                POP HL
                EXX
                POP BC
                POP DE
                POP HL

                LD SP, #0000
                PUSH HL
                PUSH DE
                PUSH BC
                EXX
                PUSH HL
                PUSH DE
                PUSH BC

                LD SP, #0000
                POP HL
                POP BC
                POP DE
                EXX
                POP BC
                POP DE

                LD SP, #0000
                PUSH HL
                PUSH DE
                PUSH BC
                EXX
                PUSH DE
                PUSH BC



                dup 176
                dup 11
                POP HL
                LD (0), HL
                endp
                endp

                display " - Memory screen copy:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule

                endif ; ~_MEMORY_SCREEN_COPY_

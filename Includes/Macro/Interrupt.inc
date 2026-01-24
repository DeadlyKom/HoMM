
                ifndef _MACRO_INTERRUPT_
                define _MACRO_INTERRUPT_
RESTORE_HL      macro
                LD A, #E5
                LD (RestoreRegister), A
                endm
RESTORE_DE      macro
                LD A, #D5
                LD (RestoreRegister), A
                endm
RESTORE_BC      macro
                LD A, #C5
                LD (RestoreRegister), A
                endm

RESTORE_SCR     macro Handler?
                LD A, #C3           ; JP
                LD (RestoreRegister+0), A
                LD A, LOW (Handler?)
                LD (RestoreRegister+1), A
                LD A, HIGH (Handler?)
                LD (RestoreRegister+2), A
                endm
RESTORE_SCR_    macro
                LD A, #00           ; NOP
                LD (RestoreRegister+0), A
                LD A, #31           ; LD SP, nnnn
                LD (RestoreRegister+1), A
                LD A, LOW Int.StackTop
                LD (RestoreRegister+2), A
                endm
SET_USER_HANDLER macro Func?
                LD BC, Func?
                LD (UserInterrupt), BC
                endm
RES_USER_HANDLER macro
                LD BC, Interrupt_RET
                LD (UserInterrupt), BC
                endm
PUSH_USER_HANDLER macro
                LD BC, (UserInterrupt)
                PUSH BC
                endm
POP_USER_HANDLER macro
                POP BC
                LD (UserInterrupt), BC
                endm

                endif ; ~_MACRO_INTERRUPT_


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
SET_USER_HANDLER macro Func?
                LD BC, Func?
                LD (UserInterrupt), BC
                endm
RES_USER_HANDLER macro
                LD BC, Interrupt_RET
                LD (UserInterrupt), BC
                endm

                endif ; ~_MACRO_INTERRUPT_

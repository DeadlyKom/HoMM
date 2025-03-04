
                ifndef _MACRO_MAIN_LOOP_CORE_
                define _MACRO_MAIN_LOOP_CORE_
; -----------------------------------------
; установка обработчика главного цикла
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_MAIN_LOOP   macro Func?
                LD BC, Func?
                LD (Bootloader.EntryPoint.MainLoop.Address), BC
                endm
; -----------------------------------------
; установка обработчика главного цикла
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_MAIN_LOOP   macro
                LD BC, Interrupt_RET
                LD (Bootloader.EntryPoint.MainLoop.Address), BC
                endm

                endif ; ~_MACRO_MAIN_LOOP_CORE_

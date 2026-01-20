
                ifndef _MACRO_MAIN_SWAP_CORE_
                define _MACRO_MAIN_SWAP_CORE_
; -----------------------------------------
; установка обработчика главного цикла
; In:
; Out:
; Corrupt:
; -----------------------------------------
SET_MAIN_SWAP   macro Func?
                LD BC, Func?
                LD (Bootloader.EntryPoint.Swap.Address), BC
                endm
; -----------------------------------------
; установка обработчика главного цикла
; In:
; Out:
; Corrupt:
; -----------------------------------------
RES_MAIN_SWAP   macro
                LD BC, Bootloader.EntryPoint.Swap.RET
                LD (Bootloader.EntryPoint.Swap.Address), BC
                endm

                endif ; ~_MACRO_MAIN_SWAP_CORE_

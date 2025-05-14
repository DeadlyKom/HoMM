
                ifndef _MACRO_KERNEL_
                define _MACRO_KERNEL_
; -----------------------------------------
; запуск функции ассет
; In:
;   FuncID? - идентификатор запускаемой функции
;   Module? - модуль 
; Out:
; Corrupt:
; -----------------------------------------
LAUNCH_ASSET_FUNCTION macro FuncID?, Module?
                LD A, FuncID?
                CALL Module?
                endm
; -----------------------------------------
; запуск функции ассет
; In:
;   FuncID? - идентификатор запускаемой функции
;   Module? - модуль 
; Out:
; Corrupt:
; -----------------------------------------
LAUNCH_ASSET_FUNCTION_RESTORE macro FuncID?, Module?
                LD HL, .Continue
                PUSH HL
                ASSETS_PUSH
                LD HL, Func.RestoreAsset
                PUSH HL
                LD A, FuncID?
                JP Module?
.Continue       EQU $
                endm

; -----------------------------------------
; запуск функции ассет
; In:
;   SP+0     - 16-битный аргумент
;   FuncID? - идентификатор запускаемой функции
;   Module? - модуль 
; Out:
; Corrupt:
; -----------------------------------------
LAUNCH_ASSET_FUNCTION_RESTORE_ARG macro FuncID?, Module?
                LD HL, .Continue
                EX (SP), HL
                PUSH HL
                ASSETS_PUSH
                EX (SP), HL
                PUSH HL
                LD HL, Func.RestoreAsset
                EX (SP), HL
                PUSH HL
                LD A, FuncID?
                JP Module?
.Continue       EQU $
                endm
; -----------------------------------------
; генерация меток и привязка к ним функци
; In:
;   Label? - идентификатор запускаемой функции
;   Func?  - запускаемая функция
; Out:
; Corrupt:
; -----------------------------------------
BIND_ID_KERNEL  macro Label?, Func?
@Label?         EQU KERNEL_ID_COUNTER

                DW Func?
KERNEL_ID_COUNTER = KERNEL_ID_COUNTER + 1
                endm

                endif ; ~_MACRO_KERNEL_

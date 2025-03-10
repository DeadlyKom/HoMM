
                ifndef _MODULE_MAP_KERNAL_
                define _MODULE_MAP_KERNAL_
Kernel:
.Load           EQU 0x00
.Save           EQU 0x01
; -----------------------------------------
; выборка запускаемой функции
; In:
;   A  - индекс запускаемой функции
; Out:
; Corrupt:
;   HL, AF
; Note:
; -----------------------------------------
                POP AF
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
                LD HL, .JumpTable
                JP Func.JumpTable
.JumpTable:     ; загрузка карты
                DW Load
                ; сохранение карты
                DW Save

                endif ; ~_MODULE_MAP_KERNAL_

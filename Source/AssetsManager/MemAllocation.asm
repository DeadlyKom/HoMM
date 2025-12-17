
                ifndef _ASSETS_MANAGER_MEMORY_ALLOCATION_
                define _ASSETS_MANAGER_MEMORY_ALLOCATION_
; -----------------------------------------
; выделение участка памяти
; In:
; Out:
; Corrupt:
; Note:
;   - необходимо включить страницу с данными о доступной ОЗУ
; -----------------------------------------
MemAllocation:  RET

                endif ; ~ _ASSETS_MANAGER_MEMORY_ALLOCATION_

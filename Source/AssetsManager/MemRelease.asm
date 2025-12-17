
                ifndef _ASSETS_MANAGER_MEMORY_RELEASE_
                define _ASSETS_MANAGER_MEMORY_RELEASE_
; -----------------------------------------
; освобождение участка памяти (ранее выделенной через MemAllocation)
; In:
; Out:
; Corrupt:
; Note:
;   - необходимо включить страницу с данными о доступной ОЗУ
; -----------------------------------------
MemRelease:     RET

                endif ; ~ _ASSETS_MANAGER_MEMORY_RELEASE_

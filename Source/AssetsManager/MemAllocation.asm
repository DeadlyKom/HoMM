
                ifndef _ASSETS_MANAGER_MEMORY_ALLOCATION_
                define _ASSETS_MANAGER_MEMORY_ALLOCATION_
; -----------------------------------------
; выделение участка памяти
; In:
;   D  - номер страницы
;   E  - количество блоков по 256 байт
;   IX - адрес первого блока
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу с данными о доступной ОЗУ
; -----------------------------------------
MemAllocation:  ; ToDo: реализовать выделение области памяти
                RET

                endif ; ~ _ASSETS_MANAGER_MEMORY_ALLOCATION_

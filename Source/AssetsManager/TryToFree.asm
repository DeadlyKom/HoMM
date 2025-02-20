
                ifndef _ASSETS_MANAGER_TRY_TO_FREE_
                define _ASSETS_MANAGER_TRY_TO_FREE_
; -----------------------------------------
; попытка освободить память под ресурс
; In:
;   IX - адрес структуры FAssets
; Out:
; Corrupt:
; Note:
;   - необходимо включить страницу с данными о доступной ОЗУ
; -----------------------------------------
TryToFree:      RET

                endif ; ~ _ASSETS_MANAGER_TRY_TO_FREE_

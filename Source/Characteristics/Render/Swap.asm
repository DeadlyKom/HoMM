
                ifndef _CHARACTERISTICS_RENDER_SWAP_
                define _CHARACTERISTICS_RENDER_SWAP_
; -----------------------------------------
; обработка ожидания переключения экранов "характеристик"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в "общей памяти"
;   характеристики пока не запрашивают длительный перенос кадра
;   обычное переключение выполняется общим Render.Swap
; -----------------------------------------
Swap:           RET

                endif ; ~_CHARACTERISTICS_RENDER_SWAP_

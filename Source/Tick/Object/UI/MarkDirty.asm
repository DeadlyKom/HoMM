
                ifndef _TICK_OBJECT_UI_MARK_DIRTY_
                define _TICK_OBJECT_UI_MARK_DIRTY_
; -----------------------------------------
; пометка UI объекта для обновления
; In:
;   IX - адрес структуры объекта (FObjectUI)
; Out:
; Corrupt:
; Note:
;   флаг заставляет рендер обновить область предыдущего bound и заново вывести UI
;
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.MarkDirty:   ; установить флаг, объект требуется обновиться
                SET OBJECT_DIRTY_BIT, (IX + FObject.Flags)
                RET

                endif ; ~_TICK_OBJECT_UI_MARK_DIRTY_


                ifndef _TICK_OBJECT_UI_UPDATE_ANIMATION_
                define _TICK_OBJECT_UI_UPDATE_ANIMATION_
; -----------------------------------------
; обновление анимации UI объекта
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   C  - относительный временной шаг: 0 - x1, 1 - x2, 2 - x4
;   F' - флаг переполнения установлен при активной фазе "мирового тика" в текущем cadence-проходе
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.UpdateAnimation:
                ; ToDo: обновить таймер и индекс кадра анимации
                RET

                endif ; ~_TICK_OBJECT_UI_UPDATE_ANIMATION_


                ifndef _OBJECT_TICK_SCHEDULER_BUILDER_
                define _OBJECT_TICK_SCHEDULER_BUILDER_
; -----------------------------------------
; построитель порядка/расписания планировщика обновлений тиков
; In:
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;       Range_0, Range_1 и Range_2 всегда непустые
;       Range_1.FirstIndex >= 1
;       Range_2.FirstIndex >= 2
;   необходимо включить страницу с массивом событий (страница 0)
; ----------------------------------------
Builder:        ;
                RET

                endif ; ~_OBJECT_TICK_SCHEDULER_BUILDER_

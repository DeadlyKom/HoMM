
                ifndef _OBJECT_SIGNIFICANCE_EVALUATORS_DEFAULT_
                define _OBJECT_SIGNIFICANCE_EVALUATORS_DEFAULT_
; -----------------------------------------
; оценщик уровеня значимости объектов (по умолчанию)
; In:
; Out:
;   A - новый уровень оценки значемости
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
; ----------------------------------------
Default:        LD A, (IX + FObject.Significance)
                RET

                endif ; ~_OBJECT_SIGNIFICANCE_EVALUATORS_DEFAULT_

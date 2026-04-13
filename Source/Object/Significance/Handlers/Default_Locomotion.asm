
                ifndef _OBJECT_SIGNIFICANCE_HANDLERS_DEFAULT_LOCOMOTION_
                define _OBJECT_SIGNIFICANCE_HANDLERS_DEFAULT_LOCOMOTION_
; -----------------------------------------
; обработчик смены уровня значимости объектов - locomotion (по умолчанию)
; In:
;   C  - новое знаение уровня значимости объекта
;   IX - адрес структуры объекта (FObject)
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
;   ⚠️ ВАЖНО ⚠️ нельзя портить регистр С
; ----------------------------------------
Default.Locomotion:
                LD A, (IX + FObject.Significance)
                XOR C
                AND SIGNIFICANCE_LOCOMOTION_MASK_INV
                XOR C
                LD (IX + FObject.Significance), A

                RET

                endif ; ~_OBJECT_SIGNIFICANCE_HANDLERS_DEFAULT_LOCOMOTION_

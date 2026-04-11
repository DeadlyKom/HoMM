
                ifndef _STATE_TREE_POSSESS_
                define _STATE_TREE_POSSESS_
; -----------------------------------------
; выдать объекту AI-контекст и подготовить его к активации
; In:
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
; -----------------------------------------
Possess:        RET
                display " - Possess AI-context:\t\t\t\t", /A, Possess, "\t= busy [ ", /D, $-Possess, " byte(s)  ]"

                endif ; ~_STATE_TREE_POSSESS_

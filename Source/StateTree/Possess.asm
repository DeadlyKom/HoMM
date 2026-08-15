
                ifndef _STATE_TREE_POSSESS_
                define _STATE_TREE_POSSESS_
; -----------------------------------------
; выдать объекту AI-контекст и подготовить его к активации
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
Possess:        RET
                display " - Possess AI-context:\t\t\t\t", /A, Possess, "\t= busy [ ", /D, $-Possess, " byte(s)  ]"

                endif ; ~_STATE_TREE_POSSESS_

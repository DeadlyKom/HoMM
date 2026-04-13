
                ifndef _STATE_TREE_UNPOSSESS_
                define _STATE_TREE_UNPOSSESS_
; -----------------------------------------
; забрать у объекта AI-контекст и перевести его в спящий режим
; In:
;   A  - индекс персонажа
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
;
;   ToDo: возможно потребуется добавть переход объекта в ColdState, 
;         сохраняя важные состояния объекта, для последующего восстановления 
; -----------------------------------------
Unpossess:      ; -----------------------------------------
                ; получить адреса персонажа
                ; In:
                ;   A  - индекс персонажа
                ; Out:
                ;   IX - адрес персонажа            (FCharacter)
                ;   IY - адрес объекта персонажа    (FObjectCharacterAI)
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                CALL Character.Utilities.GetAdr

                LD A, (IY + FObjectCharacterAI.AIContextID)
                CALL RemoveAtSwapByIndex                                        ; удаление AI-контекста по индексу, перемещая последний элемент в массиве
                LD (IY + FObjectCharacterAI.AIContextID), CONTEXT_NONE          ; удаление идентификатора AI-контекста
                RET

                display " - Unpossess AI-context:\t\t\t\t", /A, Unpossess, "\t= busy [ ", /D, $-Unpossess, " byte(s)  ]"

                endif ; ~_STATE_TREE_UNPOSSESS_

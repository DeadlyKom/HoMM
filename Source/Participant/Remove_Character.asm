
                ifndef _PARTICIPANT_REMOVE_CHARACTER_
                define _PARTICIPANT_REMOVE_CHARACTER_
; -----------------------------------------
; удалить персонажа
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
Remove_Character:
                ; ToDo: реализовать удаление персонажа и связанных с ним данных
                RET

                display " - Remove hero:\t\t\t\t\t", /A, Remove_Character, "\t= busy [ ", /D, $-Remove_Character, " byte(s)  ]"

                endif ; ~_PARTICIPANT_REMOVE_CHARACTER_

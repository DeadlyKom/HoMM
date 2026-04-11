
                ifndef _PARTICIPANT_REMOVE_CHARACTER_
                define _PARTICIPANT_REMOVE_CHARACTER_
; -----------------------------------------
; удалить персонажа
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Remove_Character:
                RET

                display " - Remove hero:\t\t\t\t\t", /A, Remove_Character, "\t= busy [ ", /D, $-Remove_Character, " byte(s)  ]"

                endif ; ~_PARTICIPANT_REMOVE_CHARACTER_

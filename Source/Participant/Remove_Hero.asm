
                ifndef _PARTICIPANT_REMOVE_HERO_
                define _PARTICIPANT_REMOVE_HERO_
; -----------------------------------------
; удалить героя
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Remove_Hero:    RET

                display " - Remove hero:\t\t\t\t\t", /A, Remove_Hero, "\t= busy [ ", /D, $-Remove_Hero, " byte(s)  ]"

                endif ; ~_PARTICIPANT_REMOVE_HERO_

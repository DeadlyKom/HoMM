
                ifndef _PARTICIPANT_REMOVE_PLAYER_
                define _PARTICIPANT_REMOVE_PLAYER_
; -----------------------------------------
; удалить игрока
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Remove_Player:  RET

                display " - Remove player:\t\t\t\t\t", /A, Remove_Player, "\t= busy [ ", /D, $-Remove_Player, " byte(s)  ]"

                endif ; ~_PARTICIPANT_REMOVE_PLAYER_

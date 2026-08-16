
                ifndef _PARTICIPANT_REMOVE_PLAYER_
                define _PARTICIPANT_REMOVE_PLAYER_
; -----------------------------------------
; удалить игрока
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
Remove_Player:  ; ToDo: реализовать удаление игрока и связанных с ним данных
                RET

                display " - Remove player:\t\t\t\t\t", /A, Remove_Player, "\t= busy [ ", /D, $-Remove_Player, " byte(s)  ]"

                endif ; ~_PARTICIPANT_REMOVE_PLAYER_

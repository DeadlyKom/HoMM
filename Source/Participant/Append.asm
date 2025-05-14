
                ifndef _PARTICIPANT_APPEND_
                define _PARTICIPANT_APPEND_
; -----------------------------------------
; добавить участников
; In:
;   IX - адрес массива структур FParticipantSettings
;   в переменной GameSession.SaveSlot + FSaveSlot.MapInfo.Participants, хранится 
;   количество участников
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Append:         ; инициализация
                LD A, (GameSession.SaveSlot + FSaveSlot.MapInfo.Participants)
                LD B, A
                LD C, #00
.Loop           ; -----------------------------------------
                ; добавить игрока
                ; In:
                ;   IX - указатель на адрес структуры FParticipantSettings
                ;   B  - индекс добавляемого игрока
                ; Out:
                ;   флаг переполнения Carry установлен, 
                ;   в случае успешного добавления персонажа с первым героем
                ; -----------------------------------------
                PUSH BC
                CALL Add_Player
                POP BC
                INC C
                DJNZ .Loop

                RET

                display " - Append participant:\t\t\t\t", /A, Append, "\t= busy [ ", /D, $-Append, " byte(s)  ]"

                endif ; ~_PARTICIPANT_APPEND_

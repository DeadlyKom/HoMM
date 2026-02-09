
                ifndef _WORLD_OBJECTS_DIRTY_ENVIRONMENT_
                define _WORLD_OBJECTS_DIRTY_ENVIRONMENT_
; -----------------------------------------
; формирование принудительного обновления вокруг объект-спрайта
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
DirtyEnvir:     ; инициализация
                LD DE, Adr.SortBuffer
                LD B, A

.Loop           ; чтение адреса объекта
                LD A, (DE)
                LD IYL, A
                INC E
                LD A, (DE)
                LD IYH, A
                INC E

                PUSH BC
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                PUSH DE

                

                POP DE
.NextObject     POP BC
                DJNZ .Loop
                RET
                RET

                display " - Object dirty environment:\t\t\t\t", /A, DirtyEnvir, "\t= busy [ ", /D, $-DirtyEnvir, " byte(s)  ]"

                endif ; ~_WORLD_OBJECTS_DIRTY_ENVIRONMENT_

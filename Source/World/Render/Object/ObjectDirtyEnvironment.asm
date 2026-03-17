
                ifndef _WORLD_OBJECTS_DIRTY_ENVIRONMENT_
                define _WORLD_OBJECTS_DIRTY_ENVIRONMENT_
; -----------------------------------------
; формирование принудительного обновления вокруг объект-спрайта
; In:
; Out:
; Corrupt:
; Note:
;  необходимо включить страницу работы с объектами (страница 0)
; -----------------------------------------
DirtyEnvir:     ; инициализация
                LD DE, Adr.SortBuffer
                LD B, A
                LD A, #FF
                LD (.Bound), A

.Loop           ; чтение адреса объекта
                LD A, (DE)
                LD IYL, A
                INC E
                LD A, (DE)
                LD IYH, A
                INC E

                PUSH BC
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами

                ; проверка флага обновления объекта
                BIT OBJECT_DIRTY_BIT, (IY + FObject.Flags)
                JR Z, .NextObject                                               ; переход, если флаг не установлен
                PUSH DE

                ;   DE - позиция спрайта в пикселях (D - y, E - x)
                ;   BC - размер bound спрайта в пикселях (B - y, C - x)
                LD DE, (IY + FObject.Bound + FSpriteBound.Location)
                LD BC, (IY + FObject.Bound + FSpriteBound.Size)

                ; сохранени значени, для обсчёта на стадии рисования спрайтов
.Bound          EQU $+1
                LD HL, Adr.SortBuffer + 0xFF
                LD (HL), E
                DEC L
                LD (HL), D
                DEC L
                LD (HL), C
                DEC L
                LD (HL), B
                DEC L
                LD A, L
                LD (.Bound), A
                PUSH BC
                SET_PAGE_MAP                                                    ; включить страницу работы с картой
                POP BC
                CALL BufferUtilities.SpriteBound                                ; обновление Render-буфера указанного bound спрайта

.Failed         POP DE
.NextObject     POP BC
                DJNZ .Loop
.RET            SCF                                                             ; флаг для таблицы вызова,
                                                                                ; говорит что bound спрайта неопределён
                RET

                display " - Object dirty environment:\t\t\t\t", /A, DirtyEnvir, "\t= busy [ ", /D, $-DirtyEnvir, " byte(s)  ]"

                endif ; ~_WORLD_OBJECTS_DIRTY_ENVIRONMENT_

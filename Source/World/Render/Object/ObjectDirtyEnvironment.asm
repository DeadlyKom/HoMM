
                ifndef _WORLD_OBJECTS_DIRTY_ENVIRONMENT_
                define _WORLD_OBJECTS_DIRTY_ENVIRONMENT_
; -----------------------------------------
; формирование принудительного обновления вокруг объект-спрайта
; In:
;   A              - количество видимых объектов в Adr.SortBuffer
;   Adr.SortBuffer - отсортированный массив адресов FObject.Position.Y
; Out:
;   Carry установлен
; Corrupt:
;   AF, BC, DE, HL, IX, IY и альтернативные регистры
; Note:
;   перед вызовом необходимо включить страницу работы с объектами (страница 0)
;   для каждого объекта с установленным OBJECT_DIRTY_BIT старый bound добавляется
;   в список изменённых областей и отмечает затронутые гексагоны в Render-буфере
; -----------------------------------------
DirtyEnvir:     ; инициализация
                LD DE, Adr.SortBuffer
                LD (.ObjectCount), A
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

                ; SortBuffer хранит адрес FObject.Position.Y
                LD A, IYL
                SUB FObject.Position.Y
                LD IYL, A
                JR NC, $+4
                DEC IYH

                PUSH BC
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами

                ; проверка флага обновления объекта
                BIT OBJECT_DIRTY_BIT, (IY + FObject.Flags)
                JR Z, .NextObject                                               ; переход, если флаг не установлен
                PUSH DE
                CALL .RegisterBound                                             ; сохранить bound и обновить Render-буфер

.Failed         POP DE
.NextObject     POP BC
                DJNZ .Loop

                CALL .PropagateDirty                                            ; включить пересекающиеся объекты в область обновления
.RET            SCF                                                             ; флаг для таблицы вызова,
                                                                                ; говорит что bound спрайта неопределён
                RET

; -----------------------------------------
; добавить bound объекта в список изменённых областей
; In:
;   IY - адрес FObject
; Out:
;   DirtyEnvir.Bound - смещение перед первой записью в конце Adr.SortBuffer
; Corrupt:
;   AF, BC, DE, HL, IX и альтернативные регистры
; Note:
;   одна запись занимает четыре байта: Size.Y, Size.X, Location.Y, Location.X
;   функция переключает страницу памяти на страницу карты
; -----------------------------------------
.RegisterBound  LD DE, (IY + FObject.Bound + FSpriteBound.Location)
                LD BC, (IY + FObject.Bound + FSpriteBound.Size)
                LD A, B
                OR A
                RET Z                                                           ; высота bound ещё не определена
                LD A, C
                OR A
                RET Z                                                           ; bound ещё не определён

                ; записи располагаются от конца SortBuffer вниз:
                ; Size.Y, Size.X, Location.Y, Location.X
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
                SET_PAGE_MAP
                POP BC
                JP BufferUtilities.SpriteBound                                 ; обновить гексагоны под bound

; -----------------------------------------
; каскадно пометить чистые объекты, пересекающие изменённые bounds
; In:
;   DirtyEnvir.ObjectCount - количество объектов в Adr.SortBuffer
;   DirtyEnvir.Bound       - начало списка изменённых областей
; Out:
;   OBJECT_DIRTY_BIT установлен у всех объектов, пересекающих область обновления
; Corrupt:
;   AF, BC, DE, HL, IX, IY и альтернативные регистры
; Note:
;   каждый добавленный объект расширяет область обновления своим старым bound;
;   проходы повторяются, пока не перестанут находиться новые пересечения
; -----------------------------------------
.PropagateDirty
                LD A, (.Bound)
                INC A
                RET Z                                                           ; изменённых областей нет

.PropagationPass
                XOR A
                LD (.Changed), A
                LD DE, Adr.SortBuffer
.ObjectCount    EQU $+1
                LD B, #00

.PropagationLoop
                LD A, (DE)
                LD IYL, A
                INC E
                LD A, (DE)
                LD IYH, A
                INC E
                LD A, IYL
                SUB FObject.Position.Y
                LD IYL, A
                JR NC, $+4
                DEC IYH

                PUSH BC
                PUSH DE
                SET_PAGE_OBJECT                                                 ; доступ к FObject после возможного переключения на карту
                BIT OBJECT_DIRTY_BIT, (IY + FObject.Flags)
                JR NZ, .PropagationNext
                CALL .IntersectsDirty
                JR NC, .PropagationNext

                SET OBJECT_DIRTY_BIT, (IY + FObject.Flags)
                CALL .RegisterBound                                             ; новый bound расширяет каскад обновления
                LD A, #01
                LD (.Changed), A

.PropagationNext
                POP DE
                POP BC
                DJNZ .PropagationLoop

.Changed        EQU $+1
                LD A, #00
                OR A
                JR NZ, .PropagationPass
                RET

; -----------------------------------------
; проверить пересечение bound объекта с сохранёнными изменёнными bounds
; In:
;   IY - адрес FObject
; Out:
;   Carry установлен при пересечении
;   Carry сброшен, если пересечения нет или bound объекта не определён
; Corrupt:
;   AF, BC, DE, HL
; -----------------------------------------
.IntersectsDirty
                LD A, (IY + FObject.Bound + FSpriteBound.Size.Width)
                OR A
                RET Z
                LD (.ObjectWidth), A
                LD A, (IY + FObject.Bound + FSpriteBound.Size.Height)
                OR A
                RET Z
                LD (.ObjectHeight), A
                LD A, (IY + FObject.Bound + FSpriteBound.Location.X)
                LD (.ObjectX), A
                LD A, (IY + FObject.Bound + FSpriteBound.Location.Y)
                LD (.ObjectY), A

                LD A, (.Bound)
                INC A
                RET Z
                LD L, A
                LD H, HIGH Adr.SortBuffer

.IntersectionLoop
                LD B, (HL)                                                      ; изменённый Size.Y
                INC L
                LD C, (HL)                                                      ; изменённый Size.X
                INC L
                LD D, (HL)                                                      ; изменённый Location.Y
                INC L
                LD E, (HL)                                                      ; изменённый Location.X
                INC L

                ; changed.right > object.left
                LD A, E
                ADD A, C
.ObjectX        EQU $+1
                CP #00
                JR C, .NoIntersection
                JR Z, .NoIntersection

                ; object.right > changed.left
.ObjectWidth    EQU $+1
                LD A, #00
                LD C, A
                LD A, (.ObjectX)
                ADD A, C
                CP E
                JR C, .NoIntersection
                JR Z, .NoIntersection

                ; changed.bottom > object.top
                LD A, D
                ADD A, B
.ObjectY        EQU $+1
                CP #00
                JR C, .NoIntersection
                JR Z, .NoIntersection

                ; object.bottom > changed.top
.ObjectHeight   EQU $+1
                LD A, #00
                LD B, A
                LD A, (.ObjectY)
                ADD A, B
                CP D
                JR C, .NoIntersection
                JR Z, .NoIntersection

                SCF
                RET

.NoIntersection
                LD A, L
                OR A
                JR NZ, .IntersectionLoop
                OR A                                                            ; Carry сброшен
                RET

; -----------------------------------------
; повторно выставить колонковые флаги для прохода тумана
; In:
;   DirtyEnvir.Bound - начало списка сохранённых изменённых областей
; Out:
; Corrupt:
;   AF, BC, DE, HL, IX и альтернативные регистры
; Note:
;   функция переключает страницу памяти на страницу карты
; -----------------------------------------
RestoreBounds:  LD A, (DirtyEnvir.Bound)
                INC A
                RET Z
                LD L, A
                LD H, HIGH Adr.SortBuffer

.Loop           LD B, (HL)
                INC L
                LD C, (HL)
                INC L
                LD D, (HL)
                INC L
                LD E, (HL)
                INC L
                PUSH HL
                PUSH BC
                SET_PAGE_MAP
                POP BC
                CALL BufferUtilities.SpriteBound
                POP HL
                LD A, L
                OR A
                JR NZ, .Loop
                RET

                display " - Object dirty environment:\t\t\t\t", /A, DirtyEnvir, "\t= busy [ ", /D, $-DirtyEnvir, " byte(s)  ]"

                endif ; ~_WORLD_OBJECTS_DIRTY_ENVIRONMENT_

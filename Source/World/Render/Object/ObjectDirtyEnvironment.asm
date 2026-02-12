
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

                ; расчёт положения объекта относительно верхнего-левого видимойго края
                CALL Utilities.TransformToScr                     
                LD (Kernel.Utilities.SpriteBound.PositionX), DE
                LD (Kernel.Utilities.SpriteBound.PositionY), HL

                ; определение способа отображения объекта
                LD A, (IY + FObjectDefaultSettings.Class)
                AND OBJECT_CLASS_MASK

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_CLASS_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого объекта
                endif

                LD HL, .JumpTable
                CALL Func.JumpTable
                JR C, .Failed                                                   ; переход, если не удалось определить bound спрайта

                ;   DE - позиция спрайта в пикселях (D - y, E - x)
                ;   BC - размер bound спрайта в пикселях (B - y, C - x)

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

.JumpTable      DW Hero.Bound                                                   ; OBJECT_CLASS_HERO
                DW .RET                                                         ; OBJECT_CLASS_CONSTRUCTION
                DW .RET                                                         ; OBJECT_CLASS_PROPS
                DW .RET                                                         ; OBJECT_CLASS_INTERACTION
                DW .RET                                                         ; OBJECT_CLASS_PARTICLE
                DW .RET                                                         ; OBJECT_CLASS_DECAL
                DW .RET                                                         ; OBJECT_CLASS_UI

                display " - Object dirty environment:\t\t\t\t", /A, DirtyEnvir, "\t= busy [ ", /D, $-DirtyEnvir, " byte(s)  ]"

                endif ; ~_WORLD_OBJECTS_DIRTY_ENVIRONMENT_

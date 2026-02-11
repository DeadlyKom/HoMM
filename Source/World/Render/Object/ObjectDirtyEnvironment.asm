
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
                
                ; ToDo: возвращает значения позиции и размеры спрайта
                ;       флаг переполнения установлен, если bound неопределён

.Failed        POP DE
                POP BC
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

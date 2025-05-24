
                ifndef _TICK_OBJECT_
                define _TICK_OBJECT_
; -----------------------------------------
; обработчик тика объектов
; In:
; Out:
; Corrupt:
; Note:
; ----------------------------------------
Tick:           ; количество обрабатываемых объектов
                LD A, (GameSession.WorldInfo + FWorldInfo.ObjectNum)            ; количество элементов в массиве
                OR A
                RET Z                                                           ; выход, если нет элементов в массиве
                
                ; инициализация
                LD B, A
                LD IX, Adr.ObjectsArray                                         ; стартовый адрес массива элементов

.ObjectLoop     PUSH BC

                ; проверка необходимости тика
                BIT OBJECT_TICK_BIT, (IX + FObject.Flags)
                JR Z, .NextObject                                               ; переход, если у объекта отключен флаг тика

                ; получение типа элемента
                LD A, (IX + FObject.Class)
                AND OBJECT_CLASS_MASK

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_CLASS_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого объекта
                endif

                ; тик объекта
                LD HL, .JumpTable
                CALL Func.JumpTable

.NextObject     ; следующий элемент
                LD BC, OBJECT_SIZE
                ADD IX, BC
                
                ; уменьшение счётчика элементов
                POP BC
                DJNZ .ObjectLoop

.RET            RET

.JumpTable      DW Hero                                                         ; OBJECT_CLASS_HERO
                DW #0000                                                        ; OBJECT_CLASS_CONSTRUCTION
                DW #0000                                                        ; OBJECT_CLASS_PROPS
                DW #0000                                                        ; OBJECT_CLASS_INTERACTION
                DW #0000                                                        ; OBJECT_CLASS_PARTICLE
                DW #0000                                                        ; OBJECT_CLASS_DECAL
                DW #0000                                                        ; OBJECT_CLASS_UI

                endif ; ~_TICK_OBJECT_

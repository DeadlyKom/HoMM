
                ifndef _OBJECT_SIGNIFICANCE_EVALUATE_
                define _OBJECT_SIGNIFICANCE_EVALUATE_
; -----------------------------------------
; оценщик уровеня значимости объектов
; In:
; Out:
; Corrupt:
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
; ----------------------------------------
Evaluate:       ; количество обрабатываемых объектов
                LD A, (GameSession.WorldInfo + FWorldInfo.ObjectNum)            ; количество элементов в массиве
                OR A
                RET Z                                                           ; выход, если нет элементов в массиве
                
                ; инициализация
                LD B, A
                LD IX, Adr.ObjectsArray                                         ; стартовый адрес массива элементов

.ObjectLoop     PUSH BC

                ; проверка необходимости тика
                BIT OBJECT_EVALUATE_SIGNIF_BIT, (IX + FObject.Flags)
                JR Z, .NextObject                                               ; переход, если у объекта отключен флаг тика

                ; получение типа элемента
                LD A, (IX + FObject.Class)
                AND OBJECT_CLASS_MASK
                LD (.Class), A

                ; ловушка
                ifdef _DEBUG
                CP OBJECT_CLASS_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, нет такого объекта
                endif

                ; обработка оценки уровеня значимости объектов
                LD HL, Evaluate.JumpTable
                CALL Func.JumpTable
                LD C, A                                                         ; сохранение нового уровня значимости
                XOR (IX + FObject.Significance)
                JR Z, .NextObject                                               ; переход, если у объекта не изменились уровени значимости
                
                PUSH AF
                AND SIGNIFICANCE_LOCOMOTION_MASK
                LD HL, HandleLocomotionChanged.JumpTable
                CALL NZ, .Handle

                POP AF
                AND SIGNIFICANCE_AI_MASK
                LD HL, HandleAIChanged.JumpTable
                CALL NZ, .Handle

.NextObject     ; следующий элемент
                LD BC, OBJECT_SIZE
                ADD IX, BC
                
                ; уменьшение счётчика элементов
                POP BC
                DJNZ .ObjectLoop
.RET            RET

.Handle         ; обработка изменения уровня значимости
.Class          EQU $+1
                LD A, #00
                JP Func.JumpTable

                ; ----------------------------------------
                ; критерии смены уровеня значимости объекта:
                ; - расстоние от объекта, до активного(выбранного) игроком персонажа
                ; - расстояние от объекта до положения камеры
                ; - находится ли объект в тумане (виден/невиден)
                ; ----------------------------------------
                ; оценщики уровеня значимости объектов

.JumpTable      DW Evaluators.Character                                         ; OBJECT_CLASS_CHARACTER
                DW Evaluators.Default                                           ; OBJECT_CLASS_CHARACTER_AI
                DW Evaluators.Default                                           ; OBJECT_CLASS_CONSTRUCTION
                DW Evaluators.Default                                           ; OBJECT_CLASS_PROPS
                DW Evaluators.Default                                           ; OBJECT_CLASS_INTERACTION
                DW Evaluators.Default                                           ; OBJECT_CLASS_PARTICLE
                DW Evaluators.Default                                           ; OBJECT_CLASS_DECAL
                DW Evaluators.Default                                           ; OBJECT_CLASS_UI

                ; ----------------------------------------
                ; обработчики изменения значения locomotion уровеня значимости объекта
HandleLocomotionChanged:
.JumpTable      DW Handlers.Default.Locomotion                                  ; OBJECT_CLASS_CHARACTER
                DW Handlers.Default.Locomotion                                  ; OBJECT_CLASS_CHARACTER_AI
                DW Handlers.Default.Locomotion                                  ; OBJECT_CLASS_CONSTRUCTION
                DW Handlers.Default.Locomotion                                  ; OBJECT_CLASS_PROPS
                DW Handlers.Default.Locomotion                                  ; OBJECT_CLASS_INTERACTION
                DW Handlers.Default.Locomotion                                  ; OBJECT_CLASS_PARTICLE
                DW Handlers.Default.Locomotion                                  ; OBJECT_CLASS_DECAL
                DW Handlers.Default.Locomotion                                  ; OBJECT_CLASS_UI

                ; ----------------------------------------
                ; обработчики изменения значения AI уровеня значимости объекта
HandleAIChanged:
.JumpTable      DW Handlers.Default.AI                                          ; OBJECT_CLASS_CHARACTER
                DW Handlers.Default.AI                                          ; OBJECT_CLASS_CHARACTER_AI
                DW Handlers.Default.AI                                          ; OBJECT_CLASS_CONSTRUCTION
                DW Handlers.Default.AI                                          ; OBJECT_CLASS_PROPS
                DW Handlers.Default.AI                                          ; OBJECT_CLASS_INTERACTION
                DW Handlers.Default.AI                                          ; OBJECT_CLASS_PARTICLE
                DW Handlers.Default.AI                                          ; OBJECT_CLASS_DECAL
                DW Handlers.Default.AI                                          ; OBJECT_CLASS_UI

                endif ; ~_OBJECT_SIGNIFICANCE_EVALUATE_

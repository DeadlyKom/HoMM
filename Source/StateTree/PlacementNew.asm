
                ifndef _STATE_TREE_PLACEMENT_NEW_
                define _STATE_TREE_PLACEMENT_NEW_
; -----------------------------------------
; размещение нового AI-контекста
; In:
; Out:
;   A' - текущий ID AI-контекст
;   DE - адрес свободного элемента
;   флаг переполнения Carry установлен, если нет свободного места в массиве
; Corrupt:
;   HL, DE, AF, AF'
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
; -----------------------------------------
PlacemantNew    ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.AIContextNum

                ; проверка переполнения массива
                LD A, (HL)
                CP STATE_TREE_ACTIVE_AI_MAX
                CCF
                RET C                                                           ; выход, если нет места для размещения AI-контекста

                INC (HL)                                                        ; увеличение счётчика объектов
                LD L, A                                                         ; сохранение номера элемента
                EX AF, AF'                                                      ; сохранение номера элемента
                
                ; --------------------------------------------------------------
                ; ⚠️ ВАЖНО ⚠️
                ;   размер AI-контекста, равен 32, чтобы получить индекс,
                ;   нужно сместить на 3 бита
                ; --------------------------------------------------------------

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения события = адрес первого элемента + N события * STATE_TREE_SIZE
                LD A, L
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                ADD A, A    ; x32
                LD E, A
                LD D, HIGH Adr.AIContextArray

                RET
                display " - Placemant new state tree:\t\t\t\t", /A, PlacemantNew, "\t= busy [ ", /D, $-PlacemantNew, " byte(s)  ]"

                endif ; ~_STATE_TREE_PLACEMENT_NEW_


                ifndef _STATE_TREE_REMOVE_AT_SWAP_
                define _STATE_TREE_REMOVE_AT_SWAP_
; -----------------------------------------
; удаление AI-контекста по индексу, перемещая последний элемент в массиве
; In:
;   A - индекс удаляемого AI-контекста FAIContext
; Out:
;   HL - новый адрес AI-контекста, если перемещён
;   флаг переполнения установлен, если небыло перемещение при удалении
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
; -----------------------------------------
RemoveAtSwapByIndex:; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.AIContextNum
                DEC (HL)
                LD B, (HL)                                                      ; чтение количества элементов в массиве AI-контекстов
                RET Z                                                           ; выход, если массив пуст

                ; проверка на последний удаляемый элемент в массиве
                CP B
                SCF                                                             ; флаг установлен, отсутствует перемещение
                RET Z                                                           ; выход, если индекс удаляемого элемента последний

                ; расчёт адреса удаляемого элемента в массиве
                ; адрес расположения элемента = адрес первого элемента + N элемента * STATE_TREE_SIZE
                LD D, HIGH Adr.AIContextArray
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                ADD A, A    ; x32
                LD E, A

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения элемента = адрес первого элемента + N элемента * STATE_TREE_SIZE
                LD H, D
                LD A, B
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                ADD A, A    ; x32
                LD L, A

                PUSH HL
                PUSH DE

                ifdef _OPTIMIZE
                rept STATE_TREE_SIZE
                LDI
                endr
                else
                LD BC, STATE_TREE_SIZE
                CALL Memcpy.FastLDIR
                endif

                POP DE
                POP HL

                OR A                                                            ; сброс флага, произведено пермещение
                RET

                display " - Remove at swap by index 'state tree':\t\t", /A, RemoveAtSwapByIndex, "\t= busy [ ", /D, $-RemoveAtSwapByIndex, " byte(s)  ]"

                endif ; ~_STATE_TREE_REMOVE_AT_SWAP_

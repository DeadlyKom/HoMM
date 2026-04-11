
                ifndef _STATE_TREE_REMOVE_AT_SWAP_
                define _STATE_TREE_REMOVE_AT_SWAP_
; -----------------------------------------
; удаление AI-контекста, перемещая последний элемент в массиве
; In:
;   IY - адрес удаляемого AI-контекста FAIContext
; Out:
;   HL - новый адрес AI-контекста, если перемещён
;   флаг переполнения установлен, если небыло перемещение при удалении
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   необходимо включить страницу с массивом событий (страница 0)
; -----------------------------------------
RemoveAtSwap:   ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.AIContextNum
                DEC (HL)
                LD B, (HL)                                                      ; чтение количества элементов в массиве AI-контекстов
                RET Z                                                           ; выход, если массив пуст

                ; расчёт индекса удаляемого элемента
                PUSH IY
                POP HL

                ; копирование адреса удаляемого элемента
                LD D, H
                LD E, L

                ; --------------------------------------------------------------
                ; ⚠️ ВАЖНО ⚠️
                ;   размер AI-контекста, равен 32, чтобы получить индекс,
                ;   нужно сместить на 3 бита
                ; --------------------------------------------------------------

                ; проверка на последний удаляемый элемент в массиве
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                LD A, #07
                AND H
                CP B
                SCF                                                             ; флаг установлен, отсутствует перемещение
                RET Z                                                           ; выход, если индекс удаляемого элемента последний

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения элемента = адрес первого элемента + N элемента * STATE_TREE_SIZE
                LD H, HIGH Adr.AIContextArray
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

                display " - Remove at swap 'state tree':\t\t\t\t", /A, RemoveAtSwap, "\t= busy [ ", /D, $-RemoveAtSwap, " byte(s)  ]"

                endif ; ~_STATE_TREE_REMOVE_AT_SWAP_

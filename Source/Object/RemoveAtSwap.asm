
                ifndef _OBJECT_REMOVE_AT_SWAP_
                define _OBJECT_REMOVE_AT_SWAP_
; -----------------------------------------
; удаление объекта, перемещая последний элемент в массиве
; In:
;   IY - адрес удаляемого объекта FObject
; Out:
;   HL - новый адрес объекта, если перемещён
;   флаг переполнения установлен, если небыло перемещение при удалении
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
RemoveAtSwap:   ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.ObjectNum
                DEC (HL)
                LD A, (HL)                                                      ; чтение количества элементов в массиве объектов
                RET Z                                                           ; выход, если массив пуст

                ; расчёт индекса удаляемого объекта
                PUSH IY
                POP HL

                ; копирование адреса удаляемого объекта
                LD D, H
                LD E, L

                ; --------------------------------------------------------------
                ; ⚠️ ВАЖНО ⚠️
                ;   размер объекта OBJECT_SIZE, равен 32, чтобы получить индекс,
                ;   нужно сместить на 3 бита
                ; --------------------------------------------------------------

                ; проверка на последний удаляемый элемент в массиве
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                CP H
                SCF                                                             ; флаг установлен, отсутствует перемещение
                RET Z                                                           ; выход, если индекс удаляемого элемента последний

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения элемента = адрес первого элемента + N элемента * OBJECT_SIZE
                LD H, HIGH Adr.ObjectsArray >> 5    ; %00000110
                ADD A, A    ; %aaaaaaa0 : a
                RL H        ; %0000110a
                ADD A, A    ; %aaaaaa00 : a
                RL H        ; %000110aa
                ADD A, A    ; %aaaaa000 : a
                RL H        ; %00110aaa
                ADD A, A    ; %aaaa0000 : a
                RL H        ; %0110aaaa
                ADD A, A    ; %aaa00000 : a
                RL H        ; %110aaaaa
                LD L, A

                PUSH HL
                PUSH DE

                ifdef _OPTIMIZE
                rept OBJECT_SIZE
                LDI
                endr
                else
                LD BC, OBJECT_SIZE
                CALL Memcpy.FastLDIR
                endif

                POP DE
                POP HL

                OR A                                                            ; сброс флага, произведено пермещение
                RET

                display " - Remove at swap 'object':\t\t\t\t", /A, RemoveAtSwap, "\t= busy [ ", /D, $-RemoveAtSwap, " byte(s)  ]"

                endif ; ~_OBJECT_REMOVE_AT_SWAP_

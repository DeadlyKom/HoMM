
                ifndef _OBJECT_REMOVE_AT_SWAP_
                define _OBJECT_REMOVE_AT_SWAP_
; -----------------------------------------
; удаление элемента, перемещая последний элемент в массиве
; In:
;   IY - адрес удаляемого элемента
; Out:
;   HL - новый адрес элемента, если перемещён
;   флаг переполнения установлен, если небыло перемещение при удалении
; Corrupt:
;   HL, DE, BC, AF
; Note:
; -----------------------------------------
RemoveAtSwap:   ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.ObjectNum
                DEC (HL)
                LD A, (HL)                                                      ; чтение количества элементов в массиве объектов
                SCF                                                             ; флаг установлен, отсутствует перемещение
                RET Z                                                           ; выход, если массив пуст

                ; расчёт индекса удаляемого элемента
                PUSH IY
                POP HL

                ; копирование адреса удаляемого элемента
                LD D, H
                LD E, L

                ; проверка на последний удаляемый элемент в массиве
                CALL Object.Utilities.GetObjectID.HL                            ; получить ID объекта
                CP H
                SCF                                                             ; флаг установлен, отсутствует перемещение
                RET Z                                                           ; выход, если индекс удаляемого элемента последний

                ; расчёт адреса последнего элемента в массиве
                CALL Object.Utilities.GetAdr.HL                                 ; получить адрес объекта
                
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

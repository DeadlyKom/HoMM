
                ifndef _OBJECT_REMOVE_AT_SWAP_
                define _OBJECT_REMOVE_AT_SWAP_
; -----------------------------------------
; удаление объекта, перемещая последний элемент в массиве
; In:
;   флаг переполнения отвечает с каким массивом объектов производится работа
;   если сброшен, то работа с Adr.StaticArray иначе с Adr.DynamicArray
;   IY - адрес объекта FObject
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
; -----------------------------------------
RemoveAtSwap:   ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.ObjectNum
                LD A, (HL)                                                      ; чтение количества элементов в массиве объектов
                DEC (HL)
                RET Z                                                           ; выход, если массив пуст

                ; расчёт индекса удаляемого объекта
                PUSH IY
                POP HL

                ; копирование адреса удаляемого объекта
                LD D, H
                LD E, L

                ; проверка на последний удаляемый элемент в массиве
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                RES 7, H
                CP H
                RET Z                                                           ; выход, если индекс удаляемого элемента последний

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                LD H, HIGH Adr.ObjectsArray >> 4    ; %00001100
                ADD A, A    ; %aaaaaaa0 : 0
                RL H        ; %0001100a
                ADD A, A    ; %aaaaaa00 : a
                RL H        ; %001100aa
                ADD A, A    ; %aaaaa000 : a
                RL H        ; %01100aaa
                ADD A, A    ; %aaaa0000 : a
                RL H        ; %1100aaaa
                LD L, A

                ifdef _OPTIMIZE
                rept OBJECT_SIZE
                LDI
                endr
                else
                LD BC, OBJECT_SIZE
                JP Memcpy.FastLDIR
                endif

                display " - Remove at swap object:\t\t\t\t", /A, RemoveAtSwap, "\t= busy [ ", /D, $-RemoveAtSwap, " byte(s)  ]"

                endif ; ~_OBJECT_REMOVE_AT_SWAP_

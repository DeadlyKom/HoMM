
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
                LD HL, GameSession.WorldInfo + FWorldInfo.StaticObjectNum
                
                ; корректировка адреса счётчика
                LD C, HIGH Adr.StaticArray
                JR NC, $+5
                LD C, HIGH Adr.DynamicArray
                INC HL

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
                EX AF, AF'
                LD A, H
                SUB C
                LD H, A
                EX AF, AF'
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                CP H
                RET Z                                                           ; выход, если индекс удаляемого элемента последний

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                SRL A       ; %00aaaaaa : a
                RR L        ; %a0000000 : 0                                     ; регистр L сброшен
                RRA         ; %000aaaaa : a
                RR L        ; %aa000000 : 0
                RRA         ; %0000aaaa : a
                RR L        ; %aaa00000 : 0
                RRA         ; %00000aaa : a
                RR L        ; %aaaa0000 : 0
                ADD A, C
                LD H, A

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

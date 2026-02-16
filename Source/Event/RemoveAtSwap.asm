
                ifndef _EVENT_REMOVE_AT_SWAP_
                define _EVENT_REMOVE_AT_SWAP_
; -----------------------------------------
; удаление события, перемещая последний элемент в массиве
; In:
;   IY - адрес удаляемого события FEvent
; Out:
;   HL - новый адрес события, если перемещён
;   флаг переполнения установлен, если небыло перемещение при удалении
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   необходимо включить страницу с массивом событий (страница 7)
; -----------------------------------------
RemoveAtSwap:   ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.EventNum
                DEC (HL)
                LD A, (HL)                                                      ; чтение количества элементов в массиве объектов
                RET Z                                                           ; выход, если массив пуст

                ; расчёт индекса удаляемого события
                PUSH IY
                POP HL

                ; копирование адреса удаляемого события
                LD D, H
                LD E, L

                ; проверка на последний удаляемый элемент в массиве
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                CP H
                SCF                                                             ; флаг установлен, отсутствует перемещение
                RET Z                                                           ; выход, если индекс удаляемого элемента последний

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения события = адрес первого элемента + N события * EVENT_SIZE
                LD H, HIGH Adr.EventArray
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                LD L, A

                PUSH HL
                PUSH DE

                ifdef _OPTIMIZE
                rept EVENT_SIZE
                LDI
                endr
                else
                LD BC, EVENT_SIZE
                CALL Memcpy.FastLDIR
                endif

                POP DE
                POP HL

                OR A                                                            ; сброс флага, произведено пермещение
                RET

                display " - Remove by swap event:\t\t\t\t", /A, RemoveAtSwap, "\t= busy [ ", /D, $-RemoveAtSwap, " byte(s)  ]"

                endif ; ~_EVENT_REMOVE_AT_SWAP_

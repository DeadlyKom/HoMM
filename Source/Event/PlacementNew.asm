
                ifndef _EVENT_PLACEMENT_NEW_
                define _EVENT_PLACEMENT_NEW_
; -----------------------------------------
; размещение нового события
; In:
; Out:
;   A' - текущий ID события
;   DE - адрес свободного элемента
;   флаг переполнения Carry установлен, если нет свободного места в массиве
; Corrupt:
;   HL, DE, AF, AF'
; Note:
;   необходимо включить страницу с массивом событий (страница 7)
; -----------------------------------------
PlacemantNew    ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.EventNum

                ; проверка переполнения массива
                LD A, (HL)
                CP EVENT_MAX
                CCF
                RET C                                                           ; выход, если нет места для размещения объексобытията

                INC (HL)                                                        ; увеличение счётчика объектов
                LD L, A                                                         ; сохранение номера элемента
                EX AF, AF'                                                      ; сохранение номера элемента
                
                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения события = адрес первого элемента + N события * EVENT_SIZE
                LD A, L
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                ADD A, A    ; x16
                LD E, A
                LD D, HIGH Adr.EventArray

                RET

                display " - Placemant new event:\t\t\t\t", /A, PlacemantNew, "\t= busy [ ", /D, $-PlacemantNew, " byte(s)  ]"

                endif ; ~_EVENT_PLACEMENT_NEW_

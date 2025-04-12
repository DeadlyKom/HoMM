
                ifndef _OBJECT_PLACEMENT_NEW_
                define _OBJECT_PLACEMENT_NEW_
; -----------------------------------------
; размещение нового объекта
; In:
;   флаг переполнения отвечает с каким массивом объектов производится работа
;   если сброшен, то работа с Adr.StaticArray иначе с Adr.DynamicArray
; Out:
;   A' - текущий ID объекта
;   IY - адрес свободного элемента
;   флаг переполнения Carry установлен, если нет свободного места в массиве
; Corrupt:
;   HL, AF, AF'
; Note:
; -----------------------------------------
PlacemantNewObj ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.StaticObjectNum
                
                ; корректировка адреса счётчика
                LD A, HIGH Adr.StaticArray
                JR NC, $+5
                LD A, HIGH Adr.DynamicArray
                INC HL
                EX AF, AF'                                                      ; сохранение старшего адреса массива объектов

                ; проверка переполнения массива
                LD A, (HL)
                CP OBJECT_MAX
                CCF
                RET C                                                           ; выход, если нет места для размещения объекта
                
                INC (HL)                                                        ; увеличение счётчика объектов
                EX AF, AF'                                                      ; восстановление старшего адреса массива объектов
                LD H, A

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                LD L, #00
                SRL A       ; %00aaaaaa : a
                RR L        ; %a0000000 : 0
                RRA         ; %000aaaaa : a
                RR L        ; %aa000000 : 0
                RRA         ; %0000aaaa : a
                RR L        ; %aaa00000 : 0
                RRA         ; %00000aaa : a
                RR L        ; %aaaa0000 : 0
                ADD A, H
                LD IYH, A
                LD A, L
                LD IYL, A

                RET

                display " - Placemant new object:\t\t\t\t", /A, PlacemantNewObj, "\t= busy [ ", /D, $-PlacemantNewObj, " byte(s)  ]"

                endif ; ~_OBJECT_PLACEMENT_NEW_

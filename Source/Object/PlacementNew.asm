
                ifndef _OBJECT_PLACEMENT_NEW_
                define _OBJECT_PLACEMENT_NEW_
; -----------------------------------------
; размещение нового объекта
; In:
; Out:
;   A' - текущий ID объекта
;   IY - адрес свободного элемента
;   флаг переполнения Carry установлен, если нет свободного места в массиве
; Corrupt:
;   HL, AF, AF'
; Note:
; -----------------------------------------
PlacemantNewObj ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.ObjectNum

                ; проверка переполнения массива
                LD A, (HL)
                INC A                                                           ; OBJECT_MAX
                CCF
                RET Z                                                           ; выход, если нет места для размещения объекта
                DEC A
                
                INC (HL)                                                        ; увеличение счётчика объектов
                LD L, A                                                         ; сохранение номера элемента
                EX AF, AF'                                                      ; сохранение номера элемента
                
                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                LD H, HIGH Adr.ObjectsArray >> 4    ; %00001100
                LD A, L     ; %aaaaaaaa
                ADD A, A    ; %aaaaaaa0 : a
                RL H        ; %0001100a
                ADD A, A    ; %aaaaaa00 : a
                RL H        ; %001100aa
                ADD A, A    ; %aaaaa000 : a
                RL H        ; %01100aaa
                ADD A, A    ; %aaaa0000 : a
                RL H        ; %1100aaaa

                LD IYL, A
                LD A, H
                LD IYH, A

                RET

                display " - Placemant new object:\t\t\t\t", /A, PlacemantNewObj, "\t= busy [ ", /D, $-PlacemantNewObj, " byte(s)  ]"

                endif ; ~_OBJECT_PLACEMENT_NEW_


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
PlacemantNew    ; инициализация
                LD HL, GameSession.WorldInfo + FWorldInfo.ObjectNum

                ; проверка переполнения массива
                LD A, (HL)
                CP OBJECT_MAX
                CCF
                RET C                                                           ; выход, если нет места для размещения объекта

                INC (HL)                                                        ; увеличение счётчика объектов
                LD L, A                                                         ; сохранение номера элемента
                EX AF, AF'                                                      ; сохранение номера элемента
                
                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
                LD H, HIGH Adr.ObjectsArray >> 4    ; %00001100
                LD A, L     ; %0aaaaaaa
                ADD A, A    ; %aaaaaaa0 : 0
                ADD A, A    ; %aaaaaa00 : a
                RL H        ; %0001100a
                ADD A, A    ; %aaaaa000 : a
                RL H        ; %001100aa
                ADD A, A    ; %aaaa0000 : a
                RL H        ; %01100aaa
                ADD A, A    ; %aaa00000 : a
                RL H        ; %1100aaaa

                LD IYL, A
                LD A, H
                LD IYH, A

                RET

                display " - Placemant new object:\t\t\t\t", /A, PlacemantNew, "\t= busy [ ", /D, $-PlacemantNew, " byte(s)  ]"

                endif ; ~_OBJECT_PLACEMENT_NEW_

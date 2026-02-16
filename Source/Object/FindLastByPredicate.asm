
                ifndef _OBJECT_FIND_LAST_BY_PREDICATE_
                define _OBJECT_FIND_LAST_BY_PREDICATE_
; -----------------------------------------
; поиск объекта с конца массива, используя предикат
; In:
;   IX - адрес предиката
; Out:
; Corrupt:
; Note:
;   функция предиката, осуществляет проверку соответствия требуемым условиям
;   установленный флаг переполнения сигнализирует, об успешности поиска, поиск завершается
;   IY - адрес проверяемого объекта
; -----------------------------------------
FindLastByPredicate:
                ;
                LD A, (GameSession.WorldInfo + FWorldInfo.ObjectNum)
                LD B, A

                ; расчёт адреса последнего элемента в массиве
                ; адрес расположения объекта = адрес первого элемента + N объекта * OBJECT_SIZE
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
                LD IYL, A
                LD A, H
                LD IYH, A
            
.Loop           PUSH BC

.PrevObject     ; слепредыдущий элемент
                LD BC, -OBJECT_SIZE
                ADD IY, BC

                CALL .Invoke

                POP BC
                RET NC                                                          ; выход, если найден
                DJNZ .Loop

                SCF                                                             ; установка флага переполнения, искомый объект не найден
                RET

.Invoke         JP (IX)

                display " - Find last by predicatel:\t\t\t\t", /A, FindLastByPredicate, "\t= busy [ ", /D, $-FindLastByPredicate, " byte(s)  ]"

                endif ; ~_OBJECT_SMAR_OBJECT_FIND_LAST_BY_PREDICATE_T_REMOVE_

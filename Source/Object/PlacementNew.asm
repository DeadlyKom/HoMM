
                ifndef _OBJECT_PLACEMENT_NEW_
                define _OBJECT_PLACEMENT_NEW_
; -----------------------------------------
; размещение нового объекта
; In:
; Out:
;   A' - текущий ID объекта
;   HL - адрес свободного элемента
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
                RET C                                                           ; выход, если нет места для размещения элемента

                INC (HL)                                                        ; увеличение счётчика элементов
                LD L, A                                                         ; сохранение номера элемента
                EX AF, AF'                                                      ; сохранение номера элемента
                ; расчёт адреса последнего элемента в массиве
                LD A, L     ; %0aaaaaaa
                CALL Object.Utilities.GetAdr.IY                                 ; получить адрес объекта
                ; OR A                                                            ; сброс флага, элемент расположен
                ; RL H выталкивает старший бит во флаг и он сброшен
                RET

                display " - Placemant new object:\t\t\t\t", /A, PlacemantNew, "\t= busy [ ", /D, $-PlacemantNew, " byte(s)  ]"

                endif ; ~_OBJECT_PLACEMENT_NEW_

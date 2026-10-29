
                ifndef _ITEM_UTILITIES_BASE_ITEM_ADDRESS_
                define _ITEM_UTILITIES_BASE_ITEM_ADDRESS_
; -----------------------------------------
; получить адрес базового описания предмета
; In:
;   HL - адрес начала ресурса базовых описаний
;   A  - индекс базового предмета
; Out:
;   HL - адрес FBaseItem
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в "общей памяти"
;   необходимо включить страницу метаданных
; -----------------------------------------
BaseAddress.HL: ; проверка индекса первого описания
                OR A
                RET Z                                                           ; выход, если требуется первое описание

                ; проверка размера свойства для расчёта сдвигами
                if FItemProperty != 4
                error "address calculation error"
                endif

                ; инициализация
                LD B, A
                LD C, FBaseItem.PropertiesNum

.Loop           ; расчёт адреса поля PropertiesNum текущего описания
                LD E, C
                LD D, #00
                ADD HL, DE

                ; чтение количества свойств в 16-битный регистр
                LD E, (HL)
                INC HL                                                          ; переход к полю Properties
                
                ; расчёт размера массива свойств FItemProperty
                EX DE, HL
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4

                ; расчёт адреса начала следующего FBaseItem
                ADD HL, DE
                DJNZ .Loop

                RET

                endif ; ~_ITEM_UTILITIES_BASE_ITEM_ADDRESS_


                ifndef _ITEM_UTILITIES_ITEM_LOCATION_ADDRESS_
                define _ITEM_UTILITIES_ITEM_LOCATION_ADDRESS_
; -----------------------------------------
; получить адрес размещения предмета
; In:
;   A  - идентификатор предмета
; Out:
;   HL - адрес FItemLocation
;   A  - страница массива предметов
; Corrupt:
;   HL, BC, AF
; Note:
;   ℹ️ код расположен в "общей памяти"
;   ITEM_ID_NONE проверяется перед вызовом
;   полученную страницу включает вызывающий код
; -----------------------------------------
Location.HL:    ; проверка допустимого идентификатора предмета
                ifdef _DEBUG
                CP ITEM_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, идентификатор предмета выходит за пределы массива
                endif

                ; проверка размера структуры размещения предмета
                if FItemLocation != 4
                error "address calculation error"
                endif

                ; расчёт смещения размещения предмета размером 4 байта
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4

                ; расчёт смещения относительно начала области предметов
                LD BC, ITEM_MAX * FItem
                ADD HL, BC

                ; расчёт адреса размещения предмета
                LD A, (GameState.Inventory.High)
                ADD A, H
                LD H, A

                ; получение страницы массива предметов
                LD A, (GameState.Inventory.Page)
                RET

                endif ; ~_ITEM_UTILITIES_ITEM_LOCATION_ADDRESS_


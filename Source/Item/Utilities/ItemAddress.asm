
                ifndef _ITEM_UTILITIES_ITEM_ADDRESS_
                define _ITEM_UTILITIES_ITEM_ADDRESS_
; -----------------------------------------
; получить адрес экземпляра предмета
; In:
;   A  - идентификатор предмета
; Out:
;   HL - адрес FItem
;   A  - страница массива предметов
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Address.HL:     ; проверка допустимого идентификатора предмета
                ifdef _DEBUG
                CP ITEM_MAX
                DEBUG_BREAK_POINT_NC                                            ; ошибка, идентификатор предмета выходит за пределы массива
                endif

                ; проверка размера структуры экземпляра предмета
                if ITEM_SIZE != 32
                error "address calculation error"
                endif

                ; расчёт смещения экземпляра предмета размером 32 байта
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16
                ADD HL, HL  ; x32

                ; расчёт адреса относительно начала массива предметов
                LD A, (GameState.Inventory.High)
                ADD A, H
                LD H, A

                ; получение страницы массива предметов
                LD A, (GameState.Inventory.Page)
                RET

                endif ; ~_ITEM_UTILITIES_ITEM_ADDRESS_


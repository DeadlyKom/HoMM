
                ifndef _INVENTORY_UTILITIES_GET_ITEM_
                define _INVENTORY_UTILITIES_GET_ITEM_
; -----------------------------------------
; получение копии экземпляра предмета по идентификатору
; In:
;   DE - адрес временного буфера в общей памяти
;   A  - идентификатор экземпляра предмета
; Out:
;   HL - адрес копии FItem
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в "общей памяти"
;   при выходе восстановлена страница вызывающего кода
; -----------------------------------------
GetItem:        ; получение адреса и страницы экземпляра предмета
                CALL Item.Utilities.GetAdr.HL                                   ; получить адрес экземпляра предмета

                ; копирование экземпляра предмета во временный буфер
                PUSH DE
                LD BC, FItem
                CALL Func.CopyFromPage
                POP HL                                                          ; получение адреса скопированного FItem
                RET

                endif ; ~_INVENTORY_UTILITIES_GET_ITEM_

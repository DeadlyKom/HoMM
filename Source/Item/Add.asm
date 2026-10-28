
                ifndef _ITEM_ADD_
                define _ITEM_ADD_
; -----------------------------------------
; добавить предмет
; In:
;   HL - адрес подготовленного FItem, за которым расположен FItemLocation
; Out:
;   A' - идентификатор добавленного предмета
;   флаг переполнения установлен, если нет места для добавления предмета
; Corrupt:
;   HL, DE, BC, AF, AF', IY
; Note:
;   ℹ️ код расположен в "общей памяти"
;   исходные структуры должны быть сформированы в общей памяти
;   идентификатор возвращается при успешном добавлении
;   ⚠️ ВАЖНО ⚠️
;   меняет страницу памяти
; -----------------------------------------
Add:            ; сохранение адреса подготовленных данных
                EX DE, HL

                ; размещение новой записи в конце массива
                CALL PlacementNew
                RET C                                                           ; выход, если нет места для добавления предмета

                ; включение страницы массива предметов
                SET_PAGE_A

                ; копирование подготовленного экземпляра предмета
                EX DE, HL
                ifdef _OPTIMIZE
                rept ITEM_SIZE
                LDI
                endr
                else
                LD BC, ITEM_SIZE
                CALL Memcpy.FastLDIR
                endif

                ; копирование подготовленного размещения предмета
                SET_REGISTER DE, IY
                ifdef _OPTIMIZE
                rept ITEM_LOCATION_SIZE
                LDI
                endr
                else
                LD BC, ITEM_LOCATION_SIZE
                CALL Memcpy.FastLDIR
                endif

                OR A                                                            ; сброс флага, предмет добавлен
                RET

                display " - Add item:\t\t\t\t\t\t", /A, Add, "\t= busy [ ", /D, $-Add, " byte(s) ]"

                endif ; ~_ITEM_ADD_


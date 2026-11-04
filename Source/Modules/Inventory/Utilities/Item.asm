                ifndef _MODULE_INVENTORY_UTILITIES_ITEM_
                define _MODULE_INVENTORY_UTILITIES_ITEM_
                module Item
; -----------------------------------------
; чтение размера изображения экземпляра предмета
; In:
;   A  - идентификатор экземпляра предмета
; Out:
;   BC - размер в знакоместах (B - y, C - x)
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
ReadSize:       ; копирование экземпляра во временный буфер
                LD DE, Inventory.Utilities.Buffer
                ; -----------------------------------------
                ; In:
                ;   DE - адрес временного буфера в общей памяти
                ;   A  - идентификатор экземпляра предмета
                ; Out:
                ;   HL - адрес копии FItem
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.SharedCode.Utilities.GetItem                     ; получение копии экземпляра предмета

                ; получение базового описания экземпляра
                LD A, (HL)                                                      ; чтение индекса базового описания из FItem.BaseItem
                LD DE, Inventory.Utilities.Buffer
                ; -----------------------------------------
                ; In:
                ;   DE - адрес временного буфера в общей памяти
                ;   A  - индекс базового предмета
                ; Out:
                ;   HL - адрес копии FBaseItem с массивом FItemProperty
                ; Corrupt:
                ;   HL, DE, BC, AF, AF'
                ; -----------------------------------------
                CALL Inventory.SharedCode.Utilities.GetBaseItem                 ; получение копии базового описания предмета со свойствами

                ; расчёт адреса заголовка изображения предмета
                INC HL                                                          ; переход к полю FBaseItem.ListName
                INC HL                                                          ; переход к полю FBaseItem.Visual
                LD L, (HL)                                                      ; чтение индекса визуала из FBaseItem.Visual
                LD H, #00
                ADD HL, HL    ; x2
                ADD HL, HL    ; x4
                LD BC, (Inventory.SharedCode.Render.Item.Address)
                ADD HL, BC

                ; копирование размеров из страницы графики предметов
                LD A, (Inventory.SharedCode.Render.Item.Page)
                LD DE, Inventory.Utilities.Buffer
                LD BC, FSize
                CALL Func.CopyFromPage
                LD BC, (Inventory.Utilities.Buffer)

                RET
; -----------------------------------------
; запись размещения из общего буфера в страницу предметов
; In:
;   A  - идентификатор экземпляра предмета
;   Inventory.Utilities.Buffer - подготовленная запись FItemLocation
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в модуле "инвентаря"
; -----------------------------------------
WritePlacement: ; получение адреса размещения экземпляра
                ; -----------------------------------------
                ; In:
                ;   A  - идентификатор предмета
                ; Out:
                ;   HL - адрес FItemLocation
                ;   A  - страница массива предметов
                ; Corrupt:
                ;   HL, BC, AF
                ; -----------------------------------------
                CALL Item.Utilities.GetLocAdr.HL                                ; получить адрес размещения предмета
                EX DE, HL
                EX AF, AF'
                CALL GetPage
                LD HL, Inventory.Utilities.Buffer
                LD BC, FItemLocation
                CALL Memcpy.FromPage
                RET

                endmodule

                endif ; ~_MODULE_INVENTORY_UTILITIES_ITEM_

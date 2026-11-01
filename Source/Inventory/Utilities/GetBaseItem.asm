
                ifndef _INVENTORY_UTILITIES_GET_BASE_ITEM_
                define _INVENTORY_UTILITIES_GET_BASE_ITEM_
; -----------------------------------------
; получение копии базового описания предмета со свойствами
; In:
;   DE - адрес временного буфера в общей памяти
;   A  - индекс базового предмета
; Out:
;   HL - адрес копии FBaseItem со следующим за ним массивом FItemProperty
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в "общей памяти"
;   буфер должен вмещать FBaseItem и все свойства выбранного описания
; -----------------------------------------
GetBaseItem:    ; инициализация
                EX AF, AF'                                                      ; сохранение индекса базового предмета
                PUSH_PAGE                                                       ; сохранение номера страницы в стеке
                PUSH DE                                                         ; сохранение адреса временного буфера в общей памяти

                ; получение базового описания из ресурса метаданных
                LD A, (Inventory.SharedCode.Render.Item.Metadata.Page)
                SET_PAGE_A
                LD HL, (Inventory.SharedCode.Render.Item.Metadata.Adr)
                EX AF, AF'                                                      ; восстановление индекса базового предмета
                CALL Item.Utilities.GetBaseAdr.HL                               ; получить адрес базового описания предмета

                ; чтение количества свойств выбранного базового описания
                PUSH HL                                                         ; сохранение адреса исходного FBaseItem
                LD DE, FBaseItem.PropertiesNum
                ADD HL, DE
                LD A, (HL)

                ; расчёт размера массива свойств FItemProperty
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4

                ; расчёт полного размера базового описания со свойствами
                LD DE, FBaseItem
                ADD HL, DE
                LD B, H
                LD C, L
                POP HL                                                          ; восстановление адреса исходного FBaseItem

                ; подготовка адреса буфера для копирования и возврата
                POP DE                                                          ; восстановление адреса временного буфера в общей памяти
                PUSH DE

                ; копирование базового описания и всех его свойств в общий буфер
                LDIR
                POP HL                                                          ; получение адреса скопированного FBaseItem
                JP_POP_PAGE                                                     ; восстановление исходной страницы

                endif ; ~_INVENTORY_UTILITIES_GET_BASE_ITEM_

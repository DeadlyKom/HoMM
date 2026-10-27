
                ifndef _STRUCT_MAP_ITEM_
                define _STRUCT_MAP_ITEM_
; -----------------------------------------
;   элемент блока начальных предметов карты
; -----------------------------------------
                struct FMapItem                                                 ; начальный предмет карты                               [36 байт]
Item            FItem                                                           ; данные экземпляра предмета                            [32 байта]
Location        FItemLocation                                                   ; местонахождение предмета                              [4 байта]
                ends

                endif ; ~_STRUCT_MAP_ITEM_

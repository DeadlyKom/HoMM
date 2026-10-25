
                ifndef _STRUCTS_ITEM_PROPERTY_
                define _STRUCTS_ITEM_PROPERTY_
; -----------------------------------------
;   свойство предмета
;   хранит тип и фактическую величину свойства
; -----------------------------------------
                struct FItemProperty                                            ; свойство предмета                                     [4 байта]
Type            DB #00                                                          ; тип свойства (констаное значение ITEM_PROPERTY_ )     [1 байт]
Value           FValue                                                          ; фактическая величина свойства                         [2 байта]
Dummy           DB #00                                                          ; резерв                                                [1 байт]
                ends

                endif ; ~_STRUCTS_ITEM_PROPERTY_

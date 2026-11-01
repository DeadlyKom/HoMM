
                ifndef _STRUCTS_INVENTORY_DESCRIPTION_
                define _STRUCTS_INVENTORY_DESCRIPTION_
; -----------------------------------------
; строка описания предмета
; -----------------------------------------
                struct FInventoryDescriptionLine
Width           DB #00                                                          ; ширина строки в пикселях
Attribute       DB #00                                                          ; атрибут цвета строки
Text            DW #0000                                                        ; адрес буфера строки
                ends

                endif ; ~_STRUCTS_INVENTORY_DESCRIPTION_

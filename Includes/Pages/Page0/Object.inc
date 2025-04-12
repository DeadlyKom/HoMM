
                ifndef _PAGE_0_OBJECT_
                define _PAGE_0_OBJECT_
Object:
.Initialize     EQU Page0.Object.Initialize                                     ; инициализация работы с объектами
.PlacemantNew   EQU Page0.Object.PlacemantNewObj                                ; размещение нового объекта
.RemoveAtSwap   EQU Page0.Object.RemoveAtSwap                                   ; удаление объекта, перемещая последний элемент в массиве

Object.Class:
.Construction   EQU Page0.Object.Class.Construction
                endif ; ~_PAGE_0_OBJECT_

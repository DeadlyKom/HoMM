
                ifndef _PAGE_0_OBJECT_
                define _PAGE_0_OBJECT_
Object:
.Initialize             EQU Page0.Object.Initialize                             ; инициализация работы с объектами
.Spawn                  EQU Page0.Object.Spawn                                  ; спавн объекта
.PlacemantNew           EQU Page0.Object.PlacemantNewObj                        ; размещение нового объекта
.RemoveAtSwap           EQU Page0.Object.RemoveAtSwap                           ; удаление объекта, перемещая последний элемент в массиве
.SmartRemove            EQU Page0.Object.SmartRemove                            ; умное удаление объекта
.FindLastByPredicate    EQU Page0.Object.FindLastByPredicate                    ; поиск объекта с конца массива, используя предикат
Object.Class:
.UI             EQU Page0.Object.Class.UI
.Hero           EQU Page0.Object.Class.Hero
.Construction   EQU Page0.Object.Class.Construction
Object.Utils:
.GetAdrIY       EQU Page0.Object.Utils.Adr.IY                                   ; получить адрес объекта
                endif ; ~_PAGE_0_OBJECT_

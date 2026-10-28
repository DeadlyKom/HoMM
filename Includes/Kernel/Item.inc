
                ifndef _KERNEL_ITEM_
                define _KERNEL_ITEM_

Item:           ; функции работы с предметами
.Add            EQU Kernel.Item.Add                                             ; добавление подготовленного предмета
.PlacementNew   EQU Kernel.Item.PlacementNew                                    ; размещение нового предмета
.RemoveAtSwap   EQU Kernel.Item.RemoveAtSwap                                    ; удаление предмета с переносом последнего

Item.Utilities: ; вспомогательные функции работы с предметами
.GetAdr.HL      EQU Kernel.Item.Utilities.Address.HL                            ; получить адрес экземпляра предмета
.GetLocAdr.HL   EQU Kernel.Item.Utilities.Location.HL                           ; получить адрес размещения предмета

                endif ; ~_KERNEL_ITEM_

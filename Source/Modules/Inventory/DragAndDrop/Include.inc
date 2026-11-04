                ifndef _MODULE_INVENTORY_DRAG_AND_DROP_INCLUDE_
                define _MODULE_INVENTORY_DRAG_AND_DROP_INCLUDE_

                module DragAndDrop
                include "PutItem.asm"
                include "TakeItem.asm"
                include "Complete.asm"
                include "EquipItem.asm"
Cursor          EQU PutItem.Cursor                                              ; позиция запроса размещения в пикселях
                endmodule

                endif ; ~_MODULE_INVENTORY_DRAG_AND_DROP_INCLUDE_

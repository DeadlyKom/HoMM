
                ifndef _CONST_INVENTORY_DESCRIPTION_
                define _CONST_INVENTORY_DESCRIPTION_
; -----------------------------------------
; ограничения описания предмета
; -----------------------------------------
INVENTORY_DESCRIPTION_LINES_MAX     EQU 11                                      ; максимальное количество строк описания
INVENTORY_DESCRIPTION_LINE_SIZE     EQU 4                                       ; размер структуры FInventoryDescriptionLine
INVENTORY_DESCRIPTION_OPEN_QUOTE    EQU #C6                                     ; код открывающей кавычки
INVENTORY_DESCRIPTION_CLOSE_QUOTE   EQU #C7                                     ; код закрывающей кавычки

                ; -----------------------------------------
                ; цвета названия и типа предмета по качеству
                ZX_COLOR_IPBF_EQU INVENTORY_DESCRIPTION_NORMAL_COLOR, BLACK, WHITE, 1, 0
                ZX_COLOR_IPBF_EQU INVENTORY_DESCRIPTION_MAGIC_COLOR, BLACK, BLUE, 1, 0
                ZX_COLOR_IPBF_EQU INVENTORY_DESCRIPTION_RARE_COLOR, BLACK, YELLOW, 1, 0
                ZX_COLOR_IPBF_EQU INVENTORY_DESCRIPTION_UNIQUE_COLOR, BLACK, YELLOW, 0, 0
                ZX_COLOR_IPBF_EQU INVENTORY_DESCRIPTION_SET_COLOR, BLACK, GREEN, 1, 0

                ; цвет строк свойств предмета
                ZX_COLOR_IPBF_EQU INVENTORY_DESCRIPTION_PROPERTY_COLOR, BLACK, BLUE, 1, 0
                ; -----------------------------------------

                endif ; ~_CONST_INVENTORY_DESCRIPTION_

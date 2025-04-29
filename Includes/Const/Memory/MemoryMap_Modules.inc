
                ifndef _CONST_MEMORY_MAP_MODULES_
                define _CONST_MEMORY_MAP_MODULES_

                module Page
Core            EQU PAGE_5
Map             EQU PAGE_5
World           EQU PAGE_5
                endmodule

                module Adr
Core            EQU Adr.SharedPoint                                             ; адрес расположения кода "ядра"
Map             EQU Adr.SharedPoint                                             ; адрес расположения кода "работа с картой"
World           EQU Adr.SharedPoint                                             ; адрес расположения кода "мир"

                endmodule

                endif ; ~_CONST_MEMORY_MAP_MODULES_

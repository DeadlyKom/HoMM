
                ifndef _CONST_MEMORY_MAP_MODULES_
                define _CONST_MEMORY_MAP_MODULES_

                module Page
Core            EQU PAGE_5
World           EQU PAGE_5
                endmodule

                module Size
Core            EQU Core.Size                                                   ; размер кода "ядра"
World           EQU World.Size                                                  ; размер кода "мир"

                endmodule

                module Adr
Core            EQU Adr.SharedPoint                                             ; адрес расположения кода "ядра"
World           EQU Adr.SharedPoint                                             ; адрес расположения кода "мир"

                endmodule

                endif ; ~_CONST_MEMORY_MAP_MODULES_

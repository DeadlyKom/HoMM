
                ifndef _CONST_MEMORY_MAP_MODULES_
                define _CONST_MEMORY_MAP_MODULES_

                module Page
Core            EQU PAGE_5
MainMenu        EQU PAGE_5
Session         EQU PAGE_5
World           EQU PAGE_5
                endmodule

                module Adr
Core            EQU Adr.SharedPoint                                             ; адрес расположения кода "ядра"
MainMenu        EQU Adr.SharedPoint                                             ; адрес расположения кода "гвного меню"
Session         EQU Adr.SharedPoint                                             ; адрес расположения кода "сессии"
World           EQU Adr.SharedPoint                                             ; адрес расположения кода "мир"

                endmodule

                endif ; ~_CONST_MEMORY_MAP_MODULES_

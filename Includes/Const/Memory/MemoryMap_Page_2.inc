
                ifndef _CONST_MEMORY_MAP_PAGE_2_
                define _CONST_MEMORY_MAP_PAGE_2_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                                          | #0000 |
                ;   +-------+------------------------------------------+-------+

                module Page
Kernel          EQU PAGE_2                                                      ; модуль "кернель"
KernelMinimal   EQU PAGE_2                                                      ; модуль "кернель" (минимальный)
                endmodule

                module Size
Int.Table       EQU #0101                                                       ; размер таблицы прерываний
Int.Stack       EQU #0080                                                       ; размер стека прерывания
                endmodule

                module Adr
Interrupt       EQU #8181                                                       ; адрес вектора прерывания
Kernel          EQU Adr.Interrupt                                               ; адрес блока кернела (основной)
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_2_

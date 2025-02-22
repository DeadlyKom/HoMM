
                ifndef _CONST_MEMORY_MAP_PAGE_2_
                define _CONST_MEMORY_MAP_PAGE_2_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                                          | #0000 |
                ;   +-------+------------------------------------------+-------+

                ;   +-------+------------------------------------------+-------+
                ;   | #BC00 |                              ExtraBuffer | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #BD00 |                               SortBuffer | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #BE00 |                             SharedBuffer | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #BF00 |                             RenderBuffer | #0100 |
                ;   +-------+------------------------------------------+-------+

                module Page
Kernel          EQU PAGE_2                                                      ; модуль "кернель"
KernelMinimal   EQU PAGE_2                                                      ; модуль "кернель" (минимальный)
                endmodule

                module Size
Int.Table       EQU #0101                                                       ; размер таблицы прерываний
Int.Stack       EQU #0080                                                       ; размер стека прерывания
KernelMinimal   EQU Bootloader.KernelMinimal.Size                               ; размер блока кернела (минимальный)
                endmodule

                module Adr
Interrupt       EQU #8181                                                       ; адрес вектора прерывания
KernelMinimal   EQU Adr.Interrupt                                               ; адрес блока кернела (минимальный)
Kernel          EQU KernelMinimal + Size.KernelMinimal                          ; адрес блока кернела (основной)
ExtraBuffer     EQU #BC00                                                       ; адрес дополнительного буфера
SortBuffer      EQU #BD00                                                       ; адрес буфера сортировки
SharedBuffer    EQU #BE00                                                       ; адрес буфера общего назначения
RenderBuffer    EQU #BF00                                                       ; адрес буфера отображения
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_2_

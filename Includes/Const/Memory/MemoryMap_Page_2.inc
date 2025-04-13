
                ifndef _CONST_MEMORY_MAP_PAGE_2_
                define _CONST_MEMORY_MAP_PAGE_2_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                                          | #0000 |
                ;   +-------+------------------------------------------+-------+

                ;   +-------+------------------------------------------+-------+
                ;   | #B700 |                              ExtraBuffer | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #B800 |                               SortBuffer | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #B900 |                             SharedBuffer | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #BA00 |                             RenderBuffer | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #BB00 |                            TilemapBuffer | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #BC00 |                         SpriteInfoBuffer | #0400 |
                ;   +-------+------------------------------------------+-------+

                module Page
Kernel          EQU PAGE_2                                                      ; модуль "кернель"
KernelMinimal   EQU PAGE_2                                                      ; модуль "кернель" (минимальный)
                endmodule

                module Size
Int.Table       EQU #0101                                                       ; размер таблицы прерываний
Int.Stack       EQU #0080                                                       ; размер стека прерывания
KernelMinimal   EQU Bootloader.KernelMinimal.Size                               ; размер блока кернела (минимальный)
SpriteInfoBuffer EQU SPRITE_SIZE * SPRITE_BUF_MAX                               ; размер буфера информации о спрайтах
ExtraBuffer     EQU #0100                                                       ; размер дополнительного буфера
SortBuffer      EQU #0100                                                       ; размер буфера отсортированных объектов
SharedBuffer    EQU #0100                                                       ; размер буфера общего назначения
RenderBuffer    EQU #0100                                                       ; размер буфера отображения
TilemapBuffer   EQU #0100                                                       ; размер буфера тайлов отображения (пока зарезервирован)

                endmodule

                module Adr
Interrupt       EQU #8181                                                       ; адрес вектора прерывания
KernelMinimal   EQU Adr.Interrupt                                               ; адрес блока кернела (минимальный)
Kernel          EQU KernelMinimal + Size.KernelMinimal                          ; адрес блока кернела (основной)
ExtraBuffer     EQU #B700                                                       ; адрес дополнительного буфера
SortBuffer      EQU #B800                                                       ; адрес буфера сортировки
SharedBuffer    EQU #B900                                                       ; адрес буфера общего назначения
RenderBuffer    EQU #BA00                                                       ; адрес буфера отображения
TilemapBuffer   EQU #BB00                                                       ; адрес буфера тайловов отображения (пока зарезервирован)
SpriteInfoBuffer EQU #BC00                                                      ; адрес буфера информации о спрайтах
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_2_

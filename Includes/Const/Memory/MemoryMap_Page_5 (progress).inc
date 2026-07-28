
                ifndef _CONST_MEMORY_MAP_PAGE_5_PROGRESS_
                define _CONST_MEMORY_MAP_PAGE_5_PROGRESS_
                
                ;   +-------+------------------------------------------+-------+
                ;   | #4000 |                               TickBuffer | #0300 |
                ;   +-------+------------------------------------------+-------+
                ;   | #4300 |                                 свободно | #0200 |
                ;   +-------+------------------------------------------+-------+

                module Page
                endmodule

                module Size
TickBuffer      EQU #0300                                                       ; размер буфера копирвоания спрайта "дерево мира"
ProgressBuffer  EQU #0400                                                       ; размер буфера копирвоания спрайтов "прогресс"
                endmodule

                module Adr
TickBuffer      EQU #4000                                                       ; адрес буфера копирвоания спрайта "дерево мира"
ProgressBuffer  EQU Adr.ExtraBuffer                                             ; адрес буфера копирвоания спрайтов "прогресс"
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_5_PROGRESS_

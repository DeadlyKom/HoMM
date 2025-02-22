
                ifndef _CONST_MEMORY_MAP_PAGE_5_
                define _CONST_MEMORY_MAP_PAGE_5_

                ;   +-------+------------------------------------------+-------+
                ;   | #4000 |                                   Screen | #1B00 |
                ;   +-------+------------------------------------------+-------+
                ;   | #5B00 |                 Basic & TR-DOS variables | #033C |
                ;   +-------+------------------------------------------+-------+
                ;   | #5E3C |                                    Stack | #00C4 |
                ;   +-------+------------------------------------------+-------+
                ;   | #60C0 |                                GameState | #0040 |
                ;   +-------+------------------------------------------+-------+
                ;   | #73C0 |                               EntryPoint | #0040 |
                ;   +-------+------------------------------------------+-------+
                ;   | #7400 |                              SharedPoint | #0C00 |
                ;   +-------+------------------------------------------+-------+

                module Size
Stack           EQU #00C4                                                       ; размер стека
GameState       EQU #0040                                                       ; размер переменных состояния игры
EntryPoint      EQU #0040                                                       ; размер точки входа
SharedPoint     EQU #0C00                                                      ; размер общей точки входа (место переноса кода из страниц)
                endmodule

                module Adr
StackTop        EQU #5E3C + Size.Stack                                          ; расположение стека
GameState       EQU #60C0                                                       ; адрес переменных состояние игры
EntryPoint      EQU #73C0                                                       ; адрес точки входа
SharedPoint     EQU Adr.EntryPoint + Size.EntryPoint                            ; адрес точки входа
Port_7FFD       EQU PORT_7FFD                                                   ; адрес хранения номера странички
Booloader
.StackTop       EQU MemBank_03-2                                                ; расположение стека (загрузчика)
                endmodule


                endif ; ~_CONST_MEMORY_MAP_PAGE_5_

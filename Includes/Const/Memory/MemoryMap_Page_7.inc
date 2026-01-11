
                ifndef _CONST_MEMORY_MAP_PAGE_7_
                define _CONST_MEMORY_MAP_PAGE_7_
                
                ;   +-------+------------------------------------------+-------+
                ;   | #С000 |                            Shadow Screen | #1B00 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DB00 |                            ScreenRefresh | #0500 | ; код обновления теневого экрана
                ;   +-------+------------------------------------------+-------+
                ;   | #E000 |                          BitScanLsbTable | #0100 | ; таблица для поиска первого установленного бита
                ;   +-------+------------------------------------------+-------+
                ;   | #E100 |                  BaseСursorStorageBuffer | #0100 | ; буфер сохранения фона под курсором основного экрана
                ;   +-------+------------------------------------------+-------+
                ;   | #E200 |                ShadowСursorStorageBuffer | #0100 | ; буфер сохранения фона под курсором теневого экрана
                ;   +-------+------------------------------------------+-------+
                ;   | #E100 |                                 свободно | #0000 |
                ;   +-------+------------------------------------------+-------+

                module Page
ScreenRefresh   EQU PAGE_7
BitScanLsbTable EQU PAGE_7
                endmodule

                module Size

ScreenRefresh   EQU #0500                                                       ; размер обновления теневого экрана (примерный)
BitScanLsbTable EQU #0100                                                       ; размер таблицы для поиска первого установленного бита
TempBuffer      EQU #0100                                                       ; размер буфер для распаковки   (новое имя BaseСursorStorageBuffer/ShadowСursorStorageBuffer)
                endmodule

                module Adr
ScreenRefresh   EQU #DB00                                                       ; код обновления теневого экрана
BitScanLsbTable EQU #0100                                                       ; адрес таблицы для поиска первого установленного бита
TempBuffer      EQU #E000                                                       ; буфер для распаковки          (новое имя BaseСursorStorageBuffer/ShadowСursorStorageBuffer)
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_7_

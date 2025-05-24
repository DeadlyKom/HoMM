
                ifndef _CONST_MEMORY_MAP_PAGE_3_
                define _CONST_MEMORY_MAP_PAGE_3_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                              AssetsTable | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #С100 |                             AvailableMem | #0040 |
                ;   +-------+------------------------------------------+-------+
                ;   | #С140 |                              stash TRDOS | #0400 |
                ;   +-------+------------------------------------------+-------+
                ;   | #С540 |                                     Path | #00C0 |
                ;   +-------+------------------------------------------+-------+
                ;   | #С600 |                                    AStar | #1800 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DE00 |                              SearchField | #0800 |
                ;   +-------+------------------------------------------+-------+
                ;   | #E600 |                                 свободно | #1A00 |
                ;   +-------+------------------------------------------+-------+

                module Page
AssetManager    EQU PAGE_3
                endmodule

                module Size
AssetsTable     EQU FAssets * ASSETS_MAX                                        ; размер таблицы ресурсов
AvailableMem    EQU MAX_PAGE * (BankSize >> 11)                                 ; размер битового массива доступного ОЗУ
Stash_TRDOS     EQU Bootloader.TRDOS.Size                                       ; размер драйвера TR-DOS (не более 1024кб)
FoundPath       EQU #00C0                                                       ; размер массива найденого пути в виде последовательности координат тайлов (FPath),
                                                                                ; где нулевой элемент является последним
AStar           EQU #1800                                                       ; размер буфера А* (FAStar * ASTAR_CELL_MAX)
SearchField     EQU #0800                                                       ; размер поля поиска А*
                endmodule

                module Adr
AssetsTable     EQU #C000                                                       ; адрес таблицы ресурсов
AvailableMem    EQU AssetsTable + Size.AssetsTable                              ; адрес битового массива доступного ОЗУ
Stash_TRDOS     EQU AvailableMem + Size.AvailableMem                            ; адрес расположения драйвера TR-DOS
FoundPath       EQU #C540                                                       ; адрес массива найденого пути в виде последовательности координат тайлов (FPath),
                                                                                ; где нулевой элемент является последним
AStar           EQU #C600                                                       ; адрес буфера А*
SearchField     EQU #DE00                                                       ; адрес поля поиска А*

                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_3_

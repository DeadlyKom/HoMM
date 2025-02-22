
                ifndef _CONST_MEMORY_MAP_PAGE_3_
                define _CONST_MEMORY_MAP_PAGE_3_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                              AssetsTable | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #С100 |                             AvailableMem | #0040 |
                ;   +-------+------------------------------------------+-------+
                ;   | #С140 |                              stash TRDOS | ..... |
                ;   +-------+------------------------------------------+-------+

                module Page
AssetManager    EQU PAGE_3
                endmodule

                module Size
AssetsTable     EQU FAssets * ASSETS_MAX                                        ; размер таблицы ресурсов
AvailableMem    EQU MAX_PAGE * (BankSize >> 11)                                 ; размер битового массива доступного ОЗУ
Stash_TRDOS     EQU Bootloader.TRDOS.Size                                       ; размер драйвера TR-DOS
                endmodule

                module Adr
AssetsTable     EQU #C000                                                       ; адрес таблицы ресурсов
AvailableMem    EQU AssetsTable + Size.AssetsTable                              ; адрес битового массива доступного ОЗУ
Stash_TRDOS     EQU AvailableMem + Size.AvailableMem                            ; адрес расположения драйвера TR-DOS

                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_3_

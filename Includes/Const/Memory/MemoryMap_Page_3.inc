
                ifndef _CONST_MEMORY_MAP_PAGE_3_
                define _CONST_MEMORY_MAP_PAGE_3_

                ;   +-------+------------------------------------------+-------+
                ;   | #C000 |                              AssetsTable | #0100 |
                ;   +-------+------------------------------------------+-------+
                ;   | #С100 |                             AvailableMem | #0040 |
                ;   +-------+------------------------------------------+-------+
                ;   | #С140 |                              stash TRDOS | #0400 |
                ;   +-------+------------------------------------------+-------+
                ;   | #С540 |                                 свободно | #2AC0 |
                ;   +-------+------------------------------------------+-------+
                ;   | #F000 |                                     Code | #0A00 | ; блок кода
                ;   +-------+------------------------------------------+-------+
                ;   | #FA00 |                                 свободно | #0100 | ; при загрузке будет мусор
                ;   +-------+------------------------------------------+-------+
                ;   | #FB00 |                                 свободно | #0600 |
                ;   +-------+------------------------------------------+-------+

                module Page
AssetManager    EQU PAGE_3
Page3           EQU PAGE_3
                endmodule

                module Size
AssetsTable     EQU FAssets * ASSETS_MAX                                        ; размер таблицы ресурсов
AvailableMem    EQU MAX_PAGE * (BankSize >> 11)                                 ; размер битового массива доступного ОЗУ
Stash_TRDOS     EQU Bootloader.TRDOS.Size                                       ; размер драйвера TR-DOS (не более 1024кб)
Code.Page3      EQU #0A00                                                       ; размер блока кода
                endmodule

                module Adr
AssetsTable     EQU #C000                                                       ; адрес таблицы ресурсов
AvailableMem    EQU AssetsTable + Size.AssetsTable                              ; адрес битового массива доступного ОЗУ
Stash_TRDOS     EQU AvailableMem + Size.AvailableMem                            ; адрес расположения драйвера TR-DOS
Code.Page3      EQU #F000                                                       ; адрес блока кода
                                                                                ; (помещён в центр, при распоковке затрутся ObjectDefaultSettings)
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_3_


                ifndef _MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_TABLE_
                define _MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_TABLE_
; -----------------------------------------
; обработка блока HextileTable
; In:
;   DE - указывает на адрес блока данных
;   BC - длина блока
; Out:
; Corrupt:
; Note:
; -----------------------------------------
HextileTable:   EX DE, HL                                                       ; меняем местами
                EXX                                                             ; прячем данные
                ; HL' - адрес блока данных таблицы сопоставления гексагонального тайла и графического пакета
                ; BC' - размер блока данных таблицы сопоставления гексагонального тайла и графического пакета
                RET

                display " - Parsing FMapDataBlockInfo for Hextile table:\t", /A, HextileTable, "\t= busy [ ", /D, $-HextileTable, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_HEXTILE_TABLE_

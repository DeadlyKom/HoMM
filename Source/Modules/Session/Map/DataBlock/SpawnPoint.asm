
                ifndef _MODULE_SESSION_MAP_DATA_BLOCK_SPAWN_POINT_
                define _MODULE_SESSION_MAP_DATA_BLOCK_SPAWN_POINT_
; -----------------------------------------
; обработка блока - список "точек спавна"
; In:
;   DE - указывает на адрес блока данных
;   BC - длина блока
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SpawnPoint:     ; ToDo: добавить проверку и добавления в список "точки спавна"
                RET

                display " - Parsing FMapDataBlockInfo for 'spawn point':\t", /A, SpawnPoint, "\t= busy [ ", /D, $-SpawnPoint, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_MAP_DATA_BLOCK_SPAWN_POINT_

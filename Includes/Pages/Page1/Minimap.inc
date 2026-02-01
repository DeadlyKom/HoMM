
                ifndef _PAGE_1_MINIMAP_
                define _PAGE_1_MINIMAP_
Minimap:
.GenFog         EQU Page1.Minimap.GenerateFog                                   ; генерация тумана для миникарты
.GenMap         EQU Page1.Minimap.GenerateMap                                   ; генерация карты для миникарты
.Compilation    EQU Page1.Minimap.Compilation                                   ; компиляция миникарты
.Memcpy         EQU Page1.Minimap.Memcpy                                        ; копирование миникарты
                endif ; ~_PAGE_1_MINIMAP_

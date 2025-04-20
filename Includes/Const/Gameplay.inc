
                ifndef _CONST_GAMEPLAY_
                define _CONST_GAMEPLAY_
DURATION
.TILE_TICK      EQU 0x09                                                        ; период обновления счётчика тайлов                     (1/50)
.OBJECT_TICK    EQU 0x08                                                        ; период обновления счётчика тиков объектов             (1/50)
.IDLE_CURSOR    EQU 0xFA                                                        ; продолжительность простоя курсора                     (1/50)
.TILEMAP_SCROLL EQU 0x02                                                        ; продолжительность простоя при скролле тайловой карты  (1/50)

                endif ; ~_CONST_GAMEPLAY_

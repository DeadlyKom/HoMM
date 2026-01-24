
                ifndef _CONST_GAMEPLAY_
                define _CONST_GAMEPLAY_
DURATION
.MAP_SCROLL     EQU 0x02                                                        ; продолжительность простоя при скролле тайловой карты  (1/50)
.TILE_TICK      EQU 0x09                                                        ; период обновления счётчика тайлов                     (1/50)
.HERO_TICK      EQU 0x03                                                        ; период обновления анимации героя                      (1/50)
.OBJECT_TICK    EQU 0x08                                                        ; период обновления счётчика тиков объектов             (1/50)
.IDLE_CURSOR    EQU 0xFA                                                        ; продолжительность простоя курсора                     (1/50)
.CLICK_CURSOR   EQU 0x01                                                        ; продолжительность нажатия курсора                     (1/50)
.DELAY_CURSOR   EQU 0x0A                                                        ; продолжительность между анимациями курсора            (1/50)

                endif ; ~_CONST_GAMEPLAY_

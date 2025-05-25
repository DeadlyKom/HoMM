
                ifndef _PAGE_0_PATH_
                define _PAGE_0_PATH_
DirectonPath    EQU Page0.Hero.Path.Directon                                    ; определение направления
MemcpyHeroPath  EQU Page0.Hero.Path.MemcpyHeroPath                              ; копирование пути в буфер Adr.HeroPath
SetHeroPath     EQU Page0.Hero.Path.SetHeroPath                                 ; установить длины пути героя
ReificationPath EQU Page0.Hero.Path.ReificationPath                             ; овеществление путь героя

                endif ; ~_PAGE_0_PATH_

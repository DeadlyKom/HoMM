
                ifndef _PAGE_0_HERO_
                define _PAGE_0_HERO_
Hero:
.DirectonPath   EQU Page0.Hero.Path.Directon                                    ; определение направления движения
.MemcpyPath     EQU Page0.Hero.Path.MemcpyHeroPath                              ; копирование пути в буфер Adr.HeroPath
.ReificationPath EQU Page0.Hero.Path.ReificationPath                            ; овеществление путь героя

Hero.Utilities:
.GetHeroAdr.IX  EQU Page0.Hero.Utilities.Hero.Address.IX                        ; получить адрес героя
.GetHeroAdres   EQU Page0.Hero.Utilities.Hero.Addresses                         ; получить адреса героя
                endif ; ~_PAGE_0_HERO_

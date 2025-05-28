
                ifndef _PAGE_0_HERO_
                define _PAGE_0_HERO_
Hero:
.DirectonPath   EQU Page0.Hero.Path.Directon                                    ; определение направления движения
.MemcpyPath     EQU Page0.Hero.Path.MemcpyHeroPath                              ; копирование пути в буфер Adr.HeroPath
.GetPath        EQU Page0.Hero.Path.GetHeroPath                                 ; получить длину пути героя
.SetPath        EQU Page0.Hero.Path.SetHeroPath                                 ; установить длины пути героя
.ReificationPath EQU Page0.Hero.Path.ReificationPath                            ; овеществление путь героя

Hero.Utils:
.GetAdrIX       EQU Page0.Hero.Utils.Adr.IX                                     ; получить адрес героя
                endif ; ~_PAGE_0_HERO_

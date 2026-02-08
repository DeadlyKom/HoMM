
                ifndef _PAGE_0_HERO_
                define _PAGE_0_HERO_
Hero:
.DirectonPath           EQU Page0.Hero.Path.Directon                            ; определение направления движения
.PathInitialize         EQU Page0.Hero.Path.PathInitialize                      ; инициализация пути
.PathInitialize.Wrap    EQU Page0.Hero.Path.PathInitialize.Wrap                 ; инициализация пути                                            (обёртка)
; .ReificationPath        EQU Page0.Hero.Path.ReificationPath                     ; овеществление путь героя                                      DEPRECATE
Hero.Utilities:
.GetHeroAdr.IX          EQU Page0.Hero.Utilities.Hero.Address.IX                ; получить адрес героя
.GetHeroAdr             EQU Page0.Hero.Utilities.Hero.Addresses                 ; получить адреса героя
.MemcpyObject           EQU Page0.Hero.Utilities.MemcpyHeroObject               ; копировать объект "герой"
                endif ; ~_PAGE_0_HERO_


                ifndef _PAGE_0_CHARACTER_
                define _PAGE_0_CHARACTER_
Character:
.DirectonPath           EQU Page0.Character.Path.Directon                       ; определение направления движения
.DistancePath           EQU Page0.Character.Path.Distance                       ; определение расстояние пути
.PathInitialize         EQU Page0.Character.Path.PathInitialize                 ; инициализация пути
.PathInitialize.Wrap    EQU Page0.Character.Path.PathInitialize.Wrap            ; инициализация пути                                            (обёртка)
; .ReificationPath        EQU Page0.Character.Path.ReificationPath                ; овеществление путь персонажа                                      DEPRECATE
Character.Utilities:
.GetAdr.IX              EQU Page0.Character.Utilities.Character.Address.IX      ; получить адрес персонажа
.GetAdr                 EQU Page0.Character.Utilities.Character.Addresses       ; получить адреса персонажа
.MemcpyObject           EQU Page0.Character.Utilities.Character.MemcpyObject    ; копировать объект "персонаж"
                endif ; ~_PAGE_0_CHARACTER_

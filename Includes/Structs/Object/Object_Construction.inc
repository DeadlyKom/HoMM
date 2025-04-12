
                ifndef _STRUCT_OBJECT_CONSTRUCTION_
                define _STRUCT_OBJECT_CONSTRUCTION_

                struct FObjectConstruction                                      ; объект - постройка                                        [байт]
Super           FObject                                                         ; базовый класс объекта                                     [9 байт]
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | A2 | A1 | A0 | .. | .. | .. |
;   +----+----+----+----+----+----+----+----+
;
;   A2-A0   [5..3]  - номер проигрываемой анимации
; -----------------------------------------
SpriteInfo      DB #00                                                          ; информация о спрайте                                      [1 байт]

                ends

                endif ; ~_STRUCT_OBJECT_CONSTRUCTION_

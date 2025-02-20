
                ifndef _STRUCT_ADDRESS_
                define _STRUCT_ADDRESS_

                struct FAddress
Low             DB #00
High            DB #00
                ends

                struct FLinearAddress
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | MU | AL | .. | P4 | P3 | P2 | P1 | P0 |
;   +----+----+----+----+----+----+----+----+
;
;   MU      [7]         - флаг, помечен как невостребованный
;   AL      [6]         - флаг, требуется аллокация ресурса
;   P4-P0   [4..0]      - страница
; -----------------------------------------
Page            DB #00                                                          ; номер страницы
Adr             FAddress                                                        ; адрес
                ends

                endif ; ~_STRUCT_ADDRESS_

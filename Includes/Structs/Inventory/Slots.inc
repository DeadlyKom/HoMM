
                ifndef _STRUCTS_INVENTORY_SLOTS_STATES_
                define _STRUCTS_INVENTORY_SLOTS_STATES_

                struct FInventorySlotStates                                     ; состояние ячейки инвентаря                                    [8 байт]
; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | SA |
;   +----+----+----+----+----+----+----+----+
;
;   SA      [0]     - флаг, активности слота
; -----------------------------------------
Flags           DB #00                                                          ; флаги
Animation       DB #00
                ends

                endif ; ~_STRUCTS_INVENTORY_SLOTS_STATES_

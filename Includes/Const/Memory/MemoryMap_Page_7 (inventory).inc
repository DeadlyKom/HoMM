
                ifndef _CONST_MEMORY_MAP_PAGE_7_INVENTORY_
                define _CONST_MEMORY_MAP_PAGE_7_INVENTORY_
                
                ;   +-------+------------------------------------------+-------+
                ;   | #С000 |                             ShadowScreen | #1B00 |
                ;   +-------+------------------------------------------+-------+
                ;   | #DB00 |                           CursorStorageA | #0100 | ; буфер сохранения фона под курсором
                ;   +-------+------------------------------------------+-------+
                ;   | #DC00 |                           СursorStorageB | #0100 | ; буфер сохранения фона под курсором (дополнительный см PipelineHexagons.MemcpyScreen)
                ;   +-------+------------------------------------------+-------+
                ;   | #DD00 |                             BuffersSlots | #05F0 | ; буферы слотов инвентаря
                ;   +-------+------------------------------------------+-------+
                ;   | #E2F0 |                                 свободно | #0D10 | ; свободно
                ;   +-------+------------------------------------------+-------+
                ;   | #F000 |                             SharedScreen | #1000 | ; общая память для кода
                ;   +-------+------------------------------------------+-------+

                module Page
                endmodule

                module Size
                module BuffersSlots

                ; размеры буферов слота - голова
                module Head
Attributes      EQU SlotBuffers.Head.Attributes                                 ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.Head.Background                                 ; размер буфера пикселей и атрибутов фона
                endmodule

                ; размеры буферов слота - грудь
                module Breast
Attributes      EQU SlotBuffers.Breast.Attributes                               ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.Breast.Background                               ; размер буфера пикселей и атрибутов фона
                endmodule

                ; размеры буферов слота - амулет
                module Amulet
Attributes      EQU SlotBuffers.Amulet.Attributes                               ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.Amulet.Background                               ; размер буфера пикселей и атрибутов фона
                endmodule

                ; размеры буферов слота - наплечник/плащ
                module ShoulderPad
Attributes      EQU SlotBuffers.ShoulderPad.Attributes                          ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.ShoulderPad.Background                          ; размер буфера пикселей и атрибутов фона
                endmodule

                ; размеры буферов слота - пояс
                module Belt
Attributes      EQU SlotBuffers.Belt.Attributes                                 ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.Belt.Background                                 ; размер буфера пикселей и атрибутов фона
                endmodule

                ; размеры буферов слота - левая рука
                module LeftHand
Attributes      EQU SlotBuffers.LeftHand.Attributes                             ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.LeftHand.Background                             ; размер буфера пикселей и атрибутов фона
                endmodule

                ; размеры буферов слота - правая рука
                module RightHand
Attributes      EQU SlotBuffers.RightHand.Attributes                            ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.RightHand.Background                            ; размер буфера пикселей и атрибутов фона
                endmodule

                ; размеры буферов слота - кольцо левой руки
                module LeftRing
Attributes      EQU SlotBuffers.LeftRing.Attributes                             ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.LeftRing.Background                             ; размер буфера пикселей и атрибутов фона
                endmodule

                ; размеры буферов слота - кольцо правой руки
                module RightRing
Attributes      EQU SlotBuffers.RightRing.Attributes                            ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.RightRing.Background                            ; размер буфера пикселей и атрибутов фона
                endmodule

                ; размеры буферов слота - обувь
                module Boot
Attributes      EQU SlotBuffers.Boot.Attributes                                 ; размер буфера конечных атрибутов
Background      EQU SlotBuffers.Boot.Background                                 ; размер буфера пикселей и атрибутов фона
                endmodule
                endmodule
                endmodule

                module Adr
                module BuffersSlots
                ; адреса начала выделенных буферов в странице 7

                module Head                                                     ; голова
Attributes      EQU #DD00                                                       ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.Head.Attributes \
                    + Size.BuffersSlots.Head.Attributes                         ; адрес буфера пикселей и атрибутов фона
                endmodule

                module Breast                                                   ; грудь
Attributes      EQU Adr.BuffersSlots.Head.Background \
                    + Size.BuffersSlots.Head.Background                         ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.Breast.Attributes \
                    + Size.BuffersSlots.Breast.Attributes                       ; адрес буфера пикселей и атрибутов фона
                endmodule

                module Amulet                                                   ; амулет
Attributes      EQU Adr.BuffersSlots.Breast.Background \
                    + Size.BuffersSlots.Breast.Background                       ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.Amulet.Attributes \
                    + Size.BuffersSlots.Amulet.Attributes                       ; адрес буфера пикселей и атрибутов фона
                endmodule

                module ShoulderPad                                              ; наплечник/плащ
Attributes      EQU Adr.BuffersSlots.Amulet.Background \
                    + Size.BuffersSlots.Amulet.Background                       ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.ShoulderPad.Attributes \
                    + Size.BuffersSlots.ShoulderPad.Attributes                  ; адрес буфера пикселей и атрибутов фона
                endmodule

                module Belt                                                     ; пояс
Attributes      EQU Adr.BuffersSlots.ShoulderPad.Background \
                    + Size.BuffersSlots.ShoulderPad.Background                  ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.Belt.Attributes \
                    + Size.BuffersSlots.Belt.Attributes                         ; адрес буфера пикселей и атрибутов фона
                endmodule

                module LeftHand                                                 ; левая рука
Attributes      EQU Adr.BuffersSlots.Belt.Background \
                    + Size.BuffersSlots.Belt.Background                         ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.LeftHand.Attributes \
                    + Size.BuffersSlots.LeftHand.Attributes                     ; адрес буфера пикселей и атрибутов фона
                endmodule

                module RightHand                                                ; правая рука
Attributes      EQU Adr.BuffersSlots.LeftHand.Background \
                    + Size.BuffersSlots.LeftHand.Background                     ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.RightHand.Attributes \
                    + Size.BuffersSlots.RightHand.Attributes                    ; адрес буфера пикселей и атрибутов фона
                endmodule

                module LeftRing                                                 ; кольцо левой руки
Attributes      EQU Adr.BuffersSlots.RightHand.Background \
                    + Size.BuffersSlots.RightHand.Background                    ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.LeftRing.Attributes \
                    + Size.BuffersSlots.LeftRing.Attributes                     ; адрес буфера пикселей и атрибутов фона
                endmodule

                module RightRing                                                ; кольцо правой руки
Attributes      EQU Adr.BuffersSlots.LeftRing.Background \
                    + Size.BuffersSlots.LeftRing.Background                     ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.RightRing.Attributes \
                    + Size.BuffersSlots.RightRing.Attributes                    ; адрес буфера пикселей и атрибутов фона
                endmodule

                module Boot                                                     ; обувь
Attributes      EQU Adr.BuffersSlots.RightRing.Background \
                    + Size.BuffersSlots.RightRing.Background                    ; адрес буфера конечных атрибутов
Background      EQU Adr.BuffersSlots.Boot.Attributes \
                    + Size.BuffersSlots.Boot.Attributes                         ; адрес буфера пикселей и атрибутов фона
                endmodule

                endmodule
                endmodule

                endif ; ~_CONST_MEMORY_MAP_PAGE_7_INVENTORY_

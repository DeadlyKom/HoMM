
                ifndef _CONST_INVENTORY_SLOT_BUFFERS_
                define _CONST_INVENTORY_SLOT_BUFFERS_

                module SlotBuffers
ServiceSize     EQU #06                                                         ; размер служебных данных буфера
CellSize        EQU #09                                                         ; размер пикселей и атрибута одного знакоместа

                module Head                                                     ; голова
Width           EQU SCR_EQUIP_HEAD_SIZE_X                                       ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_HEAD_SIZE_Y                                       ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule

                module Breast                                                   ; грудь
Width           EQU SCR_EQUIP_BREAST_SIZE_X                                     ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_BREAST_SIZE_Y                                     ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule

                module Amulet                                                   ; амулет
Width           EQU SCR_EQUIP_AMULET_SIZE_X                                     ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_AMULET_SIZE_Y                                     ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule

                module ShoulderPad                                              ; наплечник/плащ
Width           EQU SCR_EQUIP_SHOULDER_PAD_SIZE_X                               ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_SHOULDER_PAD_SIZE_Y                               ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule

                module Belt                                                     ; пояс
Width           EQU SCR_EQUIP_BELT_SIZE_X                                       ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_BELT_SIZE_Y                                       ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule

                module LeftHand                                                 ; левая рука
Width           EQU SCR_EQUIP_LEFT_HAND_SIZE_X                                  ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_LEFT_HAND_SIZE_Y                                  ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule

                module RightHand                                                ; правая рука
Width           EQU SCR_EQUIP_RIGHT_HAND_SIZE_X                                 ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_RIGHT_HAND_SIZE_Y                                 ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule

                module LeftRing                                                 ; кольцо левой руки
Width           EQU SCR_EQUIP_LEFT_RING_SIZE_X                                  ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_LEFT_RING_SIZE_Y                                  ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule

                module RightRing                                                ; кольцо правой руки
Width           EQU SCR_EQUIP_RIGHT_RING_SIZE_X                                 ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_RIGHT_RING_SIZE_Y                                 ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule

                module Boot                                                     ; обувь
Width           EQU SCR_EQUIP_BOOT_SIZE_X                                       ; расчёт ширины сохраняемой области слота
Height          EQU SCR_EQUIP_BOOT_SIZE_Y                                       ; расчёт высоты сохраняемой области слота
Attributes      EQU Width * Height + SlotBuffers.ServiceSize                    ; расчёт размера буфера конечных атрибутов
Background      EQU Width * Height * SlotBuffers.CellSize \
                     + SlotBuffers.ServiceSize                                  ; расчёт размера буфера пикселей и атрибутов фона
                endmodule
                endmodule

                endif ; ~_CONST_INVENTORY_SLOT_BUFFERS_

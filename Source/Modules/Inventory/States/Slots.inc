
                ifndef _MODULE_INVENTORY_STATES_SLOTS_
                define _MODULE_INVENTORY_STATES_SLOTS_

                module Slots

; -----------------------------------------
; создание состояния слота с адресами буферов и параметрами отображения
; -----------------------------------------
MAKE_SLOT       macro AttributesAdr?, AttributesSize?, BackgroundAdr?, BackgroundSize?, Location?, Size?, SpriteAdr?
                FInventorySlotStates {
                    #00,
                    #00,
                    #00,
                    AttributesAdr? + AttributesSize? - 4,
                    BackgroundAdr? + BackgroundSize? - 4,
                    Location?,
                    Size?,
                    SpriteAdr?
                }
                endm

Head            ; состояние слота - голова
                MAKE_SLOT \
                Adr.BuffersSlots.Head.Attributes, Size.BuffersSlots.Head.Attributes, \
                Adr.BuffersSlots.Head.Background, Size.BuffersSlots.Head.Background, \
                (SCR_EQUIP_HEAD_POS_Y << 8) | SCR_EQUIP_HEAD_POS_X, \
                (SlotBuffers.Head.Height << 8) | SlotBuffers.Head.Width, \
                Inventory.Display.Slots.Slot_2x2
Breast          ; состояние слота - грудь
                MAKE_SLOT \
                Adr.BuffersSlots.Breast.Attributes, Size.BuffersSlots.Breast.Attributes, \
                Adr.BuffersSlots.Breast.Background, Size.BuffersSlots.Breast.Background, \
                (SCR_EQUIP_BREAST_POS_Y << 8) | SCR_EQUIP_BREAST_POS_X, \
                (SlotBuffers.Breast.Height << 8) | SlotBuffers.Breast.Width, \
                Inventory.Display.Slots.Slot_2x3

Amulet          ; состояние слота - амулет
                MAKE_SLOT \
                Adr.BuffersSlots.Amulet.Attributes, Size.BuffersSlots.Amulet.Attributes, \
                Adr.BuffersSlots.Amulet.Background, Size.BuffersSlots.Amulet.Background, \
                (SCR_EQUIP_AMULET_POS_Y << 8) | SCR_EQUIP_AMULET_POS_X, \
                (SlotBuffers.Amulet.Height << 8) | SlotBuffers.Amulet.Width, \
                Inventory.Display.Slots.Slot_1x1

ShoulderPad     ; состояние слота - наплечник/плащ
                MAKE_SLOT \
                Adr.BuffersSlots.ShoulderPad.Attributes, Size.BuffersSlots.ShoulderPad.Attributes, \
                Adr.BuffersSlots.ShoulderPad.Background, Size.BuffersSlots.ShoulderPad.Background, \
                (SCR_EQUIP_SHOULDER_PAD_POS_Y << 8) | SCR_EQUIP_SHOULDER_PAD_POS_X, \
                (SlotBuffers.ShoulderPad.Height << 8) | SlotBuffers.ShoulderPad.Width, \
                Inventory.Display.Slots.Slot_2x2

Belt            ; состояние слота - пояс
                MAKE_SLOT \
                Adr.BuffersSlots.Belt.Attributes, Size.BuffersSlots.Belt.Attributes, \
                Adr.BuffersSlots.Belt.Background, Size.BuffersSlots.Belt.Background, \
                (SCR_EQUIP_BELT_POS_Y << 8) | SCR_EQUIP_BELT_POS_X, \
                (SlotBuffers.Belt.Height << 8) | SlotBuffers.Belt.Width, \
                Inventory.Display.Slots.Slot_2x1

LeftHand        ; состояние слота - левая рука
                MAKE_SLOT \
                Adr.BuffersSlots.LeftHand.Attributes, Size.BuffersSlots.LeftHand.Attributes, \
                Adr.BuffersSlots.LeftHand.Background, Size.BuffersSlots.LeftHand.Background, \
                (SCR_EQUIP_LEFT_HAND_POS_Y << 8) | SCR_EQUIP_LEFT_HAND_POS_X, \
                (SlotBuffers.LeftHand.Height << 8) | SlotBuffers.LeftHand.Width, \
                Inventory.Display.Slots.Slot_2x3

RightHand       ; состояние слота - правая рука
                MAKE_SLOT \
                Adr.BuffersSlots.RightHand.Attributes, Size.BuffersSlots.RightHand.Attributes, \
                Adr.BuffersSlots.RightHand.Background, Size.BuffersSlots.RightHand.Background, \
                (SCR_EQUIP_RIGHT_HAND_POS_Y << 8) | SCR_EQUIP_RIGHT_HAND_POS_X, \
                (SlotBuffers.RightHand.Height << 8) | SlotBuffers.RightHand.Width, \
                Inventory.Display.Slots.Slot_2x3

LeftRing        ; состояние слота - кольцо левой руки
                MAKE_SLOT \
                Adr.BuffersSlots.LeftRing.Attributes, Size.BuffersSlots.LeftRing.Attributes, \
                Adr.BuffersSlots.LeftRing.Background, Size.BuffersSlots.LeftRing.Background, \
                (SCR_EQUIP_LEFT_RING_POS_Y << 8) | SCR_EQUIP_LEFT_RING_POS_X, \
                (SlotBuffers.LeftRing.Height << 8) | SlotBuffers.LeftRing.Width, \
                Inventory.Display.Slots.Slot_1x1

RightRing       ; состояние слота - кольцо правой руки
                MAKE_SLOT \
                Adr.BuffersSlots.RightRing.Attributes, Size.BuffersSlots.RightRing.Attributes, \
                Adr.BuffersSlots.RightRing.Background, Size.BuffersSlots.RightRing.Background, \
                (SCR_EQUIP_RIGHT_RING_POS_Y << 8) | SCR_EQUIP_RIGHT_RING_POS_X, \
                (SlotBuffers.RightRing.Height << 8) | SlotBuffers.RightRing.Width, \
                Inventory.Display.Slots.Slot_1x1

Boot            ; состояние слота - обувь
                MAKE_SLOT \
                Adr.BuffersSlots.Boot.Attributes, Size.BuffersSlots.Boot.Attributes, \
                Adr.BuffersSlots.Boot.Background, Size.BuffersSlots.Boot.Background, \
                (SCR_EQUIP_BOOT_POS_Y << 8) | SCR_EQUIP_BOOT_POS_X, \
                (SlotBuffers.Boot.Height << 8) | SlotBuffers.Boot.Width, \
                Inventory.Display.Slots.Slot_2x2

Num             EQU ($-Head) / FInventorySlotStates                             ; количество состояний слотов
                endmodule

                endif ; ~_MODULE_INVENTORY_STATES_SLOTS_

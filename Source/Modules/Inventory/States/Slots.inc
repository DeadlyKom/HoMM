
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
                (SCR_EQUIP_HEAD_POS_Y << 8) | (SCR_EQUIP_HEAD_POS_X - 1), \
                (SlotBuffers.Head.Height << 8) | SlotBuffers.Head.Width, \
                Inventory.Display.Slots.Slot_2x2
Breast          ; состояние слота - грудь
                MAKE_SLOT \
                Adr.BuffersSlots.Breast.Attributes, Size.BuffersSlots.Breast.Attributes, \
                Adr.BuffersSlots.Breast.Background, Size.BuffersSlots.Breast.Background, \
                #0000, #0000, #0000

Amulet          ; состояние слота - амулет
                MAKE_SLOT \
                Adr.BuffersSlots.Amulet.Attributes, Size.BuffersSlots.Amulet.Attributes, \
                Adr.BuffersSlots.Amulet.Background, Size.BuffersSlots.Amulet.Background, \
                #0000, #0000, #0000

ShoulderPad     ; состояние слота - наплечник/плащ
                MAKE_SLOT \
                Adr.BuffersSlots.ShoulderPad.Attributes, Size.BuffersSlots.ShoulderPad.Attributes, \
                Adr.BuffersSlots.ShoulderPad.Background, Size.BuffersSlots.ShoulderPad.Background, \
                #0000, #0000, #0000

Belt            ; состояние слота - пояс
                MAKE_SLOT \
                Adr.BuffersSlots.Belt.Attributes, Size.BuffersSlots.Belt.Attributes, \
                Adr.BuffersSlots.Belt.Background, Size.BuffersSlots.Belt.Background, \
                #0000, #0000, #0000

LeftHand        ; состояние слота - левая рука
                MAKE_SLOT \
                Adr.BuffersSlots.LeftHand.Attributes, Size.BuffersSlots.LeftHand.Attributes, \
                Adr.BuffersSlots.LeftHand.Background, Size.BuffersSlots.LeftHand.Background, \
                #0000, #0000, #0000

RightHand       ; состояние слота - правая рука
                MAKE_SLOT \
                Adr.BuffersSlots.RightHand.Attributes, Size.BuffersSlots.RightHand.Attributes, \
                Adr.BuffersSlots.RightHand.Background, Size.BuffersSlots.RightHand.Background, \
                #0000, #0000, #0000

LeftRing        ; состояние слота - кольцо левой руки
                MAKE_SLOT \
                Adr.BuffersSlots.LeftRing.Attributes, Size.BuffersSlots.LeftRing.Attributes, \
                Adr.BuffersSlots.LeftRing.Background, Size.BuffersSlots.LeftRing.Background, \
                #0000, #0000, #0000

RightRing       ; состояние слота - кольцо правой руки
                MAKE_SLOT \
                Adr.BuffersSlots.RightRing.Attributes, Size.BuffersSlots.RightRing.Attributes, \
                Adr.BuffersSlots.RightRing.Background, Size.BuffersSlots.RightRing.Background, \
                #0000, #0000, #0000

Boot            ; состояние слота - обувь
                MAKE_SLOT \
                Adr.BuffersSlots.Boot.Attributes, Size.BuffersSlots.Boot.Attributes, \
                Adr.BuffersSlots.Boot.Background, Size.BuffersSlots.Boot.Background, \
                #0000, #0000, #0000
                endmodule

                endif ; ~_MODULE_INVENTORY_STATES_SLOTS_

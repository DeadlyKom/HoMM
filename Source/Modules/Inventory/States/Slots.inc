
                ifndef _MODULE_INVENTORY_STATES_SLOTS_
                define _MODULE_INVENTORY_STATES_SLOTS_

                module Slots

; -----------------------------------------
; создание состояния слота с адресами буферов
; -----------------------------------------
MAKE_SLOT       macro AttributesAdr?, AttributesSize?, BackgroundAdr?, BackgroundSize?
                FInventorySlotStates {
                    #00,
                    #00,
                    AttributesAdr? + AttributesSize? - 4,
                    BackgroundAdr? + BackgroundSize? - 4
                }
                endm

Head            ; состояние слота - голова
                MAKE_SLOT \
                Adr.BuffersSlots.Head.Attributes, Size.BuffersSlots.Head.Attributes, \
                Adr.BuffersSlots.Head.Background, Size.BuffersSlots.Head.Background
Breast          ; состояние слота - грудь
                MAKE_SLOT \
                Adr.BuffersSlots.Breast.Attributes, Size.BuffersSlots.Breast.Attributes, \
                Adr.BuffersSlots.Breast.Background, Size.BuffersSlots.Breast.Background

Amulet          ; состояние слота - амулет
                MAKE_SLOT \
                Adr.BuffersSlots.Amulet.Attributes, Size.BuffersSlots.Amulet.Attributes, \
                Adr.BuffersSlots.Amulet.Background, Size.BuffersSlots.Amulet.Background

ShoulderPad     ; состояние слота - наплечник/плащ
                MAKE_SLOT \
                Adr.BuffersSlots.ShoulderPad.Attributes, Size.BuffersSlots.ShoulderPad.Attributes, \
                Adr.BuffersSlots.ShoulderPad.Background, Size.BuffersSlots.ShoulderPad.Background

Belt            ; состояние слота - пояс
                MAKE_SLOT \
                Adr.BuffersSlots.Belt.Attributes, Size.BuffersSlots.Belt.Attributes, \
                Adr.BuffersSlots.Belt.Background, Size.BuffersSlots.Belt.Background

LeftHand        ; состояние слота - левая рука
                MAKE_SLOT \
                Adr.BuffersSlots.LeftHand.Attributes, Size.BuffersSlots.LeftHand.Attributes, \
                Adr.BuffersSlots.LeftHand.Background, Size.BuffersSlots.LeftHand.Background

RightHand       ; состояние слота - правая рука
                MAKE_SLOT \
                Adr.BuffersSlots.RightHand.Attributes, Size.BuffersSlots.RightHand.Attributes, \
                Adr.BuffersSlots.RightHand.Background, Size.BuffersSlots.RightHand.Background

LeftRing        ; состояние слота - кольцо левой руки
                MAKE_SLOT \
                Adr.BuffersSlots.LeftRing.Attributes, Size.BuffersSlots.LeftRing.Attributes, \
                Adr.BuffersSlots.LeftRing.Background, Size.BuffersSlots.LeftRing.Background

RightRing       ; состояние слота - кольцо правой руки
                MAKE_SLOT \
                Adr.BuffersSlots.RightRing.Attributes, Size.BuffersSlots.RightRing.Attributes, \
                Adr.BuffersSlots.RightRing.Background, Size.BuffersSlots.RightRing.Background

Boot            ; состояние слота - обувь
                MAKE_SLOT \
                Adr.BuffersSlots.Boot.Attributes, Size.BuffersSlots.Boot.Attributes, \
                Adr.BuffersSlots.Boot.Background, Size.BuffersSlots.Boot.Background
                endmodule

                endif ; ~_MODULE_INVENTORY_STATES_SLOTS_

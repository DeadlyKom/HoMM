
                ifndef _MODULE_INVENTORY_UI_LAYERS_
                define _MODULE_INVENTORY_UI_LAYERS_
Layers:         ; слои игрового окна
.Inventory      MAKE_UI_LAYER Inventory, Inventory.ElementNum, LAYER_UI_VISIBLE
.Inventory.Num  EQU ($-Layers.Inventory) / FUILayer
Inventory:      ; слой инвентаря
                
                ; область слота экипировки инвентаря "голова"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_HEAD_POS_X << 3, SCR_EQUIP_HEAD_POS_Y << 3, \
                SCR_EQUIP_HEAD_SIZE_X << 3, SCR_EQUIP_HEAD_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotHead.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotHead, \
                Inventory.UI.Handler.Layer_SlotHead.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

                ; область слота экипировки инвентаря "грудь"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_BREAST_POS_X << 3, SCR_EQUIP_BREAST_POS_Y << 3, \
                SCR_EQUIP_BREAST_SIZE_X << 3, SCR_EQUIP_BREAST_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotBrst.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotBrst, \
                Inventory.UI.Handler.Layer_SlotBrst.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

                ; область слота экипировки инвентаря "амулет"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_AMULET_POS_X << 3, SCR_EQUIP_AMULET_POS_Y << 3, \
                SCR_EQUIP_AMULET_SIZE_X << 3, SCR_EQUIP_AMULET_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotAmlt.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotAmlt, \
                Inventory.UI.Handler.Layer_SlotAmlt.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

                ; область слота экипировки инвентаря "наплечник/плащ"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_SHOULDER_PAD_POS_X << 3, SCR_EQUIP_SHOULDER_PAD_POS_Y << 3, \
                SCR_EQUIP_SHOULDER_PAD_SIZE_X << 3, SCR_EQUIP_SHOULDER_PAD_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotShld.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotShld, \
                Inventory.UI.Handler.Layer_SlotShld.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

                ; область слота экипировки инвентаря "пояс"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_BELT_POS_X << 3, SCR_EQUIP_BELT_POS_Y << 3, \
                SCR_EQUIP_BELT_SIZE_X << 3, SCR_EQUIP_BELT_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotBelt.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotBelt, \
                Inventory.UI.Handler.Layer_SlotBelt.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

                ; область слота экипировки инвентаря "левая рука"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_LEFT_HAND_POS_X << 3, SCR_EQUIP_LEFT_HAND_POS_Y << 3, \
                SCR_EQUIP_LEFT_HAND_SIZE_X << 3, SCR_EQUIP_LEFT_HAND_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotLHnd.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotLHnd, \
                Inventory.UI.Handler.Layer_SlotLHnd.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

                ; область слота экипировки инвентаря "правая рука"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_RIGHT_HAND_POS_X << 3, SCR_EQUIP_RIGHT_HAND_POS_Y << 3, \
                SCR_EQUIP_RIGHT_HAND_SIZE_X << 3, SCR_EQUIP_RIGHT_HAND_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotRHnd.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotRHnd, \
                Inventory.UI.Handler.Layer_SlotRHnd.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

                ; область слота экипировки инвентаря "левое кольцо"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_LEFT_RING_POS_X << 3, SCR_EQUIP_LEFT_RING_POS_Y << 3, \
                SCR_EQUIP_LEFT_RING_SIZE_X << 3, SCR_EQUIP_LEFT_RING_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotLRng.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotLRng, \
                Inventory.UI.Handler.Layer_SlotLRng.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

                ; область слота экипировки инвентаря "правое кольцо"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_RIGHT_RING_POS_X << 3, SCR_EQUIP_RIGHT_RING_POS_Y << 3, \
                SCR_EQUIP_RIGHT_RING_SIZE_X << 3, SCR_EQUIP_RIGHT_RING_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotRRng.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotRRng, \
                Inventory.UI.Handler.Layer_SlotRRng.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

                ; область слота экипировки инвентаря "обувь"
                MAKE_UI_ELEMENT_EX \
                SCR_EQUIP_BOOT_POS_X << 3, SCR_EQUIP_BOOT_POS_Y << 3, \
                SCR_EQUIP_BOOT_SIZE_X << 3, SCR_EQUIP_BOOT_SIZE_Y << 3, \
                Inventory.UI.Handler.Layer_SlotBoot.OnMouseEnter, \
                Inventory.UI.Handler.Layer_SlotBoot, \
                Inventory.UI.Handler.Layer_SlotBoot.OnMouseLeave, \
                UI_VISIBLE | UI_ENABLED

.ElementNum     EQU ($-Inventory) / FUIElement

                display " - UI layers 'Inventory':\t\t\t\t\t\t= busy [ ", /D, $-Layers, " byte(s) ]"
    
                endif ; ~ _MODULE_INVENTORY_UI_LAYERS_

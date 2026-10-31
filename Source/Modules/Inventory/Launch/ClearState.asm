
                ifndef _MODULE_INVENTORY_LAUNCH_CLEAR_STATE_
                define _MODULE_INVENTORY_LAUNCH_CLEAR_STATE_
; -----------------------------------------
; очистка состояний "инвентаря"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
ClearState:     ; очистка флагов и анимации слотов
                LD HL, Inventory.States.Slots.Head
                LD DE, FInventorySlotStates - FInventorySlotStates.Delay
                LD B, Inventory.States.Slots.Num
                XOR A

.SlotsLoop      ; сброс состояния текущего слота
                LD (HL), A
                INC HL
                LD (HL), A
                INC HL
                LD (HL), A

                ; переход к состоянию следующего слота
                ADD HL, DE
                DJNZ .SlotsLoop

                LD (Inventory.States.HoveredItem.Flags), A                      ; сброс запросов перерисовки фона и рисования описания

                ; сброс идентификатора предмета под курсором
                LD A, ITEM_ID_NONE
                LD (Inventory.States.HoveredItem.ID), A

                RET

                endif                                                           ; ~_MODULE_INVENTORY_LAUNCH_CLEAR_STATE_

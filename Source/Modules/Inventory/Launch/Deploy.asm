
                ifndef _MODULE_INVENTORY_LAUNCH_DEPLOY_
                define _MODULE_INVENTORY_LAUNCH_DEPLOY_
; -----------------------------------------
; развёртывание кода "инвентаря"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "инвентаря"
; -----------------------------------------
Deploy:         RES_USER_HANDLER                                                ; отключение обработчика прерывания перед заменой SharedCode
                HALT                                                            ; синхронизация

                ; копирование блока SharedCode в общую область памяти
                MEMCPY Inventory.Adr.Deploy, Adr.Inventory, \
                            Inventory.Size.Deploy
                RET

                endif ; ~_MODULE_INVENTORY_LAUNCH_DEPLOY_

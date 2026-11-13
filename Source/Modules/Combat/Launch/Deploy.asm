
                ifndef _MODULE_COMBAT_LAUNCH_DEPLOY_
                define _MODULE_COMBAT_LAUNCH_DEPLOY_
; -----------------------------------------
; развёртывание кода "сражения"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "сражения"
; -----------------------------------------
Deploy:         RES_USER_HANDLER                                                ; отключение обработчика прерывания перед заменой SharedCode
                HALT                                                            ; синхронизация

                ; копирование блока SharedCode в общую область памяти
                MEMCPY Combat.Adr.Deploy, Adr.Combat, \
                            Combat.Size.Deploy
                RET

                endif ; ~_MODULE_COMBAT_LAUNCH_DEPLOY_


                ifndef _MODULE_BATTLE_LAUNCH_DEPLOY_
                define _MODULE_BATTLE_LAUNCH_DEPLOY_
; -----------------------------------------
; развёртывание кода "битвы"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "битвы"
; -----------------------------------------
Deploy:         RES_USER_HANDLER                                                ; отключение обработчика прерывания перед заменой SharedCode
                HALT                                                            ; синхронизация

                ; копирование блока SharedCode в общую область памяти
                MEMCPY Battle.Adr.Deploy, Adr.Battle, \
                            Battle.Size.Deploy
                RET

                endif ; ~_MODULE_BATTLE_LAUNCH_DEPLOY_

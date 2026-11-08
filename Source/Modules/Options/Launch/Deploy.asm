
                ifndef _MODULE_OPTIONS_LAUNCH_DEPLOY_
                define _MODULE_OPTIONS_LAUNCH_DEPLOY_
; -----------------------------------------
; развёртывание кода "опций"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу модуля "опций"
; -----------------------------------------
Deploy:         RES_USER_HANDLER                                                ; отключение обработчика прерывания перед заменой SharedCode
                HALT                                                            ; синхронизация

                ; копирование блока SharedCode в общую область памяти
                MEMCPY Options.Adr.Deploy, Adr.Options, \
                            Options.Size.Deploy
                RET

                endif ; ~_MODULE_OPTIONS_LAUNCH_DEPLOY_

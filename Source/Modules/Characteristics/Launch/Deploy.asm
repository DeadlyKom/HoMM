
                ifndef _MODULE_CHARACTERISTICS_LAUNCH_DEPLOY_
                define _MODULE_CHARACTERISTICS_LAUNCH_DEPLOY_
; -----------------------------------------
; развёртывание кода "характеристик"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "характеристик"
; -----------------------------------------
Deploy:         RES_USER_HANDLER                                                ; отключение обработчика прогресса перед заменой SharedCode
                HALT                                                            ; синхронизация

                ; копирование блока SharedCode в общую область памяти
                MEMCPY Characteristics.Adr.Deploy, Adr.Characteristics, \
                            Characteristics.Size.Deploy
                RET

                endif ; ~_MODULE_CHARACTERISTICS_LAUNCH_DEPLOY_


                ifndef _MODULE_CHARACTERISTICS_LAUNCH_DEPLOY_
                define _MODULE_CHARACTERISTICS_LAUNCH_DEPLOY_
; -----------------------------------------
; развёртывание кода "характеристик"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ необходимо включить страницу модуля "характеристик"
; -----------------------------------------
Deploy:         RES_USER_HANDLER                                                ; отключение обработчика прогресса перед заменой SharedCode
                HALT                                                            ; синхронизация

                ; копирование блока SharedCode в общую область памяти
                MEMCPY Characteristics.Adr.Deploy, Adr.Characteristics, \
                            Characteristics.Size.Deploy

                ; перенос кода эффекта в страни цу 7
                JP Characteristics.VFX.FallingBlocks.Deploy

                endif ; ~_MODULE_CHARACTERISTICS_LAUNCH_DEPLOY_

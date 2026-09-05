
                ifndef _MODULE_WORLD_LAUNCH_DEPLOY_
                define _MODULE_WORLD_LAUNCH_DEPLOY_
; -----------------------------------------
; развёртывание кода "мира"
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
; -----------------------------------------
Deploy:         RES_USER_HANDLER                                                ; отключение обработчика прогресса перед заменой SharedCode
                HALT                                                            ; синхронизация
                ATTR_IPB SCR_ADR_BASE, BLACK, BLACK, 0                          ; скрытие атрибутами основного экрана
                MEMCPY World.Adr.Deploy.World, Adr.World, \
                            World.Size.Deploy.World                             ; копирование блока
                MEMCPY_PAGE World.Adr.Deploy.SharedScreen, Adr.SharedScreen, \
                            Page.SharedScreen, World.Size.Deploy.SharedScreen   ; копирование блока между страницами

                ; установка порога завершения развёртывания кода "мира"
                PROGRESS_PERCENT_FIXED WORLD_PROGRESS_DEPLOY_END
                JP_LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress

                endif ; ~_MODULE_WORLD_LAUNCH_DEPLOY_

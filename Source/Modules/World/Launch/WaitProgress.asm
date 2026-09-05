
                ifndef _MODULE_WORLD_LAUNCH_WAIT_PROGRESS_
                define _MODULE_WORLD_LAUNCH_WAIT_PROGRESS_
; -----------------------------------------
; ожидание завершения загрузки "мира"
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу модуля "мира"
; -----------------------------------------
WaitProgress:   ; установка порога завершения загрузки "мира"
                PROGRESS_PERCENT_FIXED WORLD_PROGRESS_END
                LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress
                DELAY 1                                                         ; небольшая задержка перед отображением "мира"
                ; освобождение окна прогресса
                JP_LAUNCH_ASSET_FUNCTION Progress.Release, ExecuteModule.Progress

                endif ; ~_MODULE_WORLD_LAUNCH_WAIT_PROGRESS_

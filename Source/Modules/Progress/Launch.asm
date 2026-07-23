
                ifndef _MODULE_PROGRESS_LAUNCH_
                define _MODULE_PROGRESS_LAUNCH_
; -----------------------------------------
; запуск "прогресса"
; In:
;   SP+0 - идентификатор фактически запрошенной функции
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
;
;    пример продвижения на указанный шаг:
;       PROGRESS_PERCENT_FIXED 3.8
;       LAUNCH_ASSET_FUNCTION Progress.EnterProgress, ExecuteModule.Progress
;
;    пример продвижения до фиксированного процента:
;       PROGRESS_PERCENT_FIXED 50.0
;       LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress
; -----------------------------------------
Launch:         ; первичная инициализация загруженного ассета "сессии"
                ; на вершине стека лежит исходный FunctionID (Make/Load)

                ; сохранение страницы
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Kernel.Modules.Progress.Page), A

                ; повторный вход в диспетчер уже инициализированного ассета;
                ; исходный FunctionID сохранён в стеке
                LD HL, (GameState.Assets + FAssets.Address.Adr)
                JP (HL)

                display " - Launch:\t\t\t\t\t\t\t     \t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_PROGRESS_LAUNCH_

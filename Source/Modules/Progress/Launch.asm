
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
Launch:         ; первичная инициализация загруженного ассета Progress
                ; на вершине стека лежит идентификатор запрошенной функции

                ; сохранение страницы и адреса загруженного модуля
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Kernel.Modules.Progress.Page), A

                LD HL, (GameState.Assets + FAssets.Address.Adr)
                LD (Kernel.Modules.Progress.Address), HL

                ; повторный вход в диспетчер уже инициализированного ассета
                ; HL содержит адрес диспетчера, а идентификатор функции сохранён в стеке
                JP (HL)

                display " - Launch:\t\t\t\t\t\t\t     \t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_PROGRESS_LAUNCH_

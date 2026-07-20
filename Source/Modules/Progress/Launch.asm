
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

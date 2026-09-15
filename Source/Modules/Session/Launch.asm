
                ifndef _MODULE_SESSION_LAUNCH_
                define _MODULE_SESSION_LAUNCH_
; -----------------------------------------
; запуск "сессии"
; In:
;   SP+0 - идентификатор фактически запрошенной функции (Make/Load)
; Out:
; Corrupt:
; Note:
;    ℹ️ адрес исполнения неизвестен
; -----------------------------------------
Launch:         ; первичная инициализация загруженного ассета "сессии"
                ; на вершине стека лежит исходный FunctionID (Make/Load)

                ; сохранение страницы
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Kernel.Modules.Session.Page), A

                ; повторный вход в диспетчер уже инициализированного ассета;
                ; исходный FunctionID (Make/Load) сохранён в стеке
                LD HL, (GameState.Assets + FAssets.Address.Adr)
                JP (HL)

                display " - Launch:\t\t\t\t\t\t\t     \t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_SESSION_LAUNCH_


                ifndef _MODULE_SESSION_LAUNCH_
                define _MODULE_SESSION_LAUNCH_
; -----------------------------------------
; запуск "сессии"
; In:
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
; -----------------------------------------
Launch:         ; сохранение страницы
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Kernel.Modules.Session.Page), A

                ; т.к. функций вызова > 1, необходимо вызывать после инициализации
                ; фактически требуемую функцию
                LD HL, (GameState.Assets + FAssets.Address.Adr)
                JP (HL)

                display " - Launch:\t\t\t\t\t\t\t     \t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_SESSION_LAUNCH_

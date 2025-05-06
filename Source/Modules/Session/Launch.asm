
                ifndef _SESSION_LAUNCH_
                define _SESSION_LAUNCH_
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

                RET

                display " - Launch \'Session\':\t\t\t\t\t\t     \t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_SESSION_LAUNCH_

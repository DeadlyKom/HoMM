
                ifndef _ENTRY_POINT_
                define _ENTRY_POINT_
; -----------------------------------------
; точка входа
; In:
; Out:
; Corrupt:
; Note:
;   #74C0, размер 64 байта
; -----------------------------------------
EntryPoint:     EI
                HALT

                CALL ExecuteModule.Core                                         ; запуск "ядра"
                CALL ExecuteModule.MainMenu                                     ; запуск "главного меню"

                endif ; ~_ENTRY_POINT_

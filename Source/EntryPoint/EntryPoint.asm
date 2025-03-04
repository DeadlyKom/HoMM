
                ifndef _ENTRY_POINT_
                define _ENTRY_POINT_
; -----------------------------------------
; точка входа
; In:
; Out:
; Corrupt:
; Note:
;   #73C0, размер 64 байта
; -----------------------------------------
EntryPoint:     EI
                HALT

                CALL ExecuteModule.Core                                         ; запуск "ядра"
                CALL ExecuteModule.World                                        ; запуск "мира"

                endif ; ~_ENTRY_POINT_

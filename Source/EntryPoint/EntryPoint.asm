
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

                ; инициализация
                CALL ExecuteModule.Core                                         ; инициализация ядра

                endif ; ~_ENTRY_POINT_

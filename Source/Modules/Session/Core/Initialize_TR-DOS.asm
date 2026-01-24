
                ifndef _MODULE_SESSION_CORE_INITIALIZE_TR_DOS_
                define _MODULE_SESSION_CORE_INITIALIZE_TR_DOS_
; -----------------------------------------
; инициализация TR-DOS
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Init_TR_DOS:    ; инициализация
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                ASSETS_TRDOS                                                    ; перенос драйвера TR-DOS во временный буффер

                ; восстановление страницы расположения ассета
                JP_SET_MODULE_PAGE_Session                                      ; включить страницу модуля "Session"

                display " - Initialize TR-DOS:\t\t\t\t\t", /A, Init_TR_DOS, "\t= busy [ ", /D, $-Init_TR_DOS, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_CORE_INITIALIZE_TR_DOS_

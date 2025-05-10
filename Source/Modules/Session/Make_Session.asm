
                ifndef _MODULE_SESSION_MAKE_
                define _MODULE_SESSION_MAKE_
; -----------------------------------------
; запуск "сессии"
; In:
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
; -----------------------------------------
Make_Session:   ; копирование блока
                MEMCPY Adr.Deploy, Adr.Session, Size.Deploy

                CALL SharedCode.SaveSlot.Init_TR_DOS                            ; инициализация TR-DOS
                CALL SharedCode.SaveSlot.Make_Info                              ; создание слота сохранения
                CALL SharedCode.SaveSlot.Save_Info                              ; сохранение информации о слоте сохранения

                RET

                display " - Make 'Session':\t\t\t\t\t\t     \t= busy [ ", /D, $-Make_Session, " byte(s) ]"

                endif ; ~_MODULE_SESSION_MAKE_


                ifndef _MODULE_SESSION_LOAD_
                define _MODULE_SESSION_LOAD_
; -----------------------------------------
; запуск "сессии"
; In:
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
; -----------------------------------------
Load_Session:   ; копирование блока
                MEMCPY Adr.Deploy, Adr.Session, Size.Deploy

                CALL SharedCode.SaveSlot.Init_TR_DOS                            ; инициализация TR-DOS
                CALL SharedCode.SaveSlot.Load_Info                              ; загрузка информации о слоте сохранения
                CALL SharedCode.SaveSlot.Validation                             ; вализация информации о слоте сохранения

                JR$

                ; ; загрузка карты
                ; LD A, (GameSession.SaveSlot + FSaveSlot.MapID)
                ; CALL Load_Map

                display " - Load 'Session':\t\t\t\t\t\t     \t= busy [ ", /D, $-Load_Session, " byte(s) ]"

                endif ; ~_MODULE_SESSION_LOAD_

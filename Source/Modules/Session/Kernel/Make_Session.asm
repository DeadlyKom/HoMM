
                ifndef _MODULE_SESSION_MAKE_
                define _MODULE_SESSION_MAKE_
; -----------------------------------------
; создание "сессии"
; In:
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
; -----------------------------------------
Make_Session:   ; копирование блока
                MEMCPY Adr.Deploy, Adr.Session, Size.Deploy

                CALL SharedCode.Core.Init_TR_DOS                                ; инициализация TR-DOS
                CALL SharedCode.SaveSlot.Make_Info                              ; создание слота сохранения
                CALL SharedCode.SaveSlot.Save_Info                              ; сохранение информации о слоте сохранения

                ; ToDo: в будущем предоставить пользователю сообщение об ошибке
                DEBUG_BREAK_POINT_NC                                            ; ошибка, слот сохранения не является корректным

                JP SharedCode.Core.ReleaseAsset                                 ; освобождение текущего ресурса

                display " - Make 'Session':\t\t\t\t\t\t     \t= busy [ ", /D, $-Make_Session, " byte(s) ]"

                endif ; ~_MODULE_SESSION_MAKE_

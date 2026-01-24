
                ifndef _MODULE_SESSION_LOAD_
                define _MODULE_SESSION_LOAD_
; -----------------------------------------
; загрузка "сессии"
; In:
; Out:
; Corrupt:
; Note:
;    адрес исполнения неизвестен
; -----------------------------------------
Load_Session:   ; копирование блока
                MEMCPY Adr.Deploy, Adr.Session, Size.Deploy

                CALL SharedCode.Core.Init_TR_DOS                                ; инициализация TR-DOS
                CALL SharedCode.SaveSlot.Load_Info                              ; загрузка информации о слоте сохранения
                ; ToDo: в будущем предоставить пользователю сообщение об ошибке
                DEBUG_BREAK_POINT_NC                                            ; ошибка, слот сохранения не является корректным

                CALL SharedCode.SaveSlot.Validation                             ; вализация информации о слоте сохранения
                ; ToDo: в будущем предоставить пользователю сообщение об ошибке
                DEBUG_BREAK_POINT_NC                                            ; ошибка, слот сохранения не прошёл валидацию

                ; загрузка карты
                LD A, (GameSession.SaveSlot + FSaveSlot.MapID)
                CALL SharedCode.Load.Map

                JP SharedCode.Core.ReleaseAsset                                 ; освобождение текущего ресурса ("сессии")

                display " - Load 'Session':\t\t\t\t\t\t     \t= busy [ ", /D, $-Load_Session, " byte(s) ]"

                endif ; ~_MODULE_SESSION_LOAD_

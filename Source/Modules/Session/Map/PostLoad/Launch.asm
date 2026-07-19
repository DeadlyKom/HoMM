                
                ifndef _MODULE_SESSION_MAP_POST_LOAD_LAUNCH_
                define _MODULE_SESSION_MAP_POST_LOAD_LAUNCH_
; -----------------------------------------
; подготовка карты к использованию
; In:
; Out:
; Corrupt:
; Note:
;   код расположен в общей
; -----------------------------------------
Launch:         CALL Session.SharedCode.Director.Initialize                     ; инициализация директора управления популяцией ИИ
                CALL Session.SharedCode.Director.Initial.Spawn                  ; запуск начального заселения
                CALL Cartography.Launch                                         ; запуск картографии
                RET

                endif ; ~_MODULE_SESSION_MAP_POST_LOAD_LAUNCH_

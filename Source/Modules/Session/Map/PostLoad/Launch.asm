                
                ifndef _MODULE_SESSION_MAP_POST_LOAD_LAUNCH_
                define _MODULE_SESSION_MAP_POST_LOAD_LAUNCH_
; -----------------------------------------
; подготовка карты к использованию
; In:
; Out:
; Corrupt:
; Note:
;   код расположен в общей
;
;   последовательность подготовки карты:
;
;   загрузка блоков карты
;   ├─ подготовка свойств карты
;   └─ Director.Initialize
;       └─ проверка SpawnPointList
;           │
;           ├─ список существует ───────────────────────┐
;           │                                           │
;           └─ списка нет                               │
;               ├─ формирование карты расстояний        │
;               ├─ LocationSearch                       │
;               └─ SpawnPointFormation ─────────────────┤
;                                                       ↓
;                                                 Initial.Spawn
;                                                       ↓
;                                                  Cartography
;                                                       ↓
;                                                   завершение
; -----------------------------------------
Launch:         SET_PAGE_MAP                                                    ; включить страницу работы с картой
                CALL Session.SharedCode.Director.Initialize                     ; инициализация директора управления популяцией ИИ
                CALL Session.SharedCode.Director.Initial.Spawn                  ; запуск начального заселения
                CALL Cartography.Launch                                         ; запуск картографии
                SET_MODULE_PAGE_Session                                         ; включить страницу модуля "Session"
                RET

                endif ; ~_MODULE_SESSION_MAP_POST_LOAD_LAUNCH_

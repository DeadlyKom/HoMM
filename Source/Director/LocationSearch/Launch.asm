                
                ifndef _AI_DIRECTOR_LOCATION_SEARCH_LAUNCH_
                define _AI_DIRECTOR_LOCATION_SEARCH_LAUNCH_
; -----------------------------------------
; поиск подходящих мест для формирования "точек спавна"
; In:
; Out:
; Corrupt:
; Note:
;   код расположен в общей
;
;   обходит карту по гексам и проверяет каждый гекс по всем SpawnPattern
;   постоянные свойства читаются из данных карты, промежуточные результаты
;   сохраняются в рабочем буфере директора
; -----------------------------------------
                ; ToDo:
                ;   - подготовить пространственные данные и поля расстояний
                ;   - обойти все гексы карты
                ;   - проверить условия каждого SpawnPattern
                ;   - сохранить подходящие гексы и найденные паттерны
                ;     для SpawnPointFormation

Launch:         ; пример продвижения на указанный шаг
                PROGRESS_PERCENT_FIXED 3.8
                LAUNCH_ASSET_FUNCTION Progress.EnterProgress, ExecuteModule.Progress

                ; пример продвижения до фиксированного процента
                PROGRESS_PERCENT_FIXED 100.0
                LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress

                RET

                endif ; ~_AI_DIRECTOR_LOCATION_SEARCH_LAUNCH_

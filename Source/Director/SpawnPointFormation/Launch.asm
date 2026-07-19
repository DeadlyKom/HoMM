                
                ifndef _AI_DIRECTOR_SPAWN_POINT_FORMATION_LAUNCH_
                define _AI_DIRECTOR_SPAWN_POINT_FORMATION_LAUNCH_
; -----------------------------------------
; формирование постоянного SpawnPointList из результатов LocationSearch
; In:
; Out:
; Corrupt:
; Note:
;   код расположен в общей
;   выполняется после LocationSearch только при отсутствии готового списка
;   индекс созданной SpawnPoint остаётся постоянным и используется как HomeID
; -----------------------------------------
                ; ToDo:
                ;   - прочитать найденные гексы из рабочего буфера директора
                ;   - разрешить пересечения совместимых SpawnPattern
                ;   - учесть приоритеты паттернов
                ;   - проверить минимальный радиус до существующих SpawnPoint
                ;   - объединить паттерны с подходящей существующей точкой
                ;     либо создать новую SpawnPoint;
                ;   - сформировать стабильный SpawnPointList
                ;   - записать итоговое количество в FAIDirector.SpawnPointNum
                ;   - освободить рабочий буфер Директора
Launch:         RET

                endif ; ~_AI_DIRECTOR_SPAWN_POINT_FORMATION_LAUNCH_

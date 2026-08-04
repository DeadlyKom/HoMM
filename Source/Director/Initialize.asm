                
                ifndef _AI_DIRECTOR_INITIALIZE_
                define _AI_DIRECTOR_INITIALIZE_
; -----------------------------------------
; однократная инициализация директора после загрузки карты
; In:
; Out:
; Corrupt:
; Note:
;   код расположен в общей
; -----------------------------------------
Initialize:     ; проверка наличия списка "точек спавна"
                LD A, (AIDirector + FAIDirector.SpawnPointNum)
                OR A
                JR NZ, .Complete                                                ; переход, если список точек спавна уже существует

                CALL DistanceMap.Launch                                         ; формирование карты расстояний
                CALL LocationSearch.Launch                                      ; поиск мест для точек спавна

                ; установка порога завершения поиска мест
                PROGRESS_PERCENT_FIXED DIRECTOR_PROGRESS_LOCATION_SEARCH_END
                CALL ProgressToPercent
                CALL SpawnPointFormation.Launch                                 ; формирование списка точек спавна

.Complete       ; установка порога завершения работы директора
                PROGRESS_PERCENT_FIXED DIRECTOR_PROGRESS_END
                JP ProgressToPercent

                endif ; ~_AI_DIRECTOR_INITIALIZE_

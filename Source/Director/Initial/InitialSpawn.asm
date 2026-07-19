                
                ifndef _AI_DIRECTOR_INITIAL_SPAWN_
                define _AI_DIRECTOR_INITIAL_SPAWN_
; -----------------------------------------
; начальное заселение карты
; In:
; Out:
; Corrupt:
; Note:
;   код расположен в общей
; -----------------------------------------
Initial.Spawn:  ; проверка наличия списка "точек спавна"
                LD A, (AIDirector + FAIDirector.SpawnPointNum)
                OR A
                RET Z                                                           ; начальное заселение невозможно

                ; ToDo: начальное заселение:
                ;   - PopulationControl: определить свободный лимит популяции
                ;   - SpawnPointOccupancy: определить занятые HomeID
                ;   - SpawnPointSelection: выбрать доступную точку
                ;   - SpawnBudget: рассчитать бюджет новой группы
                ;   - GroupFormation: сформировать состав отряда
                ;   - создать группу и связать её со SpawnPoint через HomeID
                ;   - повторять до заполнения начального лимита либо до
                ;     отсутствия доступных точек

                RET

                endif ; ~_AI_DIRECTOR_INITIAL_SPAWN_

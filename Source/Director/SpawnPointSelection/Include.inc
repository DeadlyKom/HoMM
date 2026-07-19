                
                ifndef _AI_DIRECTOR_SPAWN_POINT_SELECTION_INCLUDE_
                define _AI_DIRECTOR_SPAWN_POINT_SELECTION_INCLUDE_

                ; выбор точки из готового SpawnPointList
                ; ToDo:
                ;   - пропускать выключенные точки и точки с активным Cooldown
                ;   - пропускать точки, занятые существующей группой по HomeID
                ;   - проверять SpawnTableID, вероятность и условия режима
                ;   - вернуть одну выбранную точку либо признак отсутствия выбора
                module SpawnPointSelection
                
                endmodule

                endif ; ~_AI_DIRECTOR_SPAWN_POINT_SELECTION_INCLUDE_

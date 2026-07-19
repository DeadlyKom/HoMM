                
                ifndef _AI_DIRECTOR_SPAWN_POINT_OCCUPANCY_INCLUDE_
                define _AI_DIRECTOR_SPAWN_POINT_OCCUPANCY_INCLUDE_

                ; определение занятости SpawnPoint существующими группами
                ; ToDo:
                ;   - считать HomeID каждой существующей группы
                ;   - считать соответствующую SpawnPoint занятой независимо
                ;     от текущего удаления группы от домашней точки
                ;   - освободить точку только после удаления группы
                ;   - не создавать отдельный постоянный массив занятости,
                ;     если проверка выполняется совместно с PopulationControl
                module SpawnPointOccupancy
                
                endmodule

                endif ; ~_AI_DIRECTOR_SPAWN_POINT_OCCUPANCY_INCLUDE_

                
                ifndef _AI_DIRECTOR_INITIAL_INCLUDE_
                define _AI_DIRECTOR_INITIAL_INCLUDE_

                module Director
                include "InitialSpawn.asm"
                ; ToDo: добавить режимы запуска директора
                ;   Periodic -> плановое восстановление популяции;
                ;   External -> внеочередная попытка по событию
                endmodule

                endif ; ~_AI_DIRECTOR_INITIAL_INCLUDE_
